!function(n,t){var e,i,a,r,o,s,d=function(n){return n.trim?n.trim():n.replace(/^\s+|\s+$/g,"")},c=function(n,e){return-1!==(" "+n.className+" ").indexOf(" "+e+" ")},l=function(n,e){c(n,e)||(n.className=""===n.className?e:n.className+" "+e)},u=function(n,e){n.className=d((" "+n.className+" ").replace(" "+e+" "," "))},f=function(n,e){if(n)do{if(n.id===e)return!0;if(9===n.nodeType)break}while(n=n.parentNode);return!1},v=t.documentElement,p=(n.Modernizr.prefixed("transform"),n.Modernizr.prefixed("transition")),m=!!(e={WebkitTransition:"webkitTransitionEnd",MozTransition:"transitionend",OTransition:"oTransitionEnd otransitionend",msTransition:"MSTransitionEnd",transition:"transitionend"}).hasOwnProperty(p)&&e[p];n.App=(i=!1,a={},r=t.getElementById("inner-wrap"),o=!1,s="js-nav",a.init=function(){if(!i){i=!0;var e=function(n){n&&n.target===r&&t.removeEventListener(m,e,!1),o=!1};a.closeNav=function(){o&&(0<(m&&p?parseFloat(n.getComputedStyle(r,"")[p+"Duration"]):0)?t.addEventListener(m,e,!1):e(null)),u(v,s)},a.openNav=function(){o||(l(v,s),o=!0)},a.toggleNav=function(n){o&&c(v,s)?a.closeNav():a.openNav(),n&&n.preventDefault()},t.getElementById("nav-open-btn").addEventListener("click",a.toggleNav,!1),t.addEventListener("click",function(n){o&&!f(n.target,"nav")&&(n.preventDefault(),a.closeNav())},!0),l(v,"js-ready")}},a),n.addEventListener&&n.addEventListener("DOMContentLoaded",n.App.init,!1)}(window,window.document);