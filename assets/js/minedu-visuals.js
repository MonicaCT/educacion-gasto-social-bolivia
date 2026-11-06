'use strict';
(()=>{
const paths={
 info:'M12 8h.01M11 12h1v4h1M21 12a9 9 0 1 1-18 0 9 9 0 0 1 18 0',
 edit:'m15 5 4 4M4 20l4-1L20 7a2.1 2.1 0 0 0-3-3L5 16l-1 4',
 review:'M8 3H5v18h14V3h-3M9 3h6v4H9zM8 12h8M8 16h5',
 warning:'m12 3 10 18H2L12 3ZM12 9v5M12 17h.01',
 check:'m5 12 4 4L19 6M21 12a9 9 0 1 1-7-8.8',
 chart:'M4 4v16h17M8 15v-4M13 15V6M18 15v-7',
 people:'M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2M9 11a4 4 0 1 0 0-8 4 4 0 0 0 0 8M22 21v-2a4 4 0 0 0-3-3.9M16 3a4 4 0 0 1 0 8',
 calendar:'M8 2v4M16 2v4M3 10h18M5 4h14a2 2 0 0 1 2 2v14H3V6a2 2 0 0 1 2-2',
 print:'M6 9V3h12v6M6 18H3v-7h18v7h-3M6 14h12v7H6z',
 search:'M21 21l-5-5M18 10a8 8 0 1 1-16 0 8 8 0 0 1 16 0',
 send:'m22 2-7 20-4-9-9-4L22 2ZM11 13 22 2',
 reset:'M3 10a9 9 0 1 1 2 8M3 4v6h6',
 eye:'M2 12s4-7 10-7 10 7 10 7-4 7-10 7S2 12 2 12ZM15 12a3 3 0 1 1-6 0 3 3 0 0 1 6 0',
 save:'M5 3h12l4 4v14H3V3h2ZM7 3v6h10V3M7 21v-8h10v8',
};
function icon(name){return '<svg class="ui-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true" focusable="false"><path d="'+(paths[name]||paths.info)+'"/></svg>';}
const stages=[['Borrador','edit','#4779aa'],['En revisión','review','#b17c17'],['Observado','warning','#b24a63'],['Validado','check','#2a825f']];
const alerts=[['1','Buen avance','check','#2a825f'],['2','Avance medio','review','#b17c17'],['3','Retraso','warning','#b24a63'],['','Sin clasificar','info','#708394']];
function version(t){return role==='ministro'?t.publicado:t.draft;}
function hasReport(d){return !!(d&&(String(d.texto||'').trim()||Number(d.avance)>0));}
function summarize(rows){
 const counts=stages.map(([label,key,color])=>({label,icon:key,color,value:rows.filter(t=>t.etapa===label).length}));
 const bins=[{label:'Sin reporte',color:'#708394',value:0},{label:'0–49 %',color:'#497aaa',value:0},{label:'50–79 %',color:'#6681b3',value:0},{label:'80–99 %',color:'#428d91',value:0},{label:'100 %',color:'#2a825f',value:0}];
 const units=new Map();let reported=0;
 rows.forEach(t=>{const d=version(t),n=Number(d?.avance||0);let i=!hasReport(d)?0:n<50?1:n<80?2:n<100?3:4;bins[i].value++;if(hasReport(d))reported++;const name=t.unidad||'Sin unidad';const g=units.get(name)||{sum:0,count:0,reports:0};g.sum+=n;g.count++;g.reports+=hasReport(d)?1:0;units.set(name,g);});
 return {counts,bins,reported,units:[...units].map(([label,g])=>({label,value:g.sum/g.count,count:g.count,reports:g.reports,color:'#367b98'})).sort((a,b)=>b.value-a.value||a.label.localeCompare(b.label)),alerts:alerts.map(([k,label,key,color])=>({label,icon:key,color,value:rows.filter(t=>String(t.alerta||'')===k).length}))};
}
function bars(items,total,percent=false){return items.map(item=>{const width=percent?item.value:total?item.value/total*100:0;const value=percent?Math.round(item.value)+' %':String(item.value);return '<div class="chart-row" aria-label="'+esc(item.label)+': '+value+'"><span class="chart-name">'+(item.icon?icon(item.icon):'')+esc(item.label)+'</span><div class="chart-track" aria-hidden="true"><div class="chart-fill" style="background:'+item.color+';width:'+Math.max(0,Math.min(100,width))+'%"></div></div><span class="chart-value">'+value+'</span></div>';}).join('');}
function card(id,title,caption,body,footnote){return '<section class="chart-card" aria-labelledby="'+id+'"><h3 id="'+id+'">'+icon('chart')+title+'</h3><p class="chart-caption">'+caption+'</p>'+body+(footnote?'<p class="chart-footnote">'+footnote+'</p>':'')+'</section>';}
window.drawAnalytics=function(rows){
 const target=$('analytics'),summary=summarize(rows),n=rows.length;
 let content='<div class="charts-heading"><h2>'+icon('chart')+'Lectura de la selección</h2><p>'+n+' tema'+(n===1?'':'s')+' · gráficos y tabla con los mismos filtros</p></div>';
 if(!n){target.innerHTML=content+'<p class="chart-empty">No hay temas para esta selección.'+(role==='ministro'?' Este perfil muestra únicamente temas con una versión convalidada.':' Ajuste los filtros para consultar otros temas.')+'</p>';return;}
 content+='<div class="chart-grid">'+card('chart-stages','Etapas de seguimiento','Cantidad de temas por etapa actual.',bars(summary.counts,n),'Total de la selección: '+n+' temas.')+
 card('chart-progress',role==='ministro'?'Avance convalidado':'Avance reportado','Cantidad de temas por intervalo de avance global del producto.',bars(summary.bins,n),summary.reported+' de '+n+' temas con avance o situación reportados.')+
 (role==='comite'?card('chart-alerts','Alertas de la fuente','Clasificación original de los temas seleccionados.',bars(summary.alerts,n),'Sin reporte no equivale a retraso. La alerta original no se recalcula con el avance.'):'');
 if(summary.units.length>1&&summary.reported>0){content+=card('chart-units','Avance promedio por unidad','Porcentaje del producto · promedio con el mismo peso por tema.',bars(summary.units,n,true),'Escala de 0 a 100 %. Los temas sin avance reportado aportan 0 %.');}
 content+='</div>';
 if(role==='comite'){
 const critical=rows.filter(t=>String(t.alerta)==='3').sort((a,b)=>Number(a.draft?.avance||0)-Number(b.draft?.avance||0)).slice(0,3);
 if(critical.length)content+='<details><summary>'+icon('warning')+'Hasta 3 temas con alerta original de retraso</summary>'+critical.map(t=>'<div class="reason"><button class="secondary" onclick="openDetail('+Number(t.id)+')">'+icon('eye')+esc(t.tema)+'</button><p>'+esc(t.draft?.riesgo||t.draft?.texto||t.curso||t.nota||'La fuente no explica el motivo. Requiere aclaración del responsable.')+'</p></div>').join('')+'</details>';
 }
 target.innerHTML=content;
};
function decorate(){
 const table=$('list')?.querySelector('table');
 if(table){table.setAttribute('aria-label','Seguimiento de compromisos');table.querySelectorAll('th').forEach(th=>th.setAttribute('scope','col'));
 table.querySelectorAll('tbody tr').forEach((tr,i)=>{const t=currentRows[i];if(!t)return;tr.dataset.stage=t.etapa;
 const button=tr.cells[4]?.querySelector('button');if(button){const s=stages.find(s=>s[0]===t.etapa);button.classList.add('stage-pill');button.dataset.stage=t.etapa;button.innerHTML=icon(s?.[1]||'info')+esc(t.etapa);button.title='Consultar etapa, revisión e historial';}
 const cell=tr.cells[5];if(cell){const a=alerts.find(a=>a[0]===String(t.alerta||''))||alerts[3];const text=cell.firstChild;if(text?.nodeType===3)text.remove();const firstBreak=cell.querySelector('br');if(firstBreak)firstBreak.remove();const pill=document.createElement('span');pill.className='alert-pill';pill.dataset.alert=String(t.alerta||'');pill.innerHTML=icon(a[2])+esc(a[1]);cell.prepend(pill,document.createElement('br'));}
 });
 const legend=document.createElement('div');legend.className='table-legend';legend.innerHTML='<strong>Etapas:</strong>'+stages.map(([label,key])=>'<span class="stage-pill" data-stage="'+label+'">'+icon(key)+label+'</span>').join('');$('list').append(legend);
 }
 const stats=$('stats');if(stats){const keys=['people','review','check','chart'];stats.querySelectorAll('.panel small').forEach((el,i)=>{el.innerHTML=icon(keys[i])+el.innerHTML;});const note=stats.querySelector('p');if(note)note.textContent='Indicadores globales de todos los temas. '+note.textContent;}
 decorateButtons(document);
}
function decorateButtons(root){root.querySelectorAll('button').forEach(button=>{if(button.querySelector('.ui-icon'))return;const label=button.textContent.trim();const rules=[[/Imprimir/,'print','Generar el reporte de la selección'],[/Instrucciones/,'info','Consultar la guía de este perfil'],[/Limpiar filtros/,'reset','Restablecer todos los filtros'],[/Guardar/,'save','Guardar los cambios indicados'],[/Enviar al comité/,'send','Enviar el avance para revisión'],[/Validar y publicar/,'check','Convalidar el avance para el ministro'],[/Solicitar ajustes|Enviar al responsable/,'warning','Comunicar observaciones para corregir'],[/Asignarme/,'review','Asumir la revisión del tema'],[/Situación reportada/,'eye','Consultar la ficha y su avance'],[/Observaciones/,'review','Consultar observaciones y plazos']];const rule=rules.find(([p])=>p.test(label));if(rule){button.insertAdjacentHTML('afterbegin',icon(rule[1]));button.title=rule[2];}});}
const baseRender=window.render;window.render=function(){baseRender();decorate();};
['openDetail','sectionDetail'].forEach(name=>{const original=window[name];window[name]=function(...args){const value=original(...args);decorateButtons($('detail'));$('detail').querySelectorAll('table').forEach(table=>{table.setAttribute('aria-label','Cronograma y seguimiento de hitos');table.querySelectorAll('th').forEach(th=>th.setAttribute('scope','col'));});return value;};});
decorateButtons(document);
})();
