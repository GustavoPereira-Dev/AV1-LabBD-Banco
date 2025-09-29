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
<link rel="icon" href="${pageContext.request.contextPath}/cliente.png">
<title>Cadastro Cliente</title>
</head>
<body>
	<br />
	<div align="center">
		<table border="1">
			<tr>
				<td><a href="index">INICIO</a></td>
				<td><a href="${pageContext.request.contextPath}/cliente?editar=true&usuario=${usuario}">ATUALIZAR CLIENTE</a></td>
				<td><a href="${pageContext.request.contextPath}/conta?usuario=${usuario}">VISUALIZAR CONTAS</a></td>
				<td><a href="${pageContext.request.contextPath}/cliente?logout=true">LOGOUT</a></td>
			</tr>
			<c:if test="${editar}">
							<div class="conteiner" align="center">
					<h1>Atualizar Cliente</h1>
					<br />
					<form action="cliente" method="post">
						<table>
							<tr>
								<td colspan="3">
									<input type="number" min="1" step="1"
									id="usuario" name="usuario" placeholder="#CPF"
									value='<c:out value="${cliente.cpf}"/>'
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
									<input type="text" 
									id="nome" name="nome" placeholder="Nome"
									value='<c:out value="${cliente.nome}"/>'
									class="input-group input-group-lg">
								</td>
							</tr>
							<tr>
								<td colspan="4">
									<input type="date" 
									id="data_primeira_conta" name="data_primeira_conta"
									value='<c:out value="${cliente.dataPrimeiraConta}"/>'
									class="input-group input-group-lg">
								</td>
							</tr>
							<tr>
								<td colspan="4">
									<input type="password" 
									id="senha" name="senha" placeholder="E-mail"
									value='<c:out value="${cliente.senha}"/>'
									class="input-group input-group-lg">
								</td>
							</tr>
							<tr>								
								<td colspan="2">
									<input type="submit"
									id="botao" name="botao" value="Atualizar"
									class="btn btn-dark">
								</td>								
								<td colspan="2">
									<input type="submit"
									id="botao" name="botao" value="Excluir"
									class="btn btn-dark">
								</td>											
							</tr>
						</table>
					</form>
				</div>
			</c:if>
		</table>
	</div>
</body>
</html>