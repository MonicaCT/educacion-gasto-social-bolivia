'use strict';
(()=>{
let configPromise,access=null,privateKey=null,records=[],working=false;
const config=()=>configPromise||(configPromise=fetch('assets/config/minedu-documentos.json',{cache:'no-store'}).then(r=>{if(!r.ok)throw Error('No se pudo cargar la configuración.');return r.json();}));
const message=text=>{const el=$('docStatus');if(el)el.textContent=text;};
async function api(path,options={}){
 if(!access)throw Error('Primero conecte su acceso de documentos.');
 const cfg=await config();
 const response=await fetch(cfg.serviceUrl+path,{...options,redirect:'error',credentials:'omit',headers:{'X-Minedu-Code':access.code,...options.headers}});
 if(!response.ok){const body=await response.json().catch(()=>({}));throw Error(body.error||'Acceso no disponible. Revise su código e intente nuevamente.');}
 return response;
}
function clear(){access=null;privateKey=null;records=[];}
const oldLogin=window.login;
window.login=function(){const before=role;oldLogin();if(role!==before)clear();};
window.attachments=async function(){
 if(!role)return;
 if(role==='ministro'){detail.innerHTML='<h2>Documentos reservados al comité</h2><p>Este perfil no tiene acceso a los adjuntos.</p><button onclick="detail.close()">Cerrar</button>';if(!detail.open)detail.showModal();return;}
 const committee=role==='comite';
 detail.innerHTML='<h2>'+(committee?'Documentos del comité de seguimiento':'Enviar documentos al comité')+'</h2><p>'+(committee?'Cargue el archivo privado de acceso del comité para consultar los documentos.':'Los archivos se cifran en su equipo antes de enviarlos. Solo el comité dispone de la llave para abrirlos.')+'</p>'+
 (committee?'<label for="committeeKey">Archivo de acceso del comité</label><input id="committeeKey" type="file" accept=".json"><p><button onclick="unlockCommitteeDocuments()">Abrir acceso del comité</button></p>':'<label for="documentCode">Código personal de envío</label><input id="documentCode" type="password" autocomplete="off" placeholder="Pegue el código recibido"><p><button onclick="connectDocumentUpload()">Conectar envío</button></p><label for="attachmentTopic">Compromiso</label><select id="attachmentTopic">'+visible().map(t=>'<option value="'+t.id+'">'+esc(t.tema)+'</option>').join('')+'</select><label for="attachmentFiles">Documentos (máximo 10 MB por archivo)</label><input id="attachmentFiles" type="file" multiple><p><button id="privateUpload" onclick="uploadAttachments()">Enviar documentos al comité</button></p>')+
 '<p id="docStatus" role="status" aria-live="polite">'+(access?(committee?'Acceso abierto durante esta sesión.':'Conectado para enviar documentos.'):'Sin acceso conectado.')+'</p><div id="privateDocumentList"></div><p class="note">El almacenamiento es un repositorio privado de GitHub. Los códigos de envío no permiten listar ni descargar documentos. Nunca comparta el archivo de acceso del comité con los responsables.</p><button onclick="lockPrivateDocuments()">Cerrar acceso</button> <button class="secondary" onclick="detail.close()">Cerrar ventana</button>';
 if(!detail.open)detail.showModal();
 if(committee&&privateKey)await loadDocuments();
};
window.connectDocumentUpload=async function(){
 if(role!=='responsable'||working)return;
 try{
 const text=$('documentCode').value.trim();$('documentCode').value='';
 const decoded=JSON.parse(atob(text.replace(/-/g,'+').replace(/_/g,'/')));
 if(decoded.v!==1||!decoded.code)throw Error('Código de envío no válido.');
 access=decoded;const session=await(await api('/session')).json();
 if(session.access!=='upload')throw Error('Use un código de envío de responsable.');
 message('Conectado. Seleccione los documentos y pulse Enviar documentos al comité.');
 }catch(e){clear();message(e.message);}
};
window.unlockCommitteeDocuments=async function(){
 if(role!=='comite'||working)return;
 try{
 const file=$('committeeKey').files[0];if(!file||file.size>20000)throw Error('Seleccione el archivo privado del comité.');
 const key=JSON.parse(await file.text()),cfg=await config();$('committeeKey').value='';
 if(key.version!==1||key.kid!==cfg.kid||key.privateKey?.n!==cfg.publicKey.n||!key.access)throw Error('La llave no corresponde a este dashboard.');
 access=key.access;const session=await(await api('/session')).json();if(session.access!=='committee')throw Error('Este acceso no pertenece al comité.');
 privateKey=await MineduDocumentCrypto.importPrivate(key.privateKey);await loadDocuments();
 }catch(e){clear();message(e.message);}
};
async function loadDocuments(){
 if(role!=='comite'||!privateKey)throw Error('Solo el comité puede consultar documentos.');
 message('Consultando documentos privados…');
 const list=await(await api('/documents')).json();records=[];
 const cfg=await config();let failed=0;
 for(const entry of list.documents){
 try{const envelope=await(await api('/documents/'+entry.id)).json();const opened=await MineduDocumentCrypto.openMetadata(envelope,privateKey,cfg.kid);records.push({envelope,...opened});}catch{failed++;}
 }
 const target=$('privateDocumentList');if(!target)return;
 target.innerHTML='<h3>Documentos recibidos</h3>'+(records.length?'':'<p>No hay documentos disponibles.</p>');
 records.sort((a,b)=>String(b.metadata.fecha).localeCompare(String(a.metadata.fecha))).forEach((record,i)=>{
 const m=record.metadata,section=document.createElement('section');section.className='panel';
 const heading=document.createElement('strong');heading.textContent=m.nombre;
 const info=document.createElement('p');info.textContent=(data.find(t=>t.id===m.tema)?.tema||'Compromiso '+m.tema)+' · '+m.actor+' · '+new Date(m.fecha).toLocaleString('es-BO');
 const button=document.createElement('button');button.textContent='Descargar documento';button.onclick=()=>downloadPrivate(i);
 section.append(heading,info,button);target.append(section);
 });message(records.length+' documento(s) disponibles.'+(failed?' '+failed+' no se pudieron abrir; comuníquelo al administrador.':''));
}
window.uploadAttachments=async function(){
 if(role!=='responsable'||!requireActor()||working)return;
 if(!access)return message('Primero conecte su código de envío.');
 const files=[...$('attachmentFiles').files],tema=Number($('attachmentTopic').value);
 if(!files.length||!data.some(t=>t.id===tema))return message('Seleccione compromiso y documentos.');
 if(files.some(f=>f.size>10*1024*1024))return message('Cada archivo debe pesar como máximo 10 MB.');
 working=true;const button=$('privateUpload');button.disabled=true;let sent=0;
 try{
 const cfg=await config();
 for(const file of files){
 message('Cifrando y enviando documento '+(sent+1)+' de '+files.length+'…');
 const sealed=await MineduDocumentCrypto.seal(file,{nombre:file.name.slice(0,512),mime:file.type,size:file.size,tema,actor:actor().slice(0,128),fecha:new Date().toISOString()},cfg);
 const response=await(await api('/upload',{method:'POST',body:sealed.cipher,headers:{'Content-Type':'application/octet-stream','X-Minedu-Envelope':btoa(JSON.stringify(sealed.envelope))}})).json();
 if(!response.saved)throw Error('No se confirmó el guardado.');sent++;
 // No filenames, document text or decryption keys enter the public dashboard state.
 // El recibo y los metadatos permanecen en el almacenamiento privado.
 }
 $('attachmentFiles').value='';message(sent+' documento(s) guardados en GitHub privado. Solo el comité puede consultarlos.');
 }catch(e){message('Enviados '+sent+' de '+files.length+'. '+e.message+' Los restantes no están confirmados; vuelva a seleccionarlos.');}finally{working=false;button.disabled=false;}
};
async function downloadPrivate(index){
 if(role!=='comite'||!privateKey)return message('Solo el comité puede abrir documentos.');
 const record=records[index];if(!record)return;
 try{message('Descifrando documento…');const cipher=await(await api('/documents/'+record.envelope.id+'/file')).arrayBuffer();
 const bytes=await MineduDocumentCrypto.openFile(cipher,record.envelope,record.key);
 const url=URL.createObjectURL(new Blob([bytes],{type:record.metadata.mime||'application/octet-stream'}));
 const a=document.createElement('a');a.href=url;a.download=record.metadata.nombre;a.click();setTimeout(()=>URL.revokeObjectURL(url),1000);message('Documento descargado.');
 }catch{message('No se pudo abrir el documento; verifique el acceso y su integridad.');}
}
window.downloadAttachment=()=>message('Los documentos se consultan desde el acceso privado del comité.');
window.lockPrivateDocuments=()=>{if(working)return;clear();if(detail.open)attachments();};
})();
