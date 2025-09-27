<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title></title>
</head>
<body>
	<div align="center">
		<table border="1">
			<tr>
				<td><a href="index">INICIO</a></td>
				<td><a href="${pageContext.request.contextPath}/autenticacao?auth=cadastro">CADASTRO</a></td>
				<td><a href="${pageContext.request.contextPath}/autenticacao?auth=login">LOGIN</a></td>
				<td><a href="${pageContext.request.contextPath}/agencia">AGENCIA</a></td>
			</tr>
		</table>
	</div>
</body>
</html>