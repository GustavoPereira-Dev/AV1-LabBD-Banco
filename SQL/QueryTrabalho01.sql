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
codigo			BIGINT			NOT NULL,
dataAbertura	DATE			NOT NULL,
saldo			DECIMAL(7,2)	NOT NULL,
agenciaCodigo	INT				NOT NULL
PRIMARY KEY(codigo)
FOREIGN KEY(agenciaCodigo) REFERENCES Agencia(codigo)
)

GO
CREATE TABLE ContaCorrente (
contaCodigo		BIGINT			NOT NULL,
limiteCredito	DECIMAL(7,2)	NOT NULL
PRIMARY KEY(contaCodigo)
FOREIGN KEY(contaCodigo) REFERENCES Conta(codigo)
)
GO
CREATE TABLE ContaPoupanca (
contaCodigo				BIGINT			NOT NULL,
percentualRendimento	DECIMAL(7,2)	NOT NULL,
diaAniversario			INT			    NOT NULL
PRIMARY KEY(contaCodigo)
FOREIGN KEY(contaCodigo) REFERENCES Conta(codigo)
)

GO
CREATE TABLE Cliente (
cpf						VARCHAR(11)		NOT NULL,
nome					VARCHAR(100)	NOT NULL,
dataPrimeiraConta		DATE			        ,
senha					VARCHAR(8)		NOT NULL
PRIMARY KEY(cpf)
)

GO
CREATE TABLE ContaCliente (
contaCodigo		BIGINT			NOT NULL,
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
CREATE PROCEDURE sp_gerar_codigo_conta (@codAgencia INT, @cpfTitular VARCHAR(11), 
                                        @cpfConjunto VARCHAR(11), @codConta BIGINT OUTPUT) AS

DECLARE @soma VARCHAR(100),
		@digitoVerificador INT

SET @soma = CAST(@codAgencia AS VARCHAR(10)) + SUBSTRING(@cpfTitular, 9, 3)

IF @cpfConjunto IS NOT NULL
BEGIN
	SET @soma = @soma + SUBSTRING(@cpfConjunto, 9, 3)
END

EXEC sp_gerar_digito_verificador @codAgencia, @digitoVerificador OUTPUT

SET @soma = @soma + CAST(@digitoVerificador AS VARCHAR(10))

SET @codConta = CAST(@soma AS BIGINT)

--O dígito verificador é a soma de todos os dígitos do RA gerado anteriormente
--e o resultado dividido por 5, por fim, pega-se apenas a parte inteira do resto
--da divisão.

GO
CREATE PROCEDURE sp_gerar_digito_verificador (@codAgencia INT, @digitoVerificador INT OUTPUT) AS

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
CREATE PROCEDURE sp_verificar_senha (@senha VARCHAR(8) OUTPUT) AS

DECLARE @qtdNumeros INT,
		@i INT

IF LEN(@senha) <> 8
BEGIN
	RAISERROR('Senha inválida. A senha deve ter 8 dígitos, tente novamente.', 16, 1)
	RETURN
END

WHILE @i <= LEN(@senha)
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
CREATE PROCEDURE sp_excluir_cliente (@cpf VARCHAR(11), @codConta BIGINT, @saida VARCHAR(100) OUTPUT) AS

IF LEN(@codConta) > 8
BEGIN
	RAISERROR('Não foi possível excluir o cliente, pois ele faz parte de uma conta conjunta', 16, 1)
    RETURN 
END 

DELETE FROM Cliente 
WHERE cpf = @cpf

SET @saida = 'Cliente ' + @cpf + ' foi excluído com sucesso.'

GO
CREATE PROCEDURE sp_atualizar_cliente (@cpf VARCHAR(11), @senha VARCHAR(8), @saida VARCHAR(100) OUTPUT) AS

EXEC sp_verificar_senha @senha OUTPUT

UPDATE Cliente
SET senha = @senha
WHERE cpf = @cpf

SET @saida = 'Cliente ' + @cpf + ' foi atualizado com sucesso.'

GO
CREATE PROCEDURE sp_atualizar_conta (@tipoConta VARCHAR(14), @codConta BIGINT, @saldo DECIMAL(7,2), 
                                     @atributoEspecifico DECIMAL(7,2), @saida VARCHAR(100) OUTPUT) AS
UPDATE Conta
SET saldo = @saldo
WHERE codigo = @codConta

IF @tipoConta = 'Conta Corrente'
BEGIN
	UPDATE ContaCorrente
	SET limiteCredito = @atributoEspecifico
	WHERE contaCodigo = @codConta
END
ELSE
BEGIN
	UPDATE ContaPoupanca
	SET percentualRendimento = @atributoEspecifico
	WHERE contaCodigo = @codConta
END

SET @saida = @tipoConta + ' ' + CAST(@codConta AS VARCHAR(20)) + ' foi atualizada com sucesso.'

--Um cliente novo deve preencher seus dados, o tipo de conta escolhida que
--inicia com saldo zerado e limite de crédito em 500,00. Se for poupança, o dia
--de aniversário padrão é dia 10, com início de rendimento em 1%.

--Uma conta conjunta nova começa com o cadastro de um cliente.

--			(Quando o cliente se cadastrar, ele irá escolher se ele vai querer criar uma conta individual ou 
--           uma conta conjunta. Se ele digitar um segundo CPF a conta será conjunta.)

GO
CREATE PROCEDURE sp_inserir_cliente (@cpf VARCHAR(11), @nome VARCHAR(100), @senha VARCHAR(8),
									 @cpfConjunto VARCHAR(11), @tipoConta VARCHAR(14), @codAgencia INT,
                                     @saida VARCHAR(100) OUTPUT) AS

DECLARE @dataPrimeiraConta DATE = GETDATE()

EXEC sp_verificar_senha @senha OUTPUT

INSERT INTO Cliente (cpf, nome, senha, dataPrimeiraConta) VALUES
                    (@cpf, @nome, @senha, @dataPrimeiraConta)

SET @saida = 'Cliente ' + @cpf + ' foi inserido com sucesso.'

SET @dataPrimeiraConta = GETDATE()

EXEC sp_inserir_conta @cpf, @tipoConta, @codAgencia, @cpfConjunto, @dataPrimeiraConta, @saida

GO
CREATE PROCEDURE sp_inserir_conta (@cpfTitular VARCHAR(11), @tipoConta VARCHAR(14), @codAgencia INT,
								   @cpfConjunto VARCHAR(11), @dataAbertura DATE, 
								   @saida VARCHAR(100) OUTPUT) AS

DECLARE @codConta BIGINT

EXEC sp_gerar_codigo_conta @codAgencia, @cpfTitular, NULL, @codConta OUTPUT

INSERT INTO Conta (codigo, dataAbertura, saldo, agenciaCodigo) VALUES
                  (@codConta, @dataAbertura, 0.0, @codAgencia)

IF @tipoConta = 'Conta Corrente'
BEGIN
	INSERT INTO ContaCorrente VALUES
	(@codConta, 500.00)
END 
ELSE
BEGIN
	INSERT INTO ContaPoupanca VALUES
	(@codConta, 1.0, 10)
END

INSERT INTO ContaCliente VALUES
(@codConta, @cpfTitular)

SET @saida = @tipoConta + ' ' + CAST(@codConta AS VARCHAR(20)) + ' foi criada com sucesso.'

--Para se incluir um(a) companheiro(a) na conta conjunta, esta já precisa
--existir e ter um cliente cadastrado. Deve se passar por uma tela de login e
--senha para autorizar a inclusão de um cliente na conta conjunta.

GO
CREATE PROCEDURE sp_autorizar_cliente (@cpfLogin VARCHAR(11), @senha VARCHAR(8), @codConta BIGINT, 
                                       @saldo DECIMAL(7,2), @dataAbertura DATE, @cpfConjunto VARCHAR(11), 
									   @saida VARCHAR(100) OUTPUT) AS
DECLARE @valido BIT = 0

EXEC sp_verificar_saldo @codConta, @saldo, @dataAbertura, @valido OUTPUT

IF @valido = 1
BEGIN
	INSERT INTO ContaCliente VALUES
	(@codConta, @cpfConjunto)
END
ELSE
BEGIN
	RAISERROR('Não foi possível adicionar o cliente na conta conjunta, pois o saldo é igual a 0', 16, 1)
	RETURN
END

SET @saida = 'Adição do CPF ' + @cpfConjunto + ' na conta conjunta ' + CAST(@codConta AS VARCHAR(20)) + 
             ' foi um sucesso.'

--Não é permitido incluir um(a) companheiro(a) na conta conjunta em uma
--conta com saldo menor ou igual a zero. Salvo conta criada no mesmo dia.

GO
CREATE PROCEDURE sp_verificar_saldo (@codConta BIGINT, @saldo DECIMAL(7,2), @dataAbertura DATE,
                                     @valido BIT OUTPUT) AS
DECLARE @diaHoje DATE = GETDATE()

IF @saldo <= 0.0 AND @diaHoje <> @dataAbertura
BEGIN
	RETURN
END
ELSE
BEGIN
	SET @valido = 1
END

-- DEMAIS PROCEDURES QUE NÃO ESTAVAM NAS REGRAS DE NEGÓCIO

GO
CREATE PROCEDURE sp_inserir_agencia (@codigo INT, @nome VARCHAR(100), @cep VARCHAR(8), 
                                     @cidade VARCHAR(100), @saida VARCHAR(100) OUTPUT) AS
INSERT INTO Agencia VALUES
(@codigo, @nome, @cep, @cidade)

SET @saida = 'Agência ' + CAST(@codigo AS VARCHAR(6)) + ' foi adicionada com sucesso.'

GO
CREATE PROCEDURE sp_excluir_agencia (@codigo INT, @saida VARCHAR(100) OUTPUT) AS

DELETE FROM Agencia
WHERE codigo = @codigo

SET @saida = 'Agência ' + CAST(@codigo AS VARCHAR(6)) + ' foi excluída com sucesso.'

GO
CREATE PROCEDURE sp_atualizar_agencia (@codigo INT, @nome VARCHAR(100), @cep VARCHAR(8), 
                                       @cidade VARCHAR(100), @saida VARCHAR(100) OUTPUT) AS
UPDATE Agencia
SET nome = @nome,
	cep = @cep,
	cidade = @cidade
WHERE codigo = @codigo

SET @saida = 'Agência ' + CAST(@codigo AS VARCHAR(6)) + ' foi atualizada com sucesso.'

GO
CREATE PROCEDURE sp_excluir_conta (@codConta BIGINT, @tipoConta VARCHAR(14), @saida VARCHAR(100) OUTPUT) AS

DELETE FROM ContaCliente
WHERE contaCodigo = @codConta

IF @tipoConta = 'Conta Corrente'
BEGIN
	DELETE FROM ContaCorrente
	WHERE contaCodigo = @codConta
END
ELSE
BEGIN
	DELETE FROM ContaPoupanca
	WHERE contaCodigo = @codConta
END

DELETE FROM Conta
WHERE codigo = @codConta

SET @saida = @tipoConta + ' ' + CAST(@codConta AS VARCHAR(20)) + ' foi excluída com sucesso.'