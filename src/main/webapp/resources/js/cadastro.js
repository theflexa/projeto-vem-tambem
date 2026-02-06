// /resources/js/cadastro.js
(function(){
  // garante execução após DOM pronto
  $(function(){

    // aplica máscaras declarativas (só campos que já trazem a opção 'mask')
    $('[data-inputmask*="mask"]').inputmask();

    // evita submit duplicado
    $('#cadastro-form').on('submit', function(){
      $(this).find('button[type="submit"], input[type="submit"]').prop('disabled', true);
    });

    // ---- CPF/CNPJ dinâmico + placeholder Nome/Razão Social ----
    var nomeInput    = document.getElementById('nome');
    var cpfCnpjInput = document.getElementById('cpf_cnpj');
    var tipoPF       = document.getElementById('tipo_conta_sim');
    var tipoPJ       = document.getElementById('tipo_conta_nao');

    function setMask(mask, placeholder){
      if (!cpfCnpjInput) return;
      if (cpfCnpjInput.inputmask) { cpfCnpjInput.inputmask.remove(); }
      Inputmask({ mask: mask, showMaskOnHover: false }).mask(cpfCnpjInput);
      cpfCnpjInput.placeholder = placeholder;
    }

    function updateNomePlaceholder(){
      if (!nomeInput) return;
      nomeInput.placeholder = (tipoPJ && tipoPJ.checked) ? 'Razão Social' : 'Nome';
    }

    function refresh(){
      if (tipoPF && tipoPF.checked) setMask('999.999.999-99', 'CPF');
      if (tipoPJ && tipoPJ.checked) setMask('99.999.999/9999-99', 'CNPJ');
      updateNomePlaceholder();
    }

    if (tipoPF) tipoPF.addEventListener('change', refresh);
    if (tipoPJ) tipoPJ.addEventListener('change', refresh);

    // aplica ao carregar
    refresh();

    // ---- Toast de erro (se o servidor setou a flag) ----
    var flags = document.getElementById('flags');
    if (flags && (flags.dataset.erro === 'true' || flags.dataset.erro === 'TRUE')) {
      $('#toastBody').text('Houve erros no cadastro. Verifique os campos destacados.');
      $('#toastMsg').toast('show');
    }
  });
})();
