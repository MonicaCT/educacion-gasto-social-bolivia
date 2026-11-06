
'use strict';
(() => {
const API='https://api.github.com/repos/MonicaCT/educacion-gasto-social-bolivia';
const PATH='datos/seguimiento-minedu/estado.json';
let token='',baseline=null,dirty=false,busy=false;
const box=document.createElement('details');box.className='panel';
box.innerHTML='<summary>Administración · sincronizar avances con GitHub</summary><h2>Guardar avances en GitHub</h2><p>Los avances se guardan en este repositorio público. Los perfiles del dashboard son de demostración y no restringen la lectura.</p><label for="githubToken">Token personal de GitHub (solo en memoria durante esta sesión)</label><input id="githubToken" type="password" autocomplete="off" placeholder="Token con Contents: lectura y escritura para este repositorio"><div class="toolbar"><button id="ghConnect">Conectar y cargar datos</button><button id="ghSave" disabled>Guardar avances en GitHub</button><button id="ghDisconnect">Desconectar</button></div><p id="ghStatus" role="status" aria-live="polite">Sin conexión. Los cambios quedan locales hasta guardarlos en GitHub.</p><p><a href="https://github.com/settings/personal-access-tokens/new" target="_blank" rel="noopener">Crear token de acceso específico</a> · Seleccione este repositorio y permiso Contents: Read and write. No comparta el token.</p>';
document.querySelector('main').prepend(box);
const status=m=>document.getElementById('ghStatus').textContent=m;
const originalSave=window.save;
window.save=function(){originalSave();dirty=true;status('Cambios locales pendientes. Pulse Guardar avances en GitHub.');};
async function api(path,method='GET',body){
 const r=await fetch(API+path,{method,headers:{Accept:'application/vnd.github+json',...(token?{Authorization:'Bearer '+token}:{}),...(body?{'Content-Type':'application/json'}:{})},...(body?{body:JSON.stringify(body)}:{})});
 if(!r.ok){const e=await r.json().catch(()=>({}));throw Error(r.status===409||r.status===422?'Conflicto de versión. Recargue desde GitHub antes de guardar.':('GitHub '+r.status+': '+(e.message||r.statusText)));}
 return r.json();
}
function decode(s){return new TextDecoder().decode(Uint8Array.from(atob(s.replace(/\s/g,'')),c=>c.charCodeAt(0)));}
function valid(v){return v&&v.version===1&&Array.isArray(v.data)&&v.data.length===initial.length&&v.data.every((t,i)=>t.id===initial[i].id&&t.draft&&Number.isFinite(t.draft.avance)&&t.draft.avance>=0&&t.draft.avance<=100&&Array.isArray(t.hitos)&&Array.isArray(t.historial));}
async function readState(ref){try{return await api('/contents/'+PATH+'?ref='+encodeURIComponent(ref));}catch(e){if(e.message.startsWith('GitHub 404:'))return null;throw e;}}
async function connect(){
 if(busy)return;busy=true;
 try{
 token=document.getElementById('githubToken').value.trim();document.getElementById('githubToken').value='';
 if(!token)throw Error('Ingrese un token de GitHub.');
 const repo=await api('');if(!repo.permissions?.push)throw Error('La cuenta no tiene permiso de escritura.');
 const head=await api('/git/ref/heads/main');const file=await readState(head.object.sha);
 if(file){
 const state=JSON.parse(decode(file.content));if(!valid(state))throw Error('El estado de GitHub no tiene el formato esperado.');
 if((dirty||localStorage.getItem('minedu-v1'))&&!confirm('¿Cargar la versión de GitHub y reemplazar los datos locales? Exporte primero un respaldo si desea conservarlos.'))throw Error('Carga cancelada; datos locales conservados.');
 data=state.data;originalSave();if(role)render();
 }
 baseline=file?.sha||null;dirty=false;document.getElementById('ghSave').disabled=false;
 status(file?'Conectado. Datos cargados desde GitHub.':'Conectado. Aún no existe un estado compartido; pulse Guardar para publicarlo.');
 }catch(e){token='';document.getElementById('ghSave').disabled=true;status(e.message);}finally{busy=false;}
}
async function persist(){
 if(!token||busy)return;busy=true;document.getElementById('ghSave').disabled=true;
 try{
 status('Guardando en GitHub…');
 const head=await api('/git/ref/heads/main');const file=await readState(head.object.sha);
 if((file?.sha||null)!==baseline)throw Error('Otra persona actualizó los datos. Exporte su respaldo y vuelva a conectar para cargar la versión más reciente.');
 const snapshot=JSON.stringify(data);const tree=[];
 const state=JSON.stringify({version:1,updatedAt:new Date().toISOString(),data:JSON.parse(snapshot)},null,2);
 const stateBlob=await api('/git/blobs','POST',{encoding:'utf-8',content:state});
 tree.push({path:PATH,mode:'100644',type:'blob',sha:stateBlob.sha});
 const parent=await api('/git/commits/'+head.object.sha);
 const nextTree=await api('/git/trees','POST',{base_tree:parent.tree.sha,tree});
 const commit=await api('/git/commits','POST',{message:'Actualizar avances de seguimiento MINEDU',tree:nextTree.sha,parents:[head.object.sha]});
 await api('/git/refs/heads/main','PATCH',{sha:commit.sha,force:false});
 baseline=stateBlob.sha;dirty=JSON.stringify(data)!==snapshot;
 status('Guardado en GitHub. Commit '+commit.sha.slice(0,7)+(dirty?'. Hay nuevos cambios locales pendientes.':'. Avances respaldados.'));
 }catch(e){status('No se guardó en GitHub: '+e.message+' Los datos locales se conservan.');}finally{busy=false;document.getElementById('ghSave').disabled=!token;}
}
document.getElementById('ghConnect').onclick=connect;document.getElementById('ghSave').onclick=persist;
document.getElementById('ghDisconnect').onclick=()=>{if(busy)return;token='';document.getElementById('githubToken').value='';document.getElementById('ghSave').disabled=true;status('Desconectado. Token eliminado de la sesión.');};
window.addEventListener('beforeunload',e=>{if(dirty){e.preventDefault();e.returnValue='';}});
})();
