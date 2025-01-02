use Northwind
go

--procedimiento para insertar 5 empleados 
CREATE PROCEDURE INSERT_EMPLOYEES (
	@LastName VARCHAR(50),@FirstName VARCHAR(50),
	@Title VARCHAR(50),@Address VARCHAR(100),@City VARCHAR(50))
	with encryption
	AS
	INSERT INTO Employees(LastName,FirstName,Title,Address,City)
	VALUES
	(@LastName,@FirstName,@Title,@Address,@City)
	GO

	EXEC INSERT_EMPLOYEES
	'Quesada','Emanuel','Administrador','San Ramon','Alajuela'
	EXEC INSERT_EMPLOYEES
	'Campos','Juan','Tecnico','San Pedro','San Jose'
	EXEC INSERT_EMPLOYEES
	'Arias','Andres','Mecanico','Barva','Heredia'
	EXEC INSERT_EMPLOYEES
	'Araya','Pablo','Ingeniero Industrial','San Pablo','Heredia'
	EXEC INSERT_EMPLOYEES
	'Fernandez','Ana','Disenadora','Barranca','Puntarenas'
	go

	--procedimeinto para editar empleado donde sea heredia la city,cambiar title por DBA.
	CREATE PROCEDURE Actualizar_City
	(@City VARCHAR(50),@Filas INT OUTPUT)
	as
	Update Employees
	SET Title= 'DBA.'
	WHERE City= @City
	SET @Filas= @@ROWCOUNT
	GO

	--Ejecutar el SP que actualiza
	Declare @Datos INT
	EXEC Actualizar_City 'Heredia',@Datos OUTPUT
	SELECT @Datos as Borrados
	go

	--ELIMINA EMPLEADOS DONDE CITY SEA HEREDIA
	CREATE PROCEDURE Eliminacion_Empleado
	(@City VARCHAR(50),@Filas INT OUTPUT)
	as
	DELETE FROM Employees WHERE City= @City
	SET @Filas= @@ROWCOUNT

	GO

	--Ejecutar el SP que elimina empleados
	Declare @Datos INT
	EXEC Eliminacion_Empleado 'Heredia',@Datos OUTPUT
	SELECT @Datos as Borrados
	go

	--sp para consultar 4 tablas
	CREATE PROCEDURE Consultar_Tablas as
		select c.CustomerID,c.CompanyName,c.Country,
		o.OrderID,o.OrderDate,p.ProductName,p.UnitPrice, d.Quantity
	from Customers as c
	inner join Orders as o on c.CustomerID= o.CustomerID
	inner join [Order Details] as d on o.OrderID = d.OrderID
	inner join Products as p on d.ProductID = p.ProductID
	
	go

	EXEC Consultar_Tablas
	
	--funcion del 10% mayor a 1000 para order details,mostrar en select q llame la funcion
	--alias descuento para mostrar en pantalla
	CREATE FUNCTION DESCUENTO (@Monto money)
	RETURNS Money
	as
	BEGIN
		DECLARE @RESULTADO MONEY
		IF @Monto >	1000
		begin
		set @RESULTADO = @Monto*0.10
		END
		ELSE
			BEGIN
			SET @RESULTADO= 0
			END
			RETURN (@RESULTADO)
	END
--llamo la funcion descuento
	SELECT OrderID,ProductID,UnitPrice,Quantity,
	UnitPrice*Quantity AS Subtotal, dbo.DESCUENTO(UnitPrice * Quantity) as Descuento,
	((UnitPrice*Quantity)-(dbo.DESCUENTO(UnitPrice*Quantity))) as Total
	FROM [Order Details]

