CREATE DATABASE Banco
GO
USE Banco
GO
CREATE TABLE Agencia (
codigo	INT			 NOT NULL,
nome	VARCHAR(100) NOT NULL,
cep		VARCHAR(8)   NOT NULL,
cidade	VARCHAR(100) NOT NULL
PRIMARY KEY(codigo)
)
GO
CREATE TABLE Conta (
codigo			INT				NOT NULL,
dataAbertura	DATE			NOT NULL,
saldo			DECIMAL(7,2)	NOT NULL,
agenciaCodigo	INT				NOT NULL
PRIMARY KEY(codigo)
FOREIGN KEY(agenciaCodigo) REFERENCES Agencia(codigo)
)
GO
CREATE TABLE ContaCorrente (
contaCodigo		INT				NOT NULL,
limiteCredito	DECIMAL(7,2)	NOT NULL
PRIMARY KEY(contaCodigo)
FOREIGN KEY(contaCodigo) REFERENCES Conta(codigo)
)
GO
CREATE TABLE ContaPoupanca (
contaCodigo				INT				NOT NULL,
percentualRendimento	DECIMAL(7,2)	NOT NULL,
diaAniversario			DATE			NOT NULL
PRIMARY KEY(contaCodigo)
FOREIGN KEY(contaCodigo) REFERENCES Conta(codigo)
)
GO
CREATE TABLE Cliente (
cpf						VARCHAR(11)		NOT NULL,
nome					VARCHAR(100)	NOT NULL,
dataPrimeiraConta		DATE			NOT NULL,
senha					VARCHAR(8)		NOT NULL
PRIMARY KEY(cpf)
)

GO
CREATE TABLE ContaCliente (
contaCodigo		INT				NOT NULL,
clienteCpf		VARCHAR(11)		NOT NULL
PRIMARY KEY(contaCodigo, clienteCpf)
FOREIGN KEY(contaCodigo) REFERENCES Conta(codigo),
FOREIGN KEY(clienteCpf) REFERENCES Cliente(cpf)	
)
--STORED PROCEDURES

--O código da conta deve ser o código da agência, concatenado com os 3
--últimos dígitos do CPF do titular (Se for conta conjunta, deve trazer os dois),
--concatenado com um dígito verificador

GO
CREATE PROCEDURE sp_gera_codigo_conta (@codAgencia INT, @cpfTitular VARCHAR(11), 
                                       @cpfConjunto VARCHAR(11), @codConta VARCHAR(20) OUTPUT) AS

DECLARE @soma VARCHAR(100),
		@digitoVerificador INT

SET @soma = CAST(@codAgencia AS VARCHAR(10)) + SUBSTRING(@cpfTitular, 9, 3)

IF @cpfConjunto IS NOT NULL
BEGIN
	SET @soma = @soma + SUBSTRING(@cpfConjunto, 9, 3)
END

EXEC sp_gera_digito_verificador @codAgencia, @digitoVerificador OUTPUT

SET @soma = @soma + CAST(@digitoVerificador AS VARCHAR(10))

--O dígito verificador é a soma de todos os dígitos do RA gerado anteriormente
--e o resultado dividido por 5, por fim, pega-se apenas a parte inteira do resto
--da divisão.

GO
CREATE PROCEDURE sp_gera_digito_verificador (@codAgencia INT, @digitoVerificador INT OUTPUT) AS

DECLARE @soma INT = 0

WHILE @codAgencia > 0
    BEGIN
        SET @soma = @soma + (@codAgencia % 10)
        SET @codAgencia = @codAgencia / 10
    END

SET @digitoVerificador = @soma % 5

--A senha do aluno para acesso ao acervo deve ser cadastrada pelo usuário e,
--deve ter 8 caracteres, sendo que pelo menos 3 deles devem ser numéricos.

GO
CREATE PROCEDURE sp_verifica_senha (@senha VARCHAR(8) OUTPUT) AS

DECLARE @qtdNumeros INT,
		@i INT

IF LEN(@senha) <> 8
BEGIN
	RAISERROR('Senha inválida. A senha deve ter 8 dígitos, tente novamente.', 16, 1)
	RETURN
END

WHILE @i <= @senha
BEGIN
	IF SUBSTRING(@senha, @i, 1) IN ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9')
	BEGIN
		SET @qtdNumeros = @qtdNumeros + 1
		SET @i = @i + 1;
	END
END

IF @qtdNumeros < 3
BEGIN
	RAISERROR('Senha inválida. A senha deve ter pelo menos 3 números, tente novamente.', 16, 1)
    RETURN 
END

--Clientes com contas conjuntas não podem ser excluídos da base. O sistema
--deve permitir atualizar a senha do cliente, o saldo, o limite de crédito e o
--percentual de rendimento da poupança. Outros atributos não podem ser
--atualizados.

GO
CREATE PROCEDURE sp_deleta_cliente (@cpf VARCHAR(11), @codConta INT, @saida VARCHAR(100) OUTPUT) AS

IF CAST(@codConta AS VARCHAR(15)) > 8
BEGIN
	RAISERROR('Não foi possível excluir o cliente, pois ele faz parte de uma conta conjunta', 16, 1)
    RETURN 
END 

DELETE FROM Cliente 
WHERE cpf = @cpf

SET @saida = 'Cliente ' + @cpf + ' foi excluído com sucesso.'

GO
CREATE PROCEDURE sp_atualiza_cliente (@cpf VARCHAR(11), @senha VARCHAR(8), @saida VARCHAR(100) OUTPUT) AS

EXEC sp_verifica_senha @senha OUTPUT

UPDATE Cliente
SET senha = @senha
WHERE cpf = @cpf

SET @saida = 'Cliente ' + @cpf + ' foi atualizado com sucesso.'

GO
CREATE PROCEDURE sp_atualiza_conta (@tipoConta VARCHAR(14), @codConta INT, @saldo DECIMAL(7,2), 
                                    @atributoEspecifico DECIMAL(7,2), @saida VARCHAR(100) OUTPUT) AS

UPDATE Conta
SET saldo = @saldo

IF @tipoConta = 'Conta Corrente'
BEGIN
	UPDATE ContaCorrente
	SET limiteCredito = @atributoEspecifico
END
ELSE
BEGIN
	UPDATE ContaPoupanca
	SET percentualRendimento = @atributoEspecifico	
END

SET @saida = 'Conta ' + @codConta + ' foi atualizada com sucesso.'