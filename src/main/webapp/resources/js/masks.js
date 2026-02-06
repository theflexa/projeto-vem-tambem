// Inicializa todas as máscaras declaradas em data-inputmask
$(function () {
  if ($.fn.inputmask) {
    $("[data-inputmask]").inputmask();
  }
});
