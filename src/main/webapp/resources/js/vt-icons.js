(function () {
  "use strict";

  function renderLordIcon(target) {
    if (!target) {
      return;
    }

    if (target.getAttribute("data-vt-icon-rendered") === "1" && target.querySelector("lord-icon")) {
      return;
    }

    var src = target.getAttribute("data-vt-lordicon");
    if (!src) {
      return;
    }

    var trigger = target.getAttribute("data-trigger") || "hover";
    var colors = target.getAttribute("data-colors") || "primary:#ffffff,secondary:#f3c900";
    var width = target.getAttribute("data-width") || "22";
    var height = target.getAttribute("data-height") || width;
    var delay = target.getAttribute("data-delay");
    var stroke = target.getAttribute("data-stroke");
    var extraAttrs = "";

    if (delay) {
      extraAttrs += ' delay="' + delay + '"';
    }
    if (stroke) {
      extraAttrs += ' stroke="' + stroke + '"';
    }

    target.innerHTML =
      '<lord-icon src="' +
      src +
      '" trigger="' +
      trigger +
      '" colors="' +
      colors +
      '"' +
      extraAttrs +
      ' style="width:' +
      width +
      "px;height:" +
      height +
      'px"></lord-icon>';
    target.setAttribute("data-vt-icon-rendered", "1");
  }

  function applyFallback(target) {
    if (!target || target.getAttribute("data-vt-icon-fallback") === "applied") {
      return;
    }
    var fallback = target.getAttribute("data-fallback-fa");
    if (!fallback) {
      return;
    }
    var icon = document.createElement("i");
    icon.className = fallback;
    icon.setAttribute("aria-hidden", "true");
    target.innerHTML = "";
    target.appendChild(icon);
    target.setAttribute("data-vt-icon-fallback", "applied");
    target.setAttribute("data-vt-icon-rendered", "1");
  }

  function initIcons() {
    var placeholders = document.querySelectorAll("[data-vt-lordicon]");
    if (!placeholders.length) {
      return;
    }

    placeholders.forEach(function (el) {
      renderLordIcon(el);
    });

    window.setTimeout(function () {
      var hasLordIcon = typeof window.customElements !== "undefined" && window.customElements.get("lord-icon");
      if (!hasLordIcon) {
        placeholders.forEach(function (el) {
          applyFallback(el);
        });
      }
    }, 1500);
  }

  function initDirectIcons() {
    var direct = document.querySelectorAll("lord-icon");
    if (!direct.length) {
      return;
    }

    window.setTimeout(function () {
      var hasLordIcon = typeof window.customElements !== "undefined" && window.customElements.get("lord-icon");
      if (!hasLordIcon) {
        direct.forEach(function (el) {
          if (el.previousElementSibling && el.previousElementSibling.classList.contains("vt-lordicon-fallback")) {
            el.remove();
            return;
          }
          var holder = document.createElement("span");
          holder.className = "vt-lordicon-fallback";
          holder.setAttribute("data-fallback-fa", "fas fa-circle");
          el.parentNode.insertBefore(holder, el);
          el.remove();
          applyFallback(holder);
        });
      }
    }, 2000);
  }

  function boot() {
    try {
      initIcons();
      initDirectIcons();
    } catch (e) {
      var placeholders = document.querySelectorAll("[data-vt-lordicon]");
      placeholders.forEach(function (el) {
        applyFallback(el);
      });
    }
  }

  if (window.VTCore && window.VTCore.onReady) {
    window.VTCore.onReady(boot);
  } else {
    document.addEventListener("DOMContentLoaded", boot);
  }
})();
