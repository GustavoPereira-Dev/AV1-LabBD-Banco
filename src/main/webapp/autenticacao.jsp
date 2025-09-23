<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-LN+7fdVzj6u52u30Kp6M/trliBMCMKTyK833zpbD+pXdCLuTusPj697FH4R/5mcr" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/js/bootstrap.bundle.min.js" integrity="sha384-ndDqU0Gzau9qJ1lfW4pNLlhNTkCfHzAVBReH9diLvGRem5+R9g2FzA8ZGN954O5Q" crossorigin="anonymous"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<title>Insert title here</title>
</head>
<body>

		
		<p><c:out value="${auth}" /> </p>
		<c:if test="${auth == 'login'}">
		  <form>
		      <div class="mb-3">
		        <label for="cpf" class="form-label">CPF</label>
		        <input type="text" class="form-control" id="cpf" maxlength="11" required>
		      </div>
		      <div class="mb-3">
	          	<label for="senha" class="form-label">Senha</label>
	            <input type="password" class="form-control" id="senha" maxlength="8" required>
	      	  </div>
	      	  <button type="submit" class="btn btn-primary">Enviar</button>
	      </form>
		</c:if>
		<c:if test="${auth == 'cadastro'}">
		  <form>
	      <div class="mb-3">
	        <label for="cpf" class="form-label">CPF</label>
	        <input type="text" class="form-control" id="cpf" maxlength="11" required>
	      </div>
	      <div class="mb-3">
	        <label for="nome" class="form-label">Nome</label>
	        <input type="text" class="form-control" id="nome" maxlength="100" required>
	      </div>
	      <div class="mb-3">
	        <label for="senha" class="form-label">Senha</label>
	        <input type="password" class="form-control" id="senha" maxlength="8" required>
	      </div>
	      <div class="mb-3">
	        <label for="cpfConjunto" class="form-label">CPF do Conjunto</label>
	        <input type="text" class="form-control" id="cpfConjunto" maxlength="11">
	      </div>
	      <div class="mb-3">
	        <label for="tipoConta" class="form-label">Tipo de Conta</label>
	        <input type="text" class="form-control" id="tipoConta" maxlength="14">
	      </div>
	      <div class="mb-3">
	        <label for="codAgencia" class="form-label">Código da Agência</label>
	        <input type="number" class="form-control" id="codAgencia">
	      </div>
	      <button type="submit" class="btn btn-primary">Enviar</button>
	    </form>
	</c:if>
	
</body>
</html>