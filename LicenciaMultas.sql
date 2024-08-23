/** SE CREA LA BASE DE DATOS**/
CREATE DATABASE LicenciasMultas
GO

/** SE SELECCIONA LA BASE DE DATOS CREADA**/
USE LicenciasMultas
GO

SET DATEFORMAT dmy
SET LANGUAGE spanish

/** INSTRUCCION QUE PERMITE CREAR LOS DIAGRAMAS**/
Alter authorization on database::LicenciasMultas to sa

CREATE TABLE Conductor (
idCedula VARCHAR(10) NOT NULL,
nombre VARCHAR(50)NULL,
fecha_Nacimiento DATETIME NULL,
correo VARCHAR(50) NULL,
direccion VARCHAR(100) NULL,
tipoSangre VARCHAR(5) NOT NULL,
donador VARCHAR(5) NULL,
observaciones VARCHAR(50) ,
CONSTRAINT PK_IdCed PRIMARY KEY (idCedula)
)
GO

CREATE TABLE Telefonos
(
idTelefono INT NOT NULL,
idCedula VARCHAR(10) NOT NULL,
tipoTelefono VARCHAR(50) NOT NULL,
numeroTelefonico VARCHAR(50) NULL,
CONSTRAINT PK_Telefono PRIMARY KEY (idTelefono),
CONSTRAINT FK_Conductor_Telefono FOREIGN KEY (idCedula) REFERENCES Conductor(idCedula)
)
GO

CREATE TABLE Tipo_Licencia
(
idTipoLicencia VARCHAR(15) NOT NULL,
detalle VARCHAR(130) ,
CONSTRAINT PK_Tipo_Licencia PRIMARY KEY (idTipoLicencia)
)
GO

CREATE TABLE Licencia
(
idLicencia INT NOT NULL,
nombre VARCHAR(50) NULL,
fechaEmision DATETIME NULL,
fechaVencimiento DATETIME NULL,
puntosTotales INT NOT NULL,
vigencia VARCHAR(10),
idCedula VARCHAR(10) NOT NULL,
idTipoLicencia VARCHAR(15) NOT NULL,

CONSTRAINT PK_Licencia PRIMARY KEY (idLicencia),
CONSTRAINT FK_Conductor_Licencia FOREIGN KEY (idCedula) REFERENCES Conductor(idCedula),
CONSTRAINT FK_TipoLicencia_Licencia FOREIGN KEY (idTipoLicencia) REFERENCES Tipo_Licencia(idTipoLicencia)

)
GO

ALTER TABLE Licencia ADD CONSTRAINT CHK_VIGENCIA CHECK (vigencia='VIGENTE' OR vigencia='NO VIGENTE')
GO

CREATE TABLE Traficos
(
idTrafico VARCHAR(15) NOT NULL,
nombre VARCHAR(50) NULL,
contrasena VARCHAR(15) NULL,
direccion VARCHAR(100),

CONSTRAINT PK_Traficos PRIMARY KEY (idTrafico)
)

GO

CREATE TABLE Lista_Infracciones
(
idInfraccion INT NOT NULL,
monto NUMERIC(10,2) NULL,
ptosInfraccion INT NOT NULL,
estadoInfraccion VARCHAR(25) NULL,
detalle VARCHAR(130),
fecha_Registro DATETIME NULL,

CONSTRAINT PK_Lista_Infracciones PRIMARY KEY (idInfraccion)
)
GO

CREATE TABLE Multa
(
idMulta INT NOT NULL,
fechaMulta DATETIME NULL,
tipoMulta VARCHAR(20) NOT NULL,
descripcionMulta VARCHAR(120) ,
montoMulta NUMERIC(10,2) NULL,
estadoMulta VARCHAR(25), 
ptsRebajaMulta INT NOT NULL,
idTrafico VARCHAR(15) NOT NULL,
idCedula VARCHAR(10) NOT NULL,
idInfraccion INT NOT NULL,
idLicencia INT NOT NULL,

CONSTRAINT PK_Multa PRIMARY KEY (idMulta),
CONSTRAINT FK_Traficos_Multa FOREIGN KEY (idTrafico) REFERENCES Traficos(idTrafico),
CONSTRAINT FK_Conductor_Multa FOREIGN KEY (idCedula) REFERENCES Conductor(idCedula),
CONSTRAINT FK_Lista_Infracciones_Multa FOREIGN KEY (idInfraccion) REFERENCES Lista_Infracciones(idInfraccion),
CONSTRAINT FK_Licencia_Multa FOREIGN KEY (idLicencia) REFERENCES Licencia(idLicencia)

)
GO

ALTER TABLE Multa ADD CONSTRAINT CHK_Monto_Multa_Positivo CHECK(montoMulta>=0) 

go

CREATE TABLE Cajeros
(
idCajero VARCHAR(15) NOT NULL,
contrasena VARCHAR(15) NULL,
nombreCompleto VARCHAR(50) NULL,

CONSTRAINT PK_Cajeros PRIMARY KEY (idCajero)
)

GO

CREATE TABLE Registro_Pagos
(
idPago INT NOT NULL,
banco VARCHAR (100) NULL,
num_Recibo VARCHAR(50) NULL,
fecha_Pago DATETIME NULL,
montoPago NUMERIC(10,2) NULL,
idMulta INT NOT NULL,
idCajero VARCHAR(15) NOT NULL,


CONSTRAINT PK_Registro_Pagos PRIMARY KEY (idPago),
CONSTRAINT FK_Multa_Registro_Pagos FOREIGN KEY (idMulta) REFERENCES Multa(idMulta),
CONSTRAINT FK_Cajero_Registro_Pagos FOREIGN KEY (idCajero) REFERENCES Cajeros(idCajero),
)

GO

INSERT INTO Conductor(idCedula, nombre, fecha_Nacimiento, correo, direccion,
tipoSangre,donador,observaciones) 
VALUES ('102340567', 'Emanuel Quesada Campos', '26/06/1992', 'Emanuel@gmail.com', 'Alajuela, San Ramon, Santiago',
'-A','Si','Ninguna')
INSERT INTO Conductor(idCedula, nombre, fecha_Nacimiento, correo, direccion,
tipoSangre,donador,observaciones) 
VALUES ('201230456', 'Andres Arias Cardenas', '21/11/1991', 'Andres@gmail.com','Heredia, Belen, Futuro',
'B','No','Ninguna')
INSERT INTO Conductor(idCedula, nombre, fecha_Nacimiento, correo, direccion,
tipoSangre,donador,observaciones) 
VALUES ('301230456', 'Juan Vargas Mendez', '4/10/1989', 'Juan@gmail.com', 'San Jose, Guadalupe',
'O','Si','Diabetes')
GO

INSERT INTO Telefonos(idTelefono,idCedula, tipoTelefono, numeroTelefonico) 
VALUES (1,'102340567', 'casa', '88218974')
INSERT INTO Telefonos(idTelefono,idCedula, tipoTelefono, numeroTelefonico) 
VALUES (2,'102340567', 'celular', '89311326')
INSERT INTO Telefonos(idTelefono,idCedula, tipoTelefono, numeroTelefonico) 
VALUES (3,'201230456', 'trabajo', '87712552')
INSERT INTO Telefonos(idTelefono,idCedula, tipoTelefono, numeroTelefonico) 
VALUES (4,'301230456', 'celular', '85156286')
INSERT INTO Telefonos(idTelefono,idCedula, tipoTelefono, numeroTelefonico) 
VALUES (5,'301230456', 'casa', '86328098')

GO

INSERT INTO Tipo_Licencia(idTipoLicencia, detalle) 
VALUES ('A1', 'motos hasta 125cc, cuadras hasta 250cc, electricas hasta 11kw')
INSERT INTO Tipo_Licencia(idTipoLicencia, detalle)
VALUES ('A2', 'motos y cuadras hasta 500cc, electricas hasta 35kw')
INSERT INTO Tipo_Licencia(idTipoLicencia, detalle) 
VALUES ('A3', 'cualquier cilindraje o potencia, NO UTV')
INSERT INTO Tipo_Licencia(idTipoLicencia, detalle) 
VALUES ('B1', 'automovil liviano menor a 4ton, ATV menor 500cc, y UTV de cualquier cilindraje')
INSERT INTO Tipo_Licencia(idTipoLicencia, detalle) 
VALUES ('B2', 'camiones menor a 8toneladas')
INSERT INTO Tipo_Licencia(idTipoLicencia, detalle) 
VALUES ('B3', 'camiones de cualquier peso que no sea articulado ni especial')
INSERT INTO Tipo_Licencia(idTipoLicencia, detalle) 
VALUES ('B4', 'cualquier camion excepto licencia D(especial)')
INSERT INTO Tipo_Licencia(idTipoLicencia, detalle) 
VALUES ('C1', 'transporte publico-taxi')
INSERT INTO Tipo_Licencia(idTipoLicencia, detalle) 
VALUES ('C2', 'transporte publico-bus y buseta')
INSERT INTO Tipo_Licencia(idTipoLicencia, detalle) 
VALUES ('D1', 'tractor de llantas')
INSERT INTO Tipo_Licencia(idTipoLicencia, detalle) 
VALUES ('D2', 'tractor de orugas')
INSERT INTO Tipo_Licencia(idTipoLicencia, detalle) 
VALUES ('D3', 'equipo especial que no sean tractores')
INSERT INTO Tipo_Licencia(idTipoLicencia, detalle) 
VALUES ('E1', 'todo vehiculo(A3 Y B4)exepto transporte publico y equipo especial')
INSERT INTO Tipo_Licencia(idTipoLicencia, detalle) 
VALUES ('E2', 'todo vehiculo(A3 B4 D1 D2 D3) exepto transporte publico')

GO

INSERT INTO Licencia(idLicencia,nombre,fechaEmision,fechaVencimiento,puntosTotales,vigencia,IdCedula,idTipoLicencia) 
VALUES (1,'automobil liviano menor a 4ton','30/07/2014','30/07/2017',20,'VIGENTE','102340567','B1')

INSERT INTO Licencia(idLicencia,nombre,fechaEmision,fechaVencimiento,puntosTotales,vigencia,IdCedula,idTipoLicencia)
VALUES (2,'camiones menor a 8toneladas','25/06/2013','25/06/2017',20,'VIGENTE','102340567','B2')

INSERT INTO Licencia(idLicencia,nombre,fechaEmision,fechaVencimiento,puntosTotales,vigencia,IdCedula,idTipoLicencia)
VALUES (3,'motos hasta 125cc','15/04/2015','15/04/2018',20,'VIGENTE','201230456','A1')

INSERT INTO Licencia(idLicencia,nombre,fechaEmision,fechaVencimiento,puntosTotales,vigencia,IdCedula,idTipoLicencia)
VALUES (4,'cualquier cilindraje o potencia, NO UTV','25/02/2011','25/02/2014',20,'VIGENTE','301230456','A3')

INSERT INTO Licencia(idLicencia,nombre,fechaEmision,fechaVencimiento,puntosTotales,vigencia,IdCedula,idTipoLicencia)
VALUES (5,'equipo especial que no sean tractores','12/09/2017', '12/09/2020',20,'VIGENTE','301230456','D3')

INSERT INTO Licencia(idLicencia,nombre,fechaEmision,fechaVencimiento,puntosTotales,vigencia,IdCedula,idTipoLicencia)
VALUES (6,'transporte publico-taxi','25/11/2018','25/11/2021',20,'VIGENTE','201230456','C1')

INSERT INTO Licencia(idLicencia,nombre,fechaEmision,fechaVencimiento,puntosTotales,vigencia,IdCedula,idTipoLicencia)
VALUES (7,'automobil liviano menor a 4ton','21/01/2017','21/01/2020',20,'NO VIGENTE','301230456','B1')

GO

INSERT INTO Traficos(idTrafico,nombre,contrasena,direccion) 
VALUES ('1','Pedro Carranza Zeledon', '1234','Santiago,San Ramon')

INSERT INTO Traficos(idTrafico,nombre,contrasena,direccion) 
VALUES ('2','Alberto Cortes Sanabria', '2475','Barranca,Puntarenas')

INSERT INTO Traficos(idTrafico,nombre,contrasena,direccion) 
VALUES ('3','Jose Rodriguez Montero', '4792','Heredia,San Roque')

GO

INSERT INTO Lista_Infracciones(idInfraccion,monto,ptosInfraccion,estadoInfraccion,detalle,fecha_Registro) 
VALUES (1,110729.29 , 1,'ACTIVA', 'Hablar por celular mientras maneja', '01/01/2021')

INSERT INTO Lista_Infracciones(idInfraccion,monto,ptosInfraccion,estadoInfraccion,detalle,fecha_Registro) 
VALUES (2,327713.96 , 4,'ACTIVA', 'Virar en U donde no es permitido', '01/01/2021')

INSERT INTO Lista_Infracciones(idInfraccion,monto,ptosInfraccion,estadoInfraccion,detalle,fecha_Registro) 
VALUES (3,23488.03 , 1,'ACTIVA', 'No respetar restriccion vehicular', '01/01/2021')

INSERT INTO Lista_Infracciones(idInfraccion,monto,ptosInfraccion,estadoInfraccion,detalle,fecha_Registro) 
VALUES (4,110729.29 , 2,'ACTIVA', 'Hablar por celular mientras maneja', '01/01/2021')

INSERT INTO Lista_Infracciones(idInfraccion,monto,ptosInfraccion,estadoInfraccion,detalle,fecha_Registro) 
VALUES (5,54805.41 , 3,'ACTIVA', 'Circular con 20km/h de exceso de limite de velocidad', '01/01/2021')

INSERT INTO Lista_Infracciones(idInfraccion,monto,ptosInfraccion,estadoInfraccion,detalle,fecha_Registro) 
VALUES (6,221458.59 , 5,'ACTIVA', 'Circular con 40km/h de exceso de limite de velocidad', '01/01/2021')

INSERT INTO Lista_Infracciones(idInfraccion,monto,ptosInfraccion,estadoInfraccion,detalle,fecha_Registro) 
VALUES (7,221458.59 , 6,'ACTIVA', 'Irrespetar una senal de alto o semaforo', '01/01/2021')

INSERT INTO Lista_Infracciones(idInfraccion,monto,ptosInfraccion,estadoInfraccion,detalle,fecha_Registro) 
VALUES (8,54805.41 , 3,'ACTIVA', 'Circular un vehiculo en la playa', '01/01/2021')

INSERT INTO Lista_Infracciones(idInfraccion,monto,ptosInfraccion,estadoInfraccion,detalle,fecha_Registro) 
VALUES (9,23488.03 , 2,'ACTIVA', 'Usar altoparlantes sin permiso', '01/01/2021')

GO

INSERT INTO Multa(idMulta,fechaMulta,tipoMulta,descripcionMulta,montoMulta,estadoMulta,ptsRebajaMulta,idTrafico,idCedula,
idInfraccion,idLicencia) 
VALUES (1,'01/03/2022','Leve','Usar altoparlantes sin permiso', 23488.03, 'Multa Activa',2,'1','102340567',9,1)

INSERT INTO Multa(idMulta,fechaMulta,tipoMulta,descripcionMulta,montoMulta,estadoMulta,ptsRebajaMulta,idTrafico,idCedula,
idInfraccion,idLicencia) 
VALUES (2,'14/07/2022','Grave','Virar en U donde no es permitido', 327713.96 , 'Multa Activa',4,'2','102340567',2,1)

INSERT INTO Multa(idMulta,fechaMulta,tipoMulta,descripcionMulta,montoMulta,estadoMulta,ptsRebajaMulta,idTrafico,idCedula,
idInfraccion,idLicencia) 
VALUES (3,'18/09/2022','Medio','Hablar por celular mientras maneja', 110729.29 ,'Multa Activa',2,'3','201230456',1,3)

INSERT INTO Multa(idMulta,fechaMulta,tipoMulta,descripcionMulta,montoMulta,estadoMulta,ptsRebajaMulta,idTrafico,idCedula,
idInfraccion,idLicencia) 
VALUES (4,'06/08/2022','Medio','Hablar por celular mientras maneja',110729.29,'Multa Activa',2,'2','301230456',1,4)

INSERT INTO Multa(idMulta,fechaMulta,tipoMulta,descripcionMulta,montoMulta,estadoMulta,ptsRebajaMulta,idTrafico,idCedula,
idInfraccion,idLicencia) 
VALUES (5,'02/03/2018','Medio','Hablar por celular mientras maneja',110729.29,'Multa Activa',2,'2','301230456',1,4)
GO

INSERT INTO Cajeros(idCajero,contrasena,nombreCompleto) 
VALUES ('Luis23','1234', 'Luis Arguedas Salas')

INSERT INTO Cajeros(idCajero,contrasena,nombreCompleto) 
VALUES ('Jose47','3186', 'Jose Varquero Quiros')

INSERT INTO Cajeros(idCajero,contrasena,nombreCompleto) 
VALUES ('PabloF','2708', 'Pablo Fernandez Campos')

GO

INSERT INTO Registro_Pagos(idPago,banco,num_Recibo,fecha_Pago,montoPago,idMulta,idCajero) 
VALUES (1,'Banco Nacional','JHVBJH3453','04/03/2022', 327713.96 ,2,'Luis23')

INSERT INTO Registro_Pagos(idPago,banco,num_Recibo,fecha_Pago,montoPago,idMulta,idCajero) 
VALUES (2,'BCR','JH3453','14/07/2022',23488.03,1,'PabloF')

INSERT INTO Registro_Pagos(idPago,banco,num_Recibo,fecha_Pago,montoPago,idMulta,idCajero) 
VALUES (3,'Banco Popular','LKNL3452','26/11/2022',110729.29,3,'Jose47')

GO

--aqui comienzan los ejercicios
--SUMAR MULTAS POR FECHAS DE UN MISMO CONDUCTOR

CREATE FUNCTION fn_Suma_Multas (@idCedula VARCHAR(10), @fechaIn datetime,@fechaF datetime)
RETURNS numeric (10,2)
AS BEGIN
	DECLARE @SumaMultas numeric(10,2)

SELECT @SumaMultas = SUM(montoMulta) 
		FROM [dbo].[Multa]
		WHERE [idCedula]= @idCedula and fechaMulta >= @fechaIn AND fechaMulta<= @fechaF

RETURN @SumaMultas
END

GO

SELECT [dbo].[fn_Suma_Multas]('301230456','01/01/2018','31/12/2022') AS SUMA_MULTAS
GO

--MOSTRAR MULTAS POR FECHAS DE UN MISMO TRAFICO

CREATE FUNCTION fn_Multas_Trafico_Fechas ( @idTrafico VARCHAR(15),@fechaIn datetime, @fechaF datetime)
RETURNS TABLE
AS
	RETURN(

Select idMulta,idTrafico,idLicencia,fechaMulta,tipoMulta,descripcionMulta,montoMulta,estadoMulta,idInfraccion
 From [dbo].[Multa]
Where [idTrafico]= @idTrafico and fechaMulta >= @fechaIn AND fechaMulta<= @fechaF 

)

GO

select*from [dbo].[fn_Multas_Trafico_Fechas]('2','02/03/2018','06/08/2019')
go

--VISTA VIGENTES

CREATE view Licencias_Vigentes with Encryption
as 
SELECT idLicencia,nombre,fechaEmision,fechaVencimiento,puntosTotales,vigencia,idCedula,idTipoLicencia
From Licencia
where vigencia = 'VIGENTE'

go

select * from Licencias_Vigentes

GO

--PARA REGISTRAR UNA MULTA

CREATE PROCEDURE PA_RegistrarMulta @idMulta int, @fechaMulta datetime, @tipoMulta varchar(20),
@descripcionMulta varchar(120),@montoMulta numeric(10,2),@estadoMulta varchar(25),@ptsRebajaMulta int,
@idTrafico varchar(15),@idCedula varchar(10),@idInfraccion int,@idLicencia int

AS BEGIN
BEGIN TRANSACTION
BEGIN TRY

IF EXISTS (SELECT*FROM Conductor WHERE idCedula=@idCedula) BEGIN
IF EXISTS (SELECT*FROM Lista_Infracciones WHERE idInfraccion=@idInfraccion) BEGIN

--ESTOS SON LOS Q QUEDAN GUARDADOS EN MULTA XQ NO VIOLAN NINGUNA REGLA
Insert Into Multa(idMulta,fechaMulta,tipoMulta,descripcionMulta,montoMulta,estadoMulta,ptsRebajaMulta,
idTrafico,idCedula,idInfraccion,idLicencia)
values (@idMulta,GETDATE(),@tipoMulta,@descripcionMulta,@montoMulta,@estadoMulta,@ptsRebajaMulta,
@idTrafico,@idCedula,@idInfraccion,@idLicencia)
PRINT N'Multa Realizada'
END

ELSE BEGIN
PRINT N'LA MULTA INSERTADA NO EXISTE'
END
END

ELSE BEGIN
PRINT N'EL CONDUCTOR INSERTADO NO EXISTE'
END

COMMIT TRANSACTION--DESPUES DE LA ULTIMA LINEA EXITOSA--confirmamos la transaccion

END TRY

BEGIN CATCH
	--ocurrio un error, deshacemos los cambios
	ROLLBACK TRANSACTION
	SELECT  ERROR_MESSAGE() AS Advertencia
		
END CATCH

END

GO

EXEC PA_RegistrarMulta 14,'26/06/2022','Leve','Usar altoparlantes sin permiso', 23488.03,
'multa activa',2,'3','102340567',9,2
GO

--TRIGGER PARA ACTUALIZAR PTOS LICENCIA
CREATE TRIGGER TR_PTOSLICENCIAMULTA ON [dbo].[Multa] AFTER INSERT
AS BEGIN

SET NOCOUNT ON;

BEGIN TRY

DECLARE @ptsRebajar int;
DECLARE @PuntosLicencia int;
DECLARE @idLicencia int;

SET @ptsRebajar= (SELECT ptsRebajaMulta FROM inserted);
SET @idLicencia= (SELECT idLicencia FROM inserted);
SET @PuntosLicencia= (SELECT puntosTotales FROM Licencia WHERE idLicencia=@idLicencia)

BEGIN
	UPDATE Licencia SET puntosTotales= puntosTotales - @ptsRebajar
	WHERE idLicencia= @idLicencia
END

END TRY

BEGIN CATCH
	--ocurrio un error, deshacemos los cambios
	ROLLBACK TRANSACTION
	SELECT  ERROR_MESSAGE() AS Advertencia
		
END CATCH

END

GO
------------------------------------------------------------------------------------------------
--EJERCICIO ADICIONAL PARA REGISTRAR UN PAGO 

CREATE PROCEDURE PA_RegistrarPago @idPago int,@banco varchar(100),@numRecibo varchar(50),@fechaPago datetime,
@montoPago numeric(10,2),@idMulta int,@idCajero varchar(15)

AS BEGIN
BEGIN TRANSACTION
BEGIN TRY

IF EXISTS (SELECT*FROM Multa WHERE idMulta=@idMulta) BEGIN
IF EXISTS (SELECT*FROM Cajeros WHERE idCajero=@idCajero) BEGIN

--ESTOS SON LOS Q QUEDAN GUARDADOS EN REGISTROPAGO XQ NO VIOLAN NINGUNA REGLA
Insert Into Registro_Pagos(idPago,banco,num_Recibo,fecha_Pago,montoPago,idMulta,idCajero)
values (@idPago,@banco,@numRecibo,GETDATE(),@montoPago,@idMulta,@idCajero)
PRINT N'Pago Realizado'

END

ELSE BEGIN
PRINT N'EL CAJERO NO EXISTE'
END
END

ELSE BEGIN
PRINT N'LA MULTA NO EXISTE'
END

COMMIT TRANSACTION--DESPUES DE LA ULTIMA LINEA EXITOSA--confirmamos la transaccion

END TRY

BEGIN CATCH
	--ocurrio un error, deshacemos los cambios
	ROLLBACK TRANSACTION
	SELECT  ERROR_MESSAGE() AS Advertencia
		
END CATCH

END

GO


EXEC PA_RegistrarPago 4,'Banco Mutual','jhbj','26/04/2020',23488.03,1,'Luis23'
GO


--EJERCICIO ADICIONAL ESTADO MULTA
CREATE TRIGGER TR_ESTADO_MULTA ON [dbo].[Registro_Pagos] AFTER INSERT
AS BEGIN

SET NOCOUNT ON;

BEGIN TRY

DECLARE @montoPago numeric(10,2);
DECLARE @montoMulta numeric(10,2);
DECLARE @estadoMulta varchar(25);
DECLARE @idMulta int;


SET @montoPago= (SELECT montoPago FROM inserted);
SET @montoMulta=(SELECT montoMulta FROM Multa);
SET @idMulta= (SELECT idMulta FROM inserted);
SET @estadoMulta= (SELECT estadoMulta FROM Multa WHERE idMulta=@idMulta)

BEGIN
	If @montoPago= @montoMulta BEGIN
	UPDATE Multa SET estadoMulta='PAGADA'
	WHERE idMulta= @idMulta
END
END

END TRY

BEGIN CATCH
	--ocurrio un error, deshacemos los cambios
	ROLLBACK TRANSACTION
	SELECT  ERROR_MESSAGE() AS Advertencia
		
END CATCH

END

GO

