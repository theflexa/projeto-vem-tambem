<%@ page pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="cp" value="${pageContext.request.contextPath}" />

<div class="modal fade" id="logoutModal" tabindex="-1" role="dialog" aria-labelledby="logoutTitle" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="logoutTitle">Sair da plataforma</h5>
        <button class="close" type="button" data-dismiss="modal" aria-label="Fechar">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        Sua sessão será encerrada. Você poderá entrar novamente quando quiser.
      </div>
      <div class="modal-footer">
        <button class="btn btn-secondary" type="button" data-dismiss="modal">Continuar no app</button>
        <a class="btn btn-olive" href="${cp}/sair">Sair agora</a>
      </div>
    </div>
  </div>
</div>
