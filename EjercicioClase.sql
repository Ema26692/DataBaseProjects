use Northwind
go

ALTER PROCEDURE NUMEROS
AS
DECLARE @Valor int= 0;
WHILE (@Valor <=10)
BEGIN
	IF(@Valor % 2=0)
		BEGIN
			PRINT CAST(@Valor as Varchar(10))+ ' El numero es par'
		END
		ELSE
		BEGIN
			PRINT CAST(@Valor As Varchar(10))+ ' El numero es impar'
		END
		SET @Valor = @Valor+1
	END
	
	EXEC NUMEROS

	--PARA VER CUALES TENGO ALMACENADOS EN MI BASE DE DATOS
	SELECT * FROM SYS.procedures
	--Consultar el script que origina el SP
	SP_HELPTEXT NUMEROS
	GO

	--CREAR SP CON INSERT,VAMOS A TRABAJAR CON PARAMETROS PARA Q EL SP HAGA EL INSERT
	ALTER PROCEDURE INSERT_SUPLIER(
	@CompanyName VARCHAR(50),@ContactName VARCHAR(50),
	@ContactTitle VARCHAR(50),@Country VARCHAR(50))
	AS
	INSERT INTO Suppliers(CompanyName,ContactName,ContactTitle,Country)
	VALUES
	(@CompanyName,@ContactName,@ContactTitle,@Country)
	GO

	EXEC INSERT_SUPLIER 
	'ICE','Ana Porras','Conta','Costa Rica','S'

	ALTER PROCEDURE INSERT_SUPLIER (
	@CompanyName VARCHAR(50),@ContactName VARCHAR(50),
	@ContactTitle VARCHAR(50),@Country VARCHAR(50),@Address VARCHAR(100))
	with encryption
	AS
	INSERT INTO Suppliers(CompanyName,ContactName,ContactTitle,Country,Address)
	VALUES
	(@CompanyName,@ContactName,@ContactTitle,@Country,@Address)
	GO

	EXEC INSERT_SUPLIER 
	'ICE','Ana Porras','Conta','Costa Rica','San Jose'

	SP_HELPTEXT INSERT_SUPLIER  
	GO

	SELECT *FROM Suppliers where Country= 'Costa Rica'

	--Procedimiento con parametros de salida
	CREATE PROCEDURE Eliminacion_Pais
	(@Pais VARCHAR(50),@Filas INT OUTPUT)
	as
	DELETE FROM Suppliers WHERE Country= @Pais
	SET @Filas= @@ROWCOUNT

	GO

	--Ejecutar el SP que elimina
	Declare @Datos INT
	EXEC Eliminacion_Pais 'Costa Rica',@Datos OUTPUT
	SELECT @Datos as Borrados
	go


	EXEC INSERT_SUPLIER 
	'Liberty','Maria tencio','Conta','Costa Rica','Heredia'

	--creacion de funciones
	CREATE FUNCTION IVa (@Monto money)
	RETURNS MONEY
	AS 
	BEGIN
		DECLARE @IMPUESTO Money
		SET @IMPUESTO = @Monto * 0.13
		RETURN (@IMPUESTO)
	END
	GO

	SELECT ProductName, UnitPrice, dbo.IVa(UnitPrice) as  IVA from Products

	--OTRA FUNCION
	CREATE FUNCTION COMISION (@Monto money)
	RETURNS Money
	as
	BEGIN
		DECLARE @RESULTADO MONEY
		IF @Monto >=1000
		begin
		set @RESULTADO = @Monto*0.10
		END
		ELSE
			BEGIN
			SET @RESULTADO= 0
			END
			RETURN (@RESULTADO)
	END

	--USAR LA FUNCION COMISION 
	SELECT OrderID,ProductID,UnitPrice,Quantity,
	UnitPrice*Quantity AS Total, dbo.COMISION(UnitPrice * Quantity) as Comision
	FROM [Order Details]