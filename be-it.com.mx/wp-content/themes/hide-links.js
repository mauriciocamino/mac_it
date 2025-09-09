// Script para ocultar enlaces a vacantes/index.html
document.addEventListener('DOMContentLoaded', function() {
    // Función para ocultar enlaces
    function hideLinks() {
        // Ocultar todos los enlaces a vacantes/index.html (case insensitive)
        var links = document.querySelectorAll('a[href*="vacantes/index.html"], a[href*="VACANTES/INDEX.HTML"]');
        for (var i = 0; i < links.length; i++) {
            links[i].style.display = 'none';
            links[i].style.visibility = 'hidden';
            links[i].style.opacity = '0';
            links[i].style.pointerEvents = 'none';
            links[i].setAttribute('tabindex', '-1'); // Evitar navegación por teclado
            links[i].setAttribute('aria-hidden', 'true'); // Ocultar para lectores de pantalla
            links[i].href = '#'; // Cambiar el destino del enlace
        }

        // Ocultar elementos de menú específicos
        var menuItems = document.querySelectorAll('#menu-item-485, .menu-item-485');
        for (var i = 0; i < menuItems.length; i++) {
            menuItems[i].style.display = 'none';
            menuItems[i].style.visibility = 'hidden';
        }
    }

    // Ejecutar inmediatamente
    hideLinks();

    // Ejecutar después de cualquier cambio en el DOM (para sitios dinámicos)
    var observer = new MutationObserver(function(mutations) {
        hideLinks();
    });

    observer.observe(document.body, { childList: true, subtree: true });
});