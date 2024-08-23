/*Creaci�n de la Base de Datoss*/
CREATE DATABASE Laboratorio_4
GO

/** SE SELECCIONA LA BASE DE DATOS CREADA**/
USE Laboratorio_4
GO

/** INSTRUCCION QUE PERMITE CREAR LOS DIAGRAMAS**/
Alter authorization on database::Laboratorio_4 to sa
go

/*Establece el formato de la fecha en dia/mes/a�o,
cualquiera de las dos*/
SET DATEFORMAT dmy
SET LANGUAGE spanish
go

CREATE TABLE CLIENTES (
CODIGO_CLIENTE NUMERIC(5) NOT NULL,
NOMBRE_CLIENTE VARCHAR(50) NULL,
DIRECCION_CLIENTE VARCHAR(250) NULL,
CONSTRAINT PK_CLIENTES PRIMARY KEY(CODIGO_CLIENTE),

)
GO

CREATE TABLE ARTICULOS (
CODIGO_ARTICULO NUMERIC(5) NOT NULL,
DESCRIPCION_ARTICULO VARCHAR(30) NULL,
PRECIO_VENTA NUMERIC(8,2) NULL,
EXISTENCIAS NUMERIC(5) NULL,
CONSTRAINT PK_ARTICULOS PRIMARY KEY(CODIGO_ARTICULO),

/* 
constraint que valida que existencias no sea menor que cero
*/
CONSTRAINT CHK_EXISTENCIAS_MAYOR_CERO CHECK (EXISTENCIAS > 0)
)
GO

CREATE TABLE PEDIDOS(
NUMERO_PEDIDO NUMERIC(10) NOT NULL,
CODIGO_CLIENTE NUMERIC(5) NULL,
CODIGO_ARTICULO NUMERIC(5) NULL,
UNIDADES NUMERIC(5) NULL,
FECHA DATETIME NULL,
CONSTRAINT PK_PEDIDOS PRIMARY KEY(NUMERO_PEDIDO),
CONSTRAINT FK_CLIENTES_PEDIDOS FOREIGN KEY(CODIGO_CLIENTE) REFERENCES CLIENTES(CODIGO_CLIENTE),
CONSTRAINT FK_ARTICULOS_PEDIDOS FOREIGN KEY(CODIGO_ARTICULO) REFERENCES ARTICULOS(CODIGO_ARTICULO)
)
GO

INSERT INTO CLIENTES (CODIGO_CLIENTE,NOMBRE_CLIENTE,
DIRECCION_CLIENTE) VALUES
(1,'Jose morales chacon','Heredia')

GO

INSERT INTO CLIENTES (CODIGO_CLIENTE,NOMBRE_CLIENTE,
DIRECCION_CLIENTE) VALUES
(2,'Emanuel Quesada Campos','San Ramon')

GO

INSERT INTO ARTICULOS(CODIGO_ARTICULO,DESCRIPCION_ARTICULO,
PRECIO_VENTA,EXISTENCIAS) VALUES
(123,'Taladro',80000.00,20)
GO

INSERT INTO ARTICULOS(CODIGO_ARTICULO,DESCRIPCION_ARTICULO,
PRECIO_VENTA,EXISTENCIAS) VALUES
(456,'Sierra',95000.00,30)
GO

--------------------------------------------------------------
ALTER PROCEDURE PA_INSERTAR_PEDIDOS @Cod_Cliente numeric(5),
@Cod_Articulo numeric(5),@Unidades numeric(5),@fecha datetime

AS BEGIN
BEGIN TRANSACTION
BEGIN TRY

	DECLARE @Codigo_Cliente numeric(5)
	DECLARE @Codigo_Articulo numeric(5)

	
	SELECT @Codigo_Cliente= CODIGO_CLIENTE from CLIENTES where CODIGO_CLIENTE= @Codigo_Cliente
	SELECT @Codigo_Articulo = CODIGO_ARTICULO from ARTICULOS where CODIGO_ARTICULO= @Codigo_Articulo
	   	 	
	--SE VALIDA QUE EL CLIENTE EXISTA PARA PODER REALIZAR EL INSERT 
	If EXISTS(SELECT*FROM CLIENTES WHERE CODIGO_CLIENTE=@Codigo_Cliente) 

	--SE VALIDA QUE EL ARTICULO EXISTA PARA PODER REALIZAR EL INSERT 
	If EXISTS(SELECT*FROM ARTICULOS WHERE CODIGO_ARTICULO=@Codigo_Articulo)

	Insert into PEDIDOS(CODIGO_CLIENTE,CODIGO_ARTICULO,UNIDADES,FECHA) 
	values (@Codigo_Cliente,@Codigo_Articulo,@Unidades,GETDATE())

	PRINT N'PEDIDO INSERTADO'

	COMMIT TRANSACTION -- DESPUES DE LA ULTIMA LINEA EXITOSA-- CONFIRMAMOS LA TRANSACCION

	END TRY
	
	BEGIN CATCH

		ROLLBACK TRANSACTION
		SELECT ERROR_MESSAGE() As ADVERTENCIA

	END CATCH

	END

	GO

	EXEC PA_INSERTAR_PEDIDOS 2,123,10,'20/6/2015'
	go
	
	

	 SELECT*FROM 
	 PEDIDOS
	  GO

-------------------------------------------------------------------

CREATE TRIGGER TR_INVENTARIO
ON [dbo].[PEDIDOS] AFTER INSERT,UPDATE
AS
DECLARE @UNID numeric(5)
DECLARE @INVENT numeric(5)
DECLARE @ART numeric(5)

SET @UNID = (SELECT UNIDADES FROM inserted);
SET @ART= (SELECT CODIGO_ARTICULO FROM inserted);
SET @INVENT= (SELECT EXISTENCIAS FROM ARTICULOS WHERE CODIGO_ARTICULO=@ART)

IF @UNID <= @INVENT
BEGIN
	UPDATE ARTICULOS SET EXISTENCIAS= -EXISTENCIAS - @UNID
	WHERE CODIGO_ARTICULO= @ART
END
ELSE

BEGIN
	RAISERROR('LA CANTIDAD EXCEDE A LAS UNIDADES EN EXISTENCIA',18,10)
END
