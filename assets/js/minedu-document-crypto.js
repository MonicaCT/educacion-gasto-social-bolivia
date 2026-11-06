'use strict';
// Each document has a fresh AES key. Only the committee's private RSA key unwraps it.
window.MineduDocumentCrypto=(()=>{
const s=crypto.subtle,enc=new TextEncoder(),dec=new TextDecoder();
const b64=bytes=>{let text='';bytes=new Uint8Array(bytes);for(let i=0;i<bytes.length;i+=8192)text+=String.fromCharCode(...bytes.subarray(i,i+8192));return btoa(text);};
const un64=text=>Uint8Array.from(atob(text),x=>x.charCodeAt(0));
const aad=(kid,id,part)=>enc.encode('MINEDU:1:'+kid+':'+id+':'+part);
async function seal(file,metadata,config){
 const id=crypto.randomUUID(),key=await s.generateKey({name:'AES-GCM',length:256},true,['encrypt','decrypt']);
 const pub=await s.importKey('jwk',config.publicKey,{name:'RSA-OAEP',hash:'SHA-256'},false,['wrapKey']);
 const iv=crypto.getRandomValues(new Uint8Array(12)),metaIv=crypto.getRandomValues(new Uint8Array(12));
 const cipher=await s.encrypt({name:'AES-GCM',iv,additionalData:aad(config.kid,id,'file')},key,await file.arrayBuffer());
 const meta=await s.encrypt({name:'AES-GCM',iv:metaIv,additionalData:aad(config.kid,id,'metadata')},key,enc.encode(JSON.stringify(metadata)));
 return {cipher,envelope:{version:1,id,kid:config.kid,iv:b64(iv),metaIv:b64(metaIv),metadata:b64(meta),wrappedKey:b64(await s.wrapKey('raw',key,pub,{name:'RSA-OAEP'}))}};
}
async function importPrivate(jwk){return s.importKey('jwk',jwk,{name:'RSA-OAEP',hash:'SHA-256'},false,['unwrapKey']);}
async function openMetadata(envelope,privateKey,kid){
 if(envelope.version!==1||envelope.kid!==kid)throw Error('La llave no corresponde a estos documentos.');
 const key=await s.unwrapKey('raw',un64(envelope.wrappedKey),privateKey,{name:'RSA-OAEP'},{name:'AES-GCM'},false,['decrypt']);
 const text=await s.decrypt({name:'AES-GCM',iv:un64(envelope.metaIv),additionalData:aad(kid,envelope.id,'metadata')},key,un64(envelope.metadata));
 return {key,metadata:JSON.parse(dec.decode(text))};
}
async function openFile(cipher,envelope,key){return s.decrypt({name:'AES-GCM',iv:un64(envelope.iv),additionalData:aad(envelope.kid,envelope.id,'file')},key,cipher);}
return {seal,importPrivate,openMetadata,openFile};
})();
