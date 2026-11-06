const REPO='MonicaCT/minedu-documentos-privados';
const MAX=10*1024*1024+16;
const UUID=/^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i;
function b64(bytes){let s='';for(let i=0;i<bytes.length;i+=8192)s+=String.fromCharCode(...bytes.subarray(i,i+8192));return btoa(s);}
function safeEqual(a,b){if(typeof a!=='string'||typeof b!=='string')return false;let d=a.length^b.length;for(let i=0;i<Math.max(a.length,b.length);i++)d|=(a.charCodeAt(i)||0)^(b.charCodeAt(i)||0);return d===0;}
function permissions(request,env){
 const supplied=request.headers.get('X-Minedu-Code')||'';
 const codes=JSON.parse(env.DOCUMENT_ACCESS_CODES||'{}');
 if(safeEqual(supplied,codes.committee))return 'committee';
 if(Array.isArray(codes.uploaders)&&codes.uploaders.some(v=>safeEqual(supplied,v)))return 'upload';
 return '';
}
async function github(env,path,body,method='POST',raw=false){
 const r=await fetch('https://api.github.com/repos/'+REPO+path,{method:body===undefined?'GET':method,headers:{Authorization:'Bearer '+env.GITHUB_DOCUMENT_TOKEN,Accept:raw?'application/vnd.github.raw+json':'application/vnd.github+json','User-Agent':'MINEDU-private-documents',...(body===undefined?{}:{'Content-Type':'application/json'})},...(body===undefined?{}:{body:JSON.stringify(body)})});
 if(!r.ok){const e=new Error('No se pudo completar el almacenamiento en GitHub.');e.status=r.status;throw e;}
 return raw?r:r.json();
}
async function commitDocument(env,envelope,cipher){
 const binary=await github(env,'/git/blobs',{encoding:'base64',content:b64(new Uint8Array(cipher))});
 const header={...envelope,contentSha:binary.sha};
 const meta=await github(env,'/git/blobs',{encoding:'utf-8',content:JSON.stringify(header)});
 for(let attempt=0;attempt<4;attempt++){
 const head=await github(env,'/git/ref/heads/main');const parent=await github(env,'/git/commits/'+head.object.sha);
 const tree=await github(env,'/git/trees',{base_tree:parent.tree.sha,tree:[{path:'documentos/'+envelope.id+'/contenido.bin',mode:'100644',type:'blob',sha:binary.sha},{path:'documentos/'+envelope.id+'/sobre.json',mode:'100644',type:'blob',sha:meta.sha}]});
 const commit=await github(env,'/git/commits',{message:'Recibir documento cifrado para el comité',tree:tree.sha,parents:[head.object.sha]});
 try{await github(env,'/git/refs/heads/main',{sha:commit.sha,force:false},'PATCH');return commit.sha;}catch(e){if(![409,422].includes(e.status)||attempt===3)throw e;}
 }
}
export default {async fetch(request,env){
 const origin=request.headers.get('Origin');
 const allowed=new Set(['https://monicact.github.io',new URL(request.url).origin]);
 const headers={'Cache-Control':'no-store','X-Content-Type-Options':'nosniff','Vary':'Origin'};
 if(origin&&allowed.has(origin)){headers['Access-Control-Allow-Origin']=origin;headers['Access-Control-Allow-Headers']='Content-Type, X-Minedu-Code, X-Minedu-Envelope, OAI-Sites-Authorization';headers['Access-Control-Allow-Methods']='GET, POST, OPTIONS';}
 const json=(body,status=200)=>new Response(JSON.stringify(body),{status,headers:{...headers,'Content-Type':'application/json'}});
 try{
 if(origin&&!allowed.has(origin))return json({error:'Origen no permitido.'},403);
 if(request.method==='OPTIONS')return new Response(null,{status:204,headers});
 const url=new URL(request.url),p=url.pathname;
 if(p==='/'||p==='/health')return json({service:'MINEDU · Documentos privados',storage:REPO,ready:!!env.GITHUB_DOCUMENT_TOKEN});
 const access=permissions(request,env);if(!access)return json({error:'Código de acceso no válido.'},401);
 if(p==='/session'&&request.method==='GET')return json({access});
 if(p==='/upload'&&request.method==='POST'){
 if(access!=='upload')return json({error:'Este código no permite enviar documentos.'},403);
 if(Number(request.headers.get('Content-Length'))>MAX)return json({error:'Máximo 10 MB por archivo.'},413);
 const encoded=request.headers.get('X-Minedu-Envelope')||'';if(encoded.length>8000)return json({error:'Sobre no válido.'},400);
 let e;try{e=JSON.parse(atob(encoded));}catch{return json({error:'Sobre no válido.'},400);}
 if(!UUID.test(e.id)||e.version!==1||e.kid!==env.DOCUMENT_KEY_ID||!['iv','metaIv','metadata','wrappedKey'].every(k=>typeof e[k]==='string'&&/^[A-Za-z0-9+/]+=*$/.test(e[k]))||atob(e.iv).length!==12||atob(e.metaIv).length!==12||atob(e.wrappedKey).length!==384)return json({error:'Documento cifrado no válido.'},400);
 // Copy only the supported encrypted fields; never accept plaintext metadata or paths.
 const envelope=Object.fromEntries(['version','id','kid','iv','metaIv','metadata','wrappedKey'].map(k=>[k,e[k]]));
 const cipher=await request.arrayBuffer();if(cipher.byteLength<16||cipher.byteLength>MAX)return json({error:'Máximo 10 MB por archivo.'},413);
 const commit=await commitDocument(env,envelope,cipher);return json({id:e.id,commit,saved:true},201);
 }
 if(access!=='committee')return json({error:'Solo el comité puede consultar documentos.'},403);
 if(p==='/documents'&&request.method==='GET'){
 const tree=await github(env,'/git/trees/main?recursive=1');if(tree.truncated)return json({error:'El índice es demasiado grande; solicite archivado al administrador.'},503);
 return json({documents:tree.tree.filter(t=>t.type==='blob'&&/^documentos\/[0-9a-f-]+\/sobre\.json$/.test(t.path)).map(t=>({id:t.path.split('/')[1],sha:t.sha}))});
 }
 const match=/^\/documents\/([0-9a-f-]+)(\/file)?$/.exec(p);
 if(match&&UUID.test(match[1])&&request.method==='GET'){
 // Resolve the committed header, so arbitrary Git blob hashes cannot be requested.
 const entry=await github(env,'/contents/documentos/'+match[1]+'/sobre.json?ref=main');
 const envelope=JSON.parse(new TextDecoder().decode(Uint8Array.from(atob(entry.content.replace(/\s/g,'')),c=>c.charCodeAt(0))));
 if(!match[2])return json(envelope);
 if(!/^[a-f0-9]{40}$/.test(envelope.contentSha))return json({error:'Documento no válido.'},422);
 const file=await github(env,'/git/blobs/'+envelope.contentSha,undefined,undefined,true);
 return new Response(file.body,{headers:{...headers,'Content-Type':'application/octet-stream'}});
 }
 return json({error:'Ruta no disponible.'},404);
 }catch(e){return json({error:e.status===404?'Documento no encontrado.':'No se pudo completar la operación. Intente nuevamente.'},e.status===404?404:502);}
}};
