'use strict';
(()=>{
const NAME='Ricardo Erick Sanjinés Chávez';
const date=()=>new Intl.DateTimeFormat('es-BO',{dateStyle:'long',timeZone:'America/La_Paz'}).format(new Date());
const pct=d=>Number(d?.avance||0);
function address(){return '<p class="minister-salutation">A consideración del señor</p><h2>'+NAME+'</h2><p class="minister-office">Ministro de Educación</p><p class="minister-date">Fecha de consulta: '+date()+'</p>';}
function summary(){
 const count=data.filter(t=>t.publicado).length,average=data.length?Math.round(data.reduce((sum,t)=>sum+pct(t.publicado),0)/data.length):0;
 return [['Temas en seguimiento',data.length],['Con versión convalidada',count],['Avance global convalidado',average+' %']].map(([label,value])=>'<div class="panel"><small>'+label+'</small><div class="metric">'+value+'</div></div>').join('')+'<p class="minister-method">Indicadores de todos los temas. Avance global: promedio de los avances convalidados; los temas sin versión convalidada aportan 0 %.</p>';
}
function distribution(rows){
 if(!rows.length)return '';
 const bins=[['0–49 %',d=>pct(d)<50],['50–79 %',d=>pct(d)>=50&&pct(d)<80],['80–99 %',d=>pct(d)>=80&&pct(d)<100],['100 %',d=>pct(d)===100]];
 return '<section class="minister-distribution"><h2>Distribución del avance convalidado</h2><p>'+rows.length+' temas en la selección actual</p>'+bins.map(([label,test])=>{const n=rows.filter(t=>test(t.publicado)).length;return '<div class="minister-bar"><span>'+label+'</span><div class="minister-track" aria-hidden="true"><span style="width:'+(n/rows.length*100)+'%"></span></div><strong>'+n+'</strong></div>';}).join('')+'</section>';
}
function table(rows){
 if(!rows.length)return '<section class="minister-empty"><h2>No hay avances convalidados en esta selección</h2><p>Los compromisos aparecerán aquí cuando el comité convalide su información. Si aplicó filtros, puede restablecerlos para consultar los demás temas.</p></section>';
 return '<div class="minister-table-caption"><h2>Compromisos convalidados</h2><p>'+rows.length+' temas · detalle de la selección</p></div><div class="tablewrap minister-table"><table aria-label="Informe de compromisos convalidados"><thead><tr>'+['Compromiso y producto','Responsable / unidad','Fecha comprometida','Avance','Situación convalidada','Consulta'].map(h=>'<th scope="col">'+h+'</th>').join('')+'</tr></thead><tbody>'+rows.map(t=>{const d=t.publicado;return '<tr><td><strong>'+esc(t.tema)+'</strong><span class="minister-product">'+esc(t.producto)+'</span></td><td>'+esc(t.responsable)+'<span class="minister-product">'+esc(t.unidad)+'</span></td><td>'+esc(t.fecha||'Por confirmar')+'</td><td><strong class="minister-percent">'+pct(d)+'%</strong><progress max="100" value="'+pct(d)+'" aria-label="Avance convalidado de '+esc(t.tema)+'"></progress></td><td>'+esc(d.texto||'Sin descripción convalidada')+(d.riesgo?'<span class="minister-product">Riesgo reportado: '+esc(d.riesgo)+'</span>':'')+'</td><td><button class="minister-detail" onclick="openDetail('+Number(t.id)+')">Ver ficha</button></td></tr>';}).join('')+'</tbody></table></div><p class="minister-scope">Se presenta la última versión convalidada por el comité. Una revisión posterior puede permanecer pendiente.</p>';
}
const originalRender=window.render;
window.render=function(){
 originalRender();
 const header=$('ministerAddress');
 if(role!=='ministro'){if(header)header.hidden=true;return;}
 if(header){header.hidden=false;header.innerHTML=address();}
 $('who').textContent='DESPACHO DEL MINISTRO';$('eyebrow').textContent='';
 $('title').textContent='Informe ejecutivo de seguimiento';
 $('intro').textContent='Señor Ministro: se presenta a su consideración el estado de los compromisos con avances convalidados por el comité de seguimiento.';
 $('stats').innerHTML=summary();$('analytics').innerHTML=distribution(currentRows);$('list').innerHTML=table(currentRows);
};
const originalPrint=window.printReport;
window.printReport=function(){
 if(role!=='ministro')return originalPrint();
 $('report').innerHTML='<header class="minister-print-header"><p>MINISTERIO DE EDUCACIÓN · ESTADO PLURINACIONAL DE BOLIVIA</p>'+address()+'<h1>Informe ejecutivo de seguimiento</h1></header><p>'+currentRows.length+' compromisos convalidados de la selección actual.</p>'+currentRows.map(t=>{const d=t.publicado;return '<article><h2>'+esc(t.tema)+'</h2><p><strong>Producto:</strong> '+esc(t.producto)+'</p><p><strong>Responsable:</strong> '+esc(t.responsable)+' · '+esc(t.unidad)+'</p><p><strong>Fecha comprometida:</strong> '+esc(t.fecha||'Por confirmar')+' · <strong>Avance convalidado:</strong> '+pct(d)+' %</p><p><strong>Situación:</strong> '+esc(d.texto||'Sin descripción convalidada')+'</p><p><strong>Riesgos:</strong> '+esc(d.riesgo||'Sin reporte')+'</p><p><strong>Próximo paso:</strong> '+esc(d.siguiente||'Sin reporte')+'</p>'+(d.hitos?.length?'<table><thead><tr><th>Hito</th><th>Seguimiento</th><th>Cumplido</th></tr></thead><tbody>'+d.hitos.map(h=>'<tr><td>'+esc(h.nombre||'Sin definir')+'</td><td>'+esc(h.situacion||'Sin reporte')+'</td><td>'+(h.hecho?'Sí':'Sin confirmar')+'</td></tr>').join('')+'</tbody></table>':'')+'</article>';}).join('')+'<p>Información de la última versión convalidada. Fecha de consulta: '+date()+'.</p>';window.print();
};
})();
