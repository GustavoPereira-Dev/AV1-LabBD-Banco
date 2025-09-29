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
<link rel="icon" href="${pageContext.request.contextPath}/agencia.jpg">
<title>Cadastro Agencia</title>
</head>
<body>
	<br />
	<div class="conteiner" align="center">
		<h1>Cadastro de Agencias</h1>
		<br />
		<form action="agencia" method="post">
			<table>
				<div class="mb-3" align="center">
			    	<label for="codigo" class="form-label">Codigo da Agência</label>
			    	<input type="text" class="form-control" id="codigo" name="codigo" required>
			    </div>
			     
			    <div class="mb-3" align="center">
					<label for="nome" class="form-label">Nome da Agência</label>
				 	<input type="text" class="form-control" id="nome" name="nome" maxlength="100" required>
				</div>
				 
				<div class="mb-3" align="center">
			        <label for="nome" class="form-label">CEP</label>
			        <input type="text" class="form-control" id="cep" name="cep" maxlength="8" required>
				</div>
				 
				<div class="mb-3" align="center">
			    	<label for="cidade" class="form-label">Cidade da Agência</label>
					<input type="text" class="form-control" id="cidade" name="cidade" maxlength="100" required>
				</div>
				<div class="mb-3" align="center">
					<input type="submit" 
					id="botao" name="botao" value="Inserir" 
					class="btn btn-primary">
					
					<input type="submit" 
					id="botao" name="botao" value="Atualizar" 
					class="btn btn-primary">
					
					<input type="submit" 
					id="botao" name="botao" value="Excluir" 
					class="btn btn-primary">
					
					<input type="submit" 
					id="botao" name="botao" value="Listar" 
					class="btn btn-primary">
				</div>
			</table>
		</form>
	</div>
	<br />
	<div class="conteiner" align="center">
		<c:if test="${not empty saida}">
			<h2 style="color: blue;"><c:out value="${saida}" /></h2>
		</c:if>
	</div>
	<div class="conteiner" align="center">
		<c:if test="${not empty erro}">
			<h2 style="color: red;"><c:out value="${erro}" /></h2>
		</c:if>
	</div>
	<div class="conteiner" align="center">
		<c:if test="${not empty agencias}">
			<table class="table table-light table-striped">
				<thead>
					<tr>
						<th>#ID</th>
						<th>Nome</th>
						<th>CEP</th>
						<th>Cidade</th>
						<th></th>
						<th></th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="a" items="${agencias}">
						<tr>
							<td>${a.codigo}</td>
							<td>${a.nome}</td>
							<td>${a.cep}</td>
							<td>${a.cidade}</td>
							<td><a href="${pageContext.request.contextPath}/agencia?acao=editar&codigo=${a.codigo}">EDITAR</a></td>
							<td><a href="${pageContext.request.contextPath}/agencia?acao=excluir&codigo=${a.codigo}">EXCLUIR</a></td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</c:if>
	</div>
</body>
</html>