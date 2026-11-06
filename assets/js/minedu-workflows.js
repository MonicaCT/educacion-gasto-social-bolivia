'use strict';
(()=>{
const guides={
 responsable:{name:'Responsable',alt:'Buscar y abrir el tema; actualizar avance, situación e hitos; enviar al comité. Si convalida, el avance queda visible para el ministro. Si solicita ajustes, corregir y volver a enviar.'},
 comite:{name:'Comité de seguimiento',alt:'Filtrar temas En revisión; abrir la ficha y asumir la revisión; revisar situación, riesgos e hitos. Si la información es conforme, validar y publicar para el ministro. Si requiere ajustes, registrar observaciones y plazo; el responsable corrige y vuelve a enviar.'},
 ministro:{name:'Ministro',alt:'Consultar temas convalidados; filtrar y revisar gráficos y tabla; abrir ficha e hitos. Si lo considera necesario, registrar una orientación en el historial. Puede imprimir los temas seleccionados.'}
};
window.workflowMarkup=function(profile){
 const g=guides[profile];if(!g)return '';
 const src='assets/img/flujo-'+profile+'.png';
 return '<figure class="workflow-figure"><img src="'+src+'" width="1400" height="740" alt="'+g.alt+'" loading="lazy"><figcaption><a href="'+src+'" target="_blank" rel="noopener">Abrir diagrama de '+g.name+' en tamaño completo</a></figcaption></figure>';
};
function showGuide(){
 const g=guides[role];if(!g)return;
 const label=document.getElementById('workflowLabel'),content=document.getElementById('workflowContent');
 if(label)label.textContent='Procedimiento e instrucciones · '+g.name;
 if(content)content.innerHTML=window.workflowMarkup(role)+'<p class="workflow-storage">Los cambios se guardan en este navegador. Los perfiles comparten los registros únicamente en este mismo navegador.</p>';
}
const originalLogin=window.login;
window.login=function(){originalLogin();if(!document.getElementById('app').classList.contains('hide'))showGuide();};
})();
