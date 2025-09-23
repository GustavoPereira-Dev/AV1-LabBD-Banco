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

		<div class="conteiner" align="center">
		<h1>Cadastro de Contas Correntes</h1>
		<br />
		<form action="conta" method="post">
			<table>
				<tr>
					<td colspan="3">
						<input type="number" min="1" step="1"
						id="codigo" name="codigo" placeholder="#ID"
						value='<c:out value="${conta_corrente.codigo}"/>'
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
						id="data_abertura" name="data_abertura" placeholder="Data Abertura"
						value='<c:out value="${conta_corrente.dataAbertura}"/>'
						class="input-group input-group-lg">
					</td>
				</tr>
				<tr>
					<td colspan="3">
						<input type="number"
						id="saldo" name="saldo" step="0.01" placeholder="Saldo"
						value='<c:out value="${conta_corrente.saldo}"/>'
						class="input-group input-group-lg" >
					</td>
				</tr>
				<tr>
					<td colspan="3">
						<input type="number"
						id="limite_credito" name="limite_credito" step="0.01" placeholder="Limite de Crédito"
						value='<c:out value="${conta_corrente.limiteCredito}"/>'
						class="input-group input-group-lg" >
					</td>
				</tr>
				<tr>
					<td colspan="3">
						<input type="number"
						id="cpf_conjunto" name="cpf_conjunto" step="0.01" placeholder="CPF Conjunto"
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
	
	<div class="conteiner" align="center">
		<c:if test="${not empty contas_correntes}">
			<table class="table table-dark table-striped">
				<thead>
					<tr>
						<th>#CODIGO</th>
						<th>Data de Abertura</th>
						<th>Saldo</th>
						<th>Limite Credito</th>
						<th>Conta Conjunta</th>
						<th></th>
						<th></th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="co" items="${contas_correntes}">
						<tr>
							<td>${co.codigo}</td>
							<td>${co.dataAbertura}</td>
							<td>${co.saldo}</td>
							<td>${co.limiteCredito}</td>
							<td>
								<c:if test="${teste.length() > 8}"> true </c:if>   
								<c:if test="${teste.length() < 8}"> false </c:if> 
							</td>
							<td><a href="${pageContext.request.contextPath}/conta?usuario=${user}&acao=editar&id=${co.codigo}&tipo=corrente">EDITAR</a></td>
							<td><a href="${pageContext.request.contextPath}/conta?usuario=${user}&acao=deletar&id=${co.codigo}&tipo=corrente">EXCLUIR</a></td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</c:if>
	</div>
	
			<br />
	<div class="conteiner" align="center">
		<h1>Cadastro de Contas Poupancas</h1>
		<form action="conta" method="post">
			<table>
				<tr>
					<td colspan="3">
						<input type="number" min="1" step="1"
						id="codigo" name="codigo" placeholder="#ID"
						value='<c:out value="${conta_poupanca.codigo}"/>'
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
						id="data_abertura" name="data_abertura" placeholder="Data Abertura"
						value='<c:out value="${conta_poupanca.dataAbertura}"/>'
						class="input-group input-group-lg">
					</td>
				</tr>
				<tr>
					<td colspan="3">
						<input type="number"
						id="saldo" name="saldo" step="0.01" placeholder="Saldo"
						value='<c:out value="${conta_poupanca.saldo}"/>'
						class="input-group input-group-lg" >
					</td>
				</tr>
				<tr>
					<td colspan="4">
						<input type="date" 
						id="dia_aniversario" name="dia_aniversario" placeholder="Dia Aniversario"
						value='<c:out value="${conta_poupanca.diaAniversario}"/>'
						class="input-group input-group-lg">
					</td>
				</tr>
				<tr>
					<td colspan="3">
						<input type="number"
						id="percentual_rendimento" name="percentual_rendimento" step="0.01" placeholder="Percentual de Rendimento"
						value='<c:out value="${conta_poupanca.percentualRendimento}"/>'
						class="input-group input-group-lg" >
					</td>
				</tr>
				<tr>
					<td colspan="3">
						<input type="number"
						id="cpf_conjunto" name="cpf_conjunto" step="0.01" placeholder="CPF Conjunto"
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
	
	<div class="conteiner" align="center">
		<c:if test="${not empty contas_poupancas}">
			<table class="table table-dark table-striped">
				<thead>
					<tr>
						<th>#CODIGO</th>
						<th>Data de Abertura</th>
						<th>Saldo</th>
						<th>Percentual de Rendimento</th>
						<th>Dia de Aniversario</th>
						<th>Conta Conjunta</th>
						<th></th>
						<th></th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="po" items="${contas_poupancas}">
						<tr>
							<td>${po.codigo}</td>
							<td>${cco.dataAbertura}</td>
							<td>${cco.saldo}</td>
							<td>${co.percentualRendimento}</td>
							<td>${co.diaRendimento}</td>
							<td>
								<c:if test="${po.codigo % 10 < 9}"> true </c:if>   
								<c:if test="${po.codigo % 10 > 9}"> false </c:if> 
							</td>
							<td><a href="${pageContext.request.contextPath}/conta?usuario=${user}&acao=editar&id=${po.codigo}&tipo=corrente">EDITAR</a></td>
							<td><a href="${pageContext.request.contextPath}/conta?usuario=${user}&acao=deletar&id=${po.codigo}&tipo=corrente">EXCLUIR</a></td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</c:if>
	</div>
</body>
</html>