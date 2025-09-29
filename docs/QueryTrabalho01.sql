CREATE DATABASE BancoAV1
GO
USE BancoAV1
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
codigo			VARCHAR(20)		NOT NULL,
dataAbertura	DATE			NOT NULL,
saldo			DECIMAL(7,2)	NOT NULL,
agenciaCodigo	INT				NOT NULL
PRIMARY KEY(codigo)
FOREIGN KEY(agenciaCodigo) REFERENCES Agencia(codigo)
)

GO
CREATE TABLE ContaCorrente (
contaCodigo		VARCHAR(20)		NOT NULL,
limiteCredito	DECIMAL(7,2)	NOT NULL
PRIMARY KEY(contaCodigo)
FOREIGN KEY(contaCodigo) REFERENCES Conta(codigo)
)
GO
CREATE TABLE ContaPoupanca (
contaCodigo				VARCHAR(20)		NOT NULL,
percentualRendimento	DECIMAL(7,2)	NOT NULL,
diaAniversario			TINYINT		    NOT NULL
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
contaCodigo		VARCHAR(20)		NOT NULL,
clienteCpf		VARCHAR(11)		NOT NULL
PRIMARY KEY(contaCodigo, clienteCpf)
FOREIGN KEY(contaCodigo) REFERENCES Conta(codigo),
FOREIGN KEY(clienteCpf) REFERENCES Cliente(cpf)	
)

DROP TABLE Conta;
DROP TABLE ContaCorrente;
DROP TABLE ContaPoupanca;
DROP TABLE ContaCliente;
--STORED PROCEDURES

--O código da conta deve ser o código da agência, concatenado com os 3
--últimos dígitos do CPF do titular (Se for conta conjunta, deve trazer os dois),
--concatenado com um dígito verificador

GO
CREATE PROCEDURE sp_gerar_codigo_conta (@codAgencia INT, @cpfTitular VARCHAR(11), 
                                        @cpfConjunto VARCHAR(11), @codConta VARCHAR(20) OUTPUT) 
AS

	DECLARE @soma VARCHAR(100),
			@digitoVerificador INT

	SET @soma = CAST(@codAgencia AS VARCHAR(10)) + SUBSTRING(@cpfTitular, 9, 3)

	IF @cpfConjunto IS NOT NULL
	BEGIN
		SET @soma = @soma + SUBSTRING(@cpfConjunto, 9, 3)
	END

	EXEC sp_gerar_digito_verificador @codAgencia, @digitoVerificador OUTPUT

	SET @soma = @soma + CAST(@digitoVerificador AS VARCHAR(10))

	SET @codConta = @soma

--O dígito verificador é a soma de todos os dígitos do RA gerado anteriormente
--e o resultado dividido por 5, por fim, pega-se apenas a parte inteira do resto
--da divisão.

GO
CREATE PROCEDURE sp_gerar_digito_verificador (@codAgencia INT, @digitoVerificador INT OUTPUT) 
AS

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
/*CREATE PROCEDURE sp_verificar_senha (@senha VARCHAR(8), @valido BIT OUTPUT)
AS

	DECLARE @qtdNumeros INT = 0,
			@i INT = 0

	IF LEN(@senha) <> 8
	BEGIN
		RAISERROR('Senha inválida. A senha deve ter 8 dígitos, tente novamente.', 16, 1)
		SET @valido = 0
		RETURN
	END

	WHILE @i <= LEN(@senha)
	BEGIN
		IF SUBSTRING(@senha, @i, 1) IN ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9')
		BEGIN
			SET @qtdNumeros = @qtdNumeros + 1
		END
		SET @i = @i + 1
	END

	IF @qtdNumeros < 3
	BEGIN
		RAISERROR('Senha inválida. A senha deve ter pelo menos 3 números, tente novamente.', 16, 1)
		SET @valido = 0
		RETURN 
	END

	SET @valido = 1*/

CREATE PROCEDURE sp_verificar_senha (@senha VARCHAR(8))
AS

	DECLARE @qtdNumeros INT = 0,
			@i INT = 0

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
		END
		SET @i = @i + 1
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
CREATE ALTER PROCEDURE sp_excluir_cliente (@cpf VARCHAR(11), @saida VARCHAR(100) OUTPUT) 
AS

	DECLARE @possuiConjunta INT = (SELECT DISTINCT COUNT(cc2.clienteCpf)
	FROM ContaCliente cc1
	JOIN ContaCliente cc2
	  ON cc1.contaCodigo = cc2.contaCodigo
	WHERE cc1.clienteCpf = @cpf -- CPF do cliente que você quer verificar
	  AND cc2.clienteCpf <> cc1.clienteCpf)

	IF(@possuiConjunta > 0)
	BEGIN
		RAISERROR('Não foi possível excluir o cliente, pois ele faz parte de uma conta conjunta', 16, 1)
		RETURN 
	END 

    -- Excluir vínculos em ContaCliente
    DELETE FROM ContaCliente
    WHERE contaCodigo IN (
        SELECT c.codigo
        FROM Conta c
        JOIN ContaCliente cc ON cc.contaCodigo = c.codigo
        WHERE cc.clienteCpf = @cpf
          AND CAST(c.codigo AS VARCHAR) LIKE '%' + RIGHT(@cpf, 3) + '%'
    );

    -- Excluir de ContaCorrente
    DELETE FROM ContaCorrente
    WHERE contaCodigo IN (
        SELECT c.codigo
        FROM Conta c
        JOIN ContaCliente cc ON cc.contaCodigo = c.codigo
        WHERE cc.clienteCpf = @cpf
          AND CAST(c.codigo AS VARCHAR) LIKE '%' + RIGHT(@cpf, 3) + '%'
    );

    -- Excluir de ContaPoupanca
    DELETE FROM ContaPoupanca
    WHERE contaCodigo IN (
        SELECT c.codigo
        FROM Conta c
        JOIN ContaCliente cc ON cc.contaCodigo = c.codigo
        WHERE cc.clienteCpf = @cpf
          AND CAST(c.codigo AS VARCHAR) LIKE '%' + RIGHT(@cpf, 3) + '%'
    );

    -- Excluir da Conta
    DELETE FROM Conta
    WHERE codigo IN (
        SELECT c.codigo
        FROM Conta c
        JOIN ContaCliente cc ON cc.contaCodigo = c.codigo
        WHERE cc.clienteCpf = @cpf
          AND CAST(c.codigo AS VARCHAR) LIKE '%' + RIGHT(@cpf, 3) + '%'
    );


	SET @saida = 'Cliente ' + @cpf + ' foi excluído com sucesso.'


GO
CREATE PROCEDURE sp_atualizar_cliente (@cpf VARCHAR(11), @senha VARCHAR(8), @saida VARCHAR(100) OUTPUT) 
AS

	DECLARE @erro VARCHAR(MAX);

	BEGIN TRY
		EXEC sp_verificar_senha @senha
		-- EXEC sp_valida_cpf @cpf


		UPDATE Cliente
		SET senha = @senha
		WHERE cpf = @cpf

		SET @saida = 'Cliente ' + @cpf + ' foi atualizado com sucesso.'
	END TRY
	BEGIN CATCH
		SET @erro = ERROR_MESSAGE();
		PRINT(@erro)
	END CATCH

DECLARE @mensagem VARCHAR(100)
EXEC sp_atualizar_cliente '64018991070', '2312WASA', @mensagem
PRINT(@mensagem)

GO
CREATE PROCEDURE sp_atualizar_conta (@tipoConta VARCHAR(14), @codConta VARCHAR(20), @saldo DECIMAL(7,2), 
                                     @atributoEspecifico DECIMAL(7,2), @saida VARCHAR(100) OUTPUT) 
AS

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
		SET percentualRendimento = @atributoEspecifico,
			diaAniversario = DAY(GETDATE())
		WHERE contaCodigo = @codConta
	END

	SET @saida = @tipoConta + ' ' + CAST(@codConta AS VARCHAR(20)) + ' foi atualizada com sucesso.'

GO

			UPDATE Conta
			SET saldo = 50.00
			WHERE codigo = '210783'


CREATE PROCEDURE sp_login_usuario @usuario VARCHAR(11), @senha VARCHAR(8), @mensagem VARCHAR(100) OUTPUT
AS	
	IF((SELECT senha FROM Cliente WHERE cpf = @usuario) = @senha)
		SET @mensagem = 'Usuario logado com sucesso'
	ELSE
		RAISERROR('Usuario ou senha incorreta', 16, 1)

--Um cliente novo deve preencher seus dados, o tipo de conta escolhida que
--inicia com saldo zerado e limite de crédito em 500,00. Se for poupança, o dia
--de aniversário padrão é dia 10, com início de rendimento em 1%.

--Uma conta conjunta nova começa com o cadastro de um cliente.

--			(Quando o cliente se cadastrar, ele irá escolher se ele vai querer criar uma conta individual ou 
--           uma conta conjunta. Se ele digitar um segundo CPF a conta será conjunta.)

GO
CREATE PROCEDURE sp_inserir_cliente (@cpf VARCHAR(11), @nome VARCHAR(100), @senha VARCHAR(8),
									 @tipoConta VARCHAR(14), @codAgencia INT,
                                     @saida VARCHAR(100) OUTPUT)
AS

	DECLARE @dataPrimeiraConta DATE = GETDATE(), @valido BIT, @erro VARCHAR(MAX)

	BEGIN TRY
		EXEC sp_verificar_senha @senha
		-- EXEC sp_valida_cpf @cpf

		IF @valido = 0
		BEGIN
			RETURN
		END

		INSERT INTO Cliente (cpf, nome, senha, dataPrimeiraConta) VALUES
							(@cpf, @nome, @senha, @dataPrimeiraConta)

		SET @saida = 'Cliente ' + @cpf + ' foi inserido com sucesso.'

		SET @dataPrimeiraConta = GETDATE()

		EXEC sp_inserir_conta @cpf, @tipoConta, @codAgencia, NULL, @dataPrimeiraConta, @saida
	END TRY
	BEGIN CATCH
		SET @erro = ERROR_MESSAGE()

		IF(@erro LIKE '%PRIMARY KEY%')
			RAISERROR('Cliente ja existente!', 16, 1)
		ELSE IF(@erro LIKE '%FOREIGN KEY%')
			RAISERROR('Agencia inexistente!', 16, 1)
		ELSE
			RAISERROR(@erro, 16, 1)
	END CATCH


GO
CREATE PROCEDURE sp_inserir_conta (@cpfTitular VARCHAR(11), @tipoConta VARCHAR(14), @codAgencia INT,
								   @cpfConjunto VARCHAR(11), @dataAbertura DATE, 
								   @saida VARCHAR(100) OUTPUT) 
AS

	DECLARE @codConta VARCHAR(20)

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
CREATE PROCEDURE sp_autorizar_cliente (@cpfLogin VARCHAR(11), @senha VARCHAR(8), @codConta VARCHAR(20), 
                                       @saldo DECIMAL(7,2), @dataAbertura DATE, @cpfConjunto VARCHAR(11), 
									   @saida VARCHAR(100) OUTPUT) 
AS

	DECLARE @valido BIT = 0, @erro VARCHAR(MAX)

	EXEC sp_verificar_saldo @codConta, @saldo, @dataAbertura, @valido OUTPUT


	IF @valido = 1
	BEGIN
		BEGIN TRY
			INSERT INTO ContaCliente VALUES
			(@codConta, @cpfConjunto)
		END TRY
		BEGIN CATCH
			SET @erro = ERROR_MESSAGE();

			IF(@erro LIKE 'FOREIGN KEY')
				RAISERROR('O cpf do outro cliente e inexistente no sistema!', 16, 1)
			ELSE IF (@erro LIKE 'FOREIGN KEY')
				RAISERROR('Voce ja possui uma conta conjunta com o cpf do outro cliente', 16, 1)

			RETURN

		END CATCH
	END
	ELSE
	BEGIN
		/*
		BEGIN TRY
			EXEC sp_valida_cpf @cpfLogin, @valido OUTPUT
			EXEC sp_valida_cpf @cpfConjunto, @valido OUTPUT
		END TRY
		BEGIN CATCH
			RETURN
		END CATCH
		*/
    
		IF(@valido = 1)
			RAISERROR('Não foi possível adicionar o cliente na conta conjunta, pois o saldo é igual a 0', 16, 1)
			RETURN

		RETURN
	END

	SET @saida = 'Adição do CPF ' + @cpfConjunto + ' na conta conjunta ' + CAST(@codConta AS VARCHAR(20)) + 
				 ' foi um sucesso.'

--Não é permitido incluir um(a) companheiro(a) na conta conjunta em uma
--conta com saldo menor ou igual a zero. Salvo conta criada no mesmo dia.

GO
CREATE PROCEDURE sp_verificar_saldo (@codConta VARCHAR(20), @saldo DECIMAL(7,2), @dataAbertura DATE,
                                     @valido BIT OUTPUT) 
AS
	DECLARE @diaHoje DATE = GETDATE()

	IF @saldo <= 0.0 AND @diaHoje <> @dataAbertura
	BEGIN
		RAISERROR('Quantidade de saldo invalida', 16, 1)
		RETURN
	END
	ELSE
	BEGIN
		SET @valido = 1
	END

-- DEMAIS PROCEDURES QUE NÃO ESTAVAM NAS REGRAS DE NEGÓCIO (OUTROS CRUDS)

GO
CREATE PROCEDURE sp_inserir_agencia (@codigo INT, @nome VARCHAR(100), @cep VARCHAR(8), 
                                     @cidade VARCHAR(100), @saida VARCHAR(100) OUTPUT) 
AS
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
                                       @cidade VARCHAR(100), @saida VARCHAR(100) OUTPUT) 
AS
	UPDATE Agencia
	SET nome = @nome,
		cep = @cep,
		cidade = @cidade
	WHERE codigo = @codigo

	SET @saida = 'Agência ' + CAST(@codigo AS VARCHAR(6)) + ' foi atualizada com sucesso.'

GO



CREATE PROCEDURE sp_excluir_conta (@codConta VARCHAR(20), @tipoConta VARCHAR(14), @saida VARCHAR(100) OUTPUT) 
AS

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

CREATE PROCEDURE sp_valida_cpf
    @CPF VARCHAR(11)
AS
    DECLARE @i INT = 1
    DECLARE @Soma1 INT = 0
    DECLARE @Soma2 INT = 0
    DECLARE @Digito1 INT
    DECLARE @Digito2 INT
	DECLARE @Valido BIT

    IF @CPF IN (
        '00000000000','11111111111','22222222222','33333333333',
        '44444444444','55555555555','66666666666','77777777777',
        '88888888888','99999999999'
    )
    BEGIN
        SET @Valido = 0
        RAISERROR('CPF invalido!', 1, 16)
    END

    WHILE @i <= 9
    BEGIN
        SET @Soma1 = @Soma1 + CAST(SUBSTRING(@CPF, @i, 1) AS INT) * (11 - @i)
        SET @i = @i + 1
    END

    SET @Digito1 = CASE WHEN (@Soma1 * 10) % 11 = 10 THEN 0 ELSE (@Soma1 * 10) % 11 END

    SET @i = 1
    WHILE @i <= 10
    BEGIN
        SET @Soma2 = @Soma2 + CAST(SUBSTRING(@CPF, @i, 1) AS INT) * (12 - @i)
        SET @i = @i + 1
    END

    SET @Digito2 = CASE WHEN (@Soma2 * 10) % 11 = 10 THEN 0 ELSE (@Soma2 * 10) % 11 END

    IF @Digito1 = CAST(SUBSTRING(@CPF, 10, 1) AS INT) AND
       @Digito2 = CAST(SUBSTRING(@CPF, 11, 1) AS INT)
        SET @Valido = 1
    ELSE
        SET @Valido = 0
		RAISERROR('CPF invalido!', 1, 16)


SELECT * FROM Cliente;
SELECT * FROM Conta;
SELECT * FROM ContaCorrente;
SELECT * FROM ContaPoupanca;
SELECT * FROM ContaCliente;
SELECT * FROM Agencia;

SELECT c.codigo, c.dataAbertura, c.saldo, c.agenciaCodigo, p.percentualRendimento, p.diaAniversario FROM ContaP p INNER JOIN Conta c ON p.contaCodigo = c.codigo WHERE c.codigo IN (SELECT contaCodigo FROM ContaCliente WHERE contaCodigo = '210783')

INSERT INTO Agencia VALUES(20, 'Teste2', '05322123', 'Sao Paulo')

SELECT c.codigo, c.dataAbertura, c.saldo, c.agenciaCodigo, p.percentualRendimento, p.diaAniversario FROM ContaPoupanca p INNER JOIN Conta c ON p.contaCodigo = c.codigo WHERE c.codigo IN (SELECT contaCodigo FROM ContaCliente WHERE clienteCpf = '74006372078')
SELECT c.codigo, c.dataAbertura, c.saldo, c.agenciaCodigo, cc.limiteCredito FROM ContaCorrente cc INNER JOIN Conta c ON cc.contaCodigo = c.codigo WHERE c.codigo IN (SELECT contaCodigo FROM ContaCliente WHERE clienteCpf = '74006372078')

DELETE FROM Cliente
DELETE FROM Conta
DELETE FROM ContaCorrente;
DELETE FROM ContaPoupanca;
DELETE FROM ContaCliente;

SELECT c.codigo, c.dataAbertura, c.saldo, c.agenciaCodigo, p.percentualRendimento, p.diaAniversario FROM ContaPoupanca p INNER JOIN Conta c ON p.contaCodigo = c.codigo WHERE c.codigo IN (SELECT contaCodigo FROM ContaCliente WHERE clienteCpf = '')
DECLARE @saida VARCHAR(100)
EXEC sp_inserir_cliente

