(function () {
  "use strict";

  var loaderElement = null;
  var loaderAnimation = null;
  var loaderShownAt = 0;
  var loaderMinimumVisibleMs = 550;
  var navigationInProgress = false;
  var lottieScriptLoading = false;
  var appBasePath = detectAppBasePath();

  function detectAppBasePath() {
    try {
      var marker = "/resources/js/vt-core.js";
      var scripts = document.getElementsByTagName("script");
      var current = document.currentScript || scripts[scripts.length - 1];
      var src = current && current.getAttribute("src");
      if (src) {
        var pathname = new URL(src, window.location.origin).pathname;
        var markerIndex = pathname.indexOf(marker);
        if (markerIndex >= 0) {
          return pathname.substring(0, markerIndex);
        }
      }
    } catch (e) {}

    var path = window.location.pathname || "";
    var parts = path.split("/").filter(Boolean);
    return parts.length ? "/" + parts[0] : "";
  }

  function resolveAssetPath(relativePath) {
    return (appBasePath || "") + relativePath;
  }

  function getUserId() {
    var body = document.body;
    if (!body) {
      return "anon";
    }
    var id = body.getAttribute("data-user-id");
    return id && id.trim() ? id.trim() : "anon";
  }

  function getPageKey() {
    var path = window.location.pathname || "";
    return path.replace(/\/+$/, "").split("/").pop() || "home";
  }

  function prefersReducedMotion() {
    return window.matchMedia && window.matchMedia("(prefers-reduced-motion: reduce)").matches;
  }

  function onReady(fn) {
    if (document.readyState === "loading") {
      document.addEventListener("DOMContentLoaded", fn);
      return;
    }
    fn();
  }

  function ensureLottieReady(onReadyCallback) {
    if (window.lottie && typeof window.lottie.loadAnimation === "function") {
      onReadyCallback();
      return;
    }

    if (lottieScriptLoading) {
      window.setTimeout(function () {
        ensureLottieReady(onReadyCallback);
      }, 60);
      return;
    }

    lottieScriptLoading = true;
    var script = document.createElement("script");
    script.src = resolveAssetPath("/resources/vendor/lottie/lottie.min.js");
    script.async = true;
    script.onload = function () {
      lottieScriptLoading = false;
      onReadyCallback();
    };
    script.onerror = function () {
      lottieScriptLoading = false;
    };
    document.head.appendChild(script);
  }

  function initLoaderAnimation() {
    var animationContainer = loaderElement && loaderElement.querySelector("[data-vt-loader-animation]");
    if (!animationContainer) {
      return;
    }

    ensureLottieReady(function () {
      if (!animationContainer || !(window.lottie && typeof window.lottie.loadAnimation === "function")) {
        return;
      }

      loaderAnimation = window.lottie.loadAnimation({
        container: animationContainer,
        renderer: "svg",
        loop: true,
        autoplay: true,
        path: resolveAssetPath("/resources/vendor/lottie/animations/walking-pothos.json"),
        rendererSettings: { preserveAspectRatio: "xMidYMid meet" }
      });
    });
  }

  function createLoader() {
    if (!document.body || document.getElementById("vtGlobalLoader")) {
      return;
    }

    loaderElement = document.createElement("div");
    loaderElement.id = "vtGlobalLoader";
    loaderElement.className = "vt-global-loader";
    loaderElement.setAttribute("aria-live", "polite");
    loaderElement.setAttribute("aria-busy", "true");
    loaderElement.innerHTML =
      '<div class="vt-global-loader__box">' +
      '<div class="vt-global-loader__anim" data-vt-loader-animation aria-hidden="true"></div>' +
      '<p class="vt-global-loader__text">Preparando sua experi\u00eancia...</p>' +
      "</div>";

    document.body.appendChild(loaderElement);
    document.body.classList.add("vt-loading");
    loaderShownAt = Date.now();

    window.requestAnimationFrame(function () {
      if (loaderElement) {
        loaderElement.classList.add("is-visible");
      }
    });

    initLoaderAnimation();
  }

  function showLoaderNow() {
    createLoader();
    if (loaderElement) {
      loaderElement.classList.add("is-visible");
    }
  }

  function removeLoader() {
    if (!loaderElement) {
      return;
    }

    var elapsed = Date.now() - loaderShownAt;
    var wait = Math.max(0, loaderMinimumVisibleMs - elapsed);

    window.setTimeout(function () {
      if (!loaderElement) {
        return;
      }

      loaderElement.classList.remove("is-visible");
      document.body.classList.remove("vt-loading");

      window.setTimeout(function () {
        if (loaderAnimation && typeof loaderAnimation.destroy === "function") {
          loaderAnimation.destroy();
        }
        loaderAnimation = null;

        if (loaderElement && loaderElement.parentNode) {
          loaderElement.parentNode.removeChild(loaderElement);
        }
        loaderElement = null;
      }, 260);
    }, wait);
  }

  function initGlobalLoader() {
    if (!document.body || document.body.classList.contains("vt-no-global-loader")) {
      return;
    }

    createLoader();

    var finished = false;
    var finalize = function () {
      if (finished) {
        return;
      }
      finished = true;
      removeLoader();
    };

    window.addEventListener("load", finalize, { once: true });
    window.setTimeout(finalize, 4200);
  }

  function isModifierClick(event) {
    return event.metaKey || event.ctrlKey || event.shiftKey || event.altKey;
  }

  function isNavigableLink(link) {
    if (!link || link.hasAttribute("download")) {
      return false;
    }

    var rawHref = link.getAttribute("href");
    if (!rawHref || rawHref === "#" || rawHref.indexOf("javascript:") === 0) {
      return false;
    }

    if (link.getAttribute("target") && link.getAttribute("target") !== "_self") {
      return false;
    }

    if (link.getAttribute("data-toggle")) {
      return false;
    }

    try {
      var url = new URL(rawHref, window.location.href);
      if (url.origin !== window.location.origin) {
        return false;
      }
      if (url.pathname === window.location.pathname && url.search === window.location.search && url.hash) {
        return false;
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  function bindTransitionLoader() {
    document.addEventListener(
      "click",
      function (event) {
        if (navigationInProgress || event.defaultPrevented || event.button !== 0 || isModifierClick(event)) {
          return;
        }

        var target = event.target;
        var link = target && target.closest ? target.closest("a[href]") : null;
        if (!isNavigableLink(link) || link.hasAttribute("data-no-loader")) {
          return;
        }

        var destination = new URL(link.getAttribute("href"), window.location.href).href;
        navigationInProgress = true;
        event.preventDefault();
        showLoaderNow();

        window.setTimeout(function () {
          window.location.assign(destination);
        }, 90);
      },
      true
    );

    document.addEventListener(
      "submit",
      function (event) {
        var form = event.target;
        if (navigationInProgress || event.defaultPrevented || !form || form.hasAttribute("data-no-loader")) {
          return;
        }

        if (form.getAttribute("target") && form.getAttribute("target") !== "_self") {
          return;
        }

        navigationInProgress = true;
        event.preventDefault();
        showLoaderNow();

        window.setTimeout(function () {
          form.submit();
        }, 90);
      },
      true
    );
  }

  window.VTCore = {
    getUserId: getUserId,
    getPageKey: getPageKey,
    prefersReducedMotion: prefersReducedMotion,
    onReady: onReady
  };

  onReady(initGlobalLoader);
  onReady(bindTransitionLoader);
})();
