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
<link rel="icon" href="${pageContext.request.contextPath}/conta.jpg">
<title>Cadastro Conta Corrente</title>
</head>
<body>
	<br />
	<div class="conteiner" align="center">
		<h1>Cadastro de Contas Correntes</h1>
		<br />
		<form action="pessoa" method="post">
			<table>
				<tr>
					<td colspan="3">
						<input type="number" min="1" step="1"
						id="id" name="id" placeholder="#CODIGO"
						value='<c:out value="${contaCorrente.codigo}"/>'
						class="input-group input-group-lg" >
					</td>
					<td colspan="1">
						<input type="submit"
						id="botao" name="botao" value="Buscar"
						class="btn btn-dark">
					</td>				
				</tr>
				<tr>
					<td colspan="4">
						<input type="date" 
						id="data_abertura" name="data_abertura" placeholder="Data da Abertura"
						value='<c:out value="${contaCorrente.dataAbertura}"/>'
						class="input-group input-group-lg">
					</td>
				</tr>		
				<tr>
					<td colspan="4">
						<input type="number" step="0.01"
						id="saldo" name="saldo" placeholder="Saldo"
						value='<c:out value="${contaCorrente.saldo}"/>'
						class="input-group input-group-lg">
					</td>
				</tr>
				<tr>
					<td colspan="3">
						<input type="number"
						id="limite_credito" name="limite_credito" step="0.01" placeholder="Limite de Crédito"
						value='<c:out value="${contaCorrente.limiteCredito}"/>'
						class="input-group input-group-lg" >
					</td>
				</tr>
				<tr>
					<td>
						<input type="submit"
						id="botao" name="botao" value="Inserir"
						class="btn btn-dark">
					</td>								
					<td>
						<input type="submit"
						id="botao" name="botao" value="Atualizar"
						class="btn btn-dark">
					</td>								
					<td>
						<input type="submit"
						id="botao" name="botao" value="Excluir"
						class="btn btn-dark">
					</td>								
					<td>
						<input type="submit"
						id="botao" name="botao" value="Listar"
						class="btn btn-dark">
					</td>								
				</tr>
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
		<c:if test="${not empty contas_correntes}">
			<table class="table table-dark table-striped">
				<thead>
					<tr>
						<th>#CODIGO</th>
						<th>Data Abertura</th>
						<th>Saldo</th>
						<th>Limite Credito</th>
						<th></th>
						<th></th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="c" items="${contas_correntes}">
						<tr>
							<td>${c.codigo}</td>
							<td>${c.dataAbertura}</td>
							<td>${c.saldo}</td>
							<td>${c.limiteCredito}</td>
							<td><a href="${pageContext.request.contextPath}/pessoa?acao=editar&id=${p.id}">EDITAR</a></td>
							<td><a href="${pageContext.request.contextPath}/pessoa?acao=excluir&id=${p.id}">EXCLUIR</a></td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</c:if>
	</div>
</body>
</html>