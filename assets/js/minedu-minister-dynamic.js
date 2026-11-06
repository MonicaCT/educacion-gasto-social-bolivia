'use strict';
(()=>{
let focus='all';
const options=[['all','Todos'],['low','Avance menor a 50 %'],['middle','Avance de 50 a 79 %'],['high','Avance de 80 a 99 %'],['done','Avance de 100 %'],['risk','Con registro de riesgos']];
const accepted=t=>{const d=t.publicado,n=Number(d?.avance||0);return focus==='all'||focus==='low'&&n<50||focus==='middle'&&n>=50&&n<80||focus==='high'&&n>=80&&n<100||focus==='done'&&n===100||focus==='risk'&&!!String(d?.riesgo||'').trim();};
const originalVisible=window.visible;
window.visible=function(){const rows=originalVisible();return role==='ministro'?rows.filter(accepted):rows;};
window.ministerFocus=function(value){if(role!=='ministro'||!options.some(([key])=>key===value))return;focus=value;render();};
const originalReset=window.resetFilters;window.resetFilters=function(){if(role==='ministro')focus='all';originalReset();};
function ring(value,label,color){
 const ratio=value===null?0:Math.max(0,Math.min(100,value));
 return '<svg class="executive-ring" viewBox="0 0 120 120" role="img" aria-label="'+esc(label)+'"><circle cx="60" cy="60" r="49" fill="none" stroke="#e6edf1" stroke-width="9"/><circle class="executive-ring-value" cx="60" cy="60" r="49" fill="none" stroke="'+color+'" stroke-width="9" pathLength="100" stroke-dasharray="'+ratio+' 100" transform="rotate(-90 60 60)"/><text x="60" y="66" text-anchor="middle">'+(value===null?'—':Math.round(value)+'%')+'</text></svg>';
}
function infographics(rows){
 const n=rows.length,avg=n?rows.reduce((sum,t)=>sum+Number(t.publicado.avance||0),0)/n:null;
 const milestones=rows.flatMap(t=>Array.isArray(t.publicado.hitos)?t.publicado.hitos:[]).filter(h=>String(h.nombre||'').trim());
 const done=milestones.filter(h=>h.hecho===true).length,total=milestones.length;
 const risks=rows.filter(t=>String(t.publicado.riesgo||'').trim()).length;
 return '<section class="executive-infographics" aria-label="Infografías de avances convalidados"><article class="executive-info">'+ring(avg,'Avance promedio convalidado de la selección','#2e718d')+'<div><h3>Avance de la selección</h3><p>'+n+' temas convalidados</p><small>Promedio con igual peso por tema.</small></div></article><article class="executive-info">'+ring(total?done/total*100:null,'Porcentaje de hitos confirmados de la selección','#32826b')+'<div><h3>Hitos confirmados</h3><p>'+done+' de '+total+' hitos definidos</p><small>'+(total?'Solo se utilizan las versiones convalidadas.':'Sin hitos definidos en esta selección.')+'</small></div></article><article class="executive-info"><div class="executive-number">'+risks+'<small>de '+n+'</small></div><div><h3>Registro de riesgos</h3><p>Temas con el campo completado</p><small>No implica que exista un riesgo activo.</small></div></article></section>';
}
const originalRender=window.render;
window.render=function(){
 originalRender();if(role!=='ministro')return;
 $('who').textContent='Señor Ministro';$('title').textContent='Resumen ejecutivo de compromisos';
 $('intro').textContent='Señor Ministro: consulte los avances convalidados por el comité y registre orientaciones para su seguimiento.';
 $('actorName').value='Señor Ministro';
 const html='<section class="executive-focus"><h2>Explorar los avances convalidados</h2><p>Las infografías, los gráficos y la tabla responden a los mismos filtros.</p><div class="executive-focus-buttons">'+options.map(([key,label])=>'<button type="button" class="secondary" aria-pressed="'+(focus===key)+'" onclick="ministerFocus(\''+key+'\')">'+label+'</button>').join('')+'</div></section>'+infographics(currentRows);
 $('analytics').innerHTML=html+$('analytics').innerHTML;
};
})();
