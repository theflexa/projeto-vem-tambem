/**
 * VT Toast — Global notification component (Vaadin Notification pattern)
 * Usage: vtToast('Message text', 'success') | vtToast('Error!', 'error')
 * Variants: success, error, info, warning
 */
(function() {
  'use strict';

  // Create container on first use
  function getContainer() {
    var container = document.getElementById('vt-toast-container');
    if (!container) {
      container = document.createElement('div');
      container.id = 'vt-toast-container';
      container.className = 'vt-toast-container';
      document.body.appendChild(container);
    }
    return container;
  }

  /**
   * Show a toast notification
   * @param {string} message - The text to display
   * @param {string} [variant='success'] - success | error | info | warning
   * @param {number} [duration=4000] - Auto-dismiss time in ms
   */
  window.vtToast = function(message, variant, duration) {
    variant = variant || 'success';
    duration = duration || 4000;

    var container = getContainer();
    var toast = document.createElement('div');
    toast.className = 'vt-toast vt-toast--' + variant;

    // Icon per variant
    var icons = {
      success: 'fas fa-check-circle',
      error: 'fas fa-exclamation-circle',
      info: 'fas fa-info-circle',
      warning: 'fas fa-exclamation-triangle'
    };

    var icon = document.createElement('i');
    icon.className = icons[variant] || icons.info;
    toast.appendChild(icon);

    var text = document.createElement('span');
    text.textContent = message;
    toast.appendChild(text);

    container.appendChild(toast);

    // Auto-dismiss
    setTimeout(function() {
      toast.classList.add('vt-toast--out');
      setTimeout(function() {
        if (toast.parentNode) {
          toast.parentNode.removeChild(toast);
        }
      }, 300);
    }, duration);
  };
})();
