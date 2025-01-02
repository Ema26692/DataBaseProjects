use DisneyPlus
go

create table Suscriptores(
idSuscriptor int not null primary key,
nombreSuscriptor varchar(100),
correoSuscriptor varchar(100),
planMensual varchar(50),
costoMensual money,
passwordSuscrip varchar(100),
numTarjeta varchar(100)

)
go


 alter table Suscriptores
  add 
 correoSuscrip nvarchar(100) ,
 passwordSuscrip nvarchar(50) ,
 numTarjeta nvarchar(100) 
 go

 alter table Suscriptores
 drop column correoSuscrip
 go

 --encripto correo y tarjeta
  alter table dbo.Suscriptores alter COLUMN correoSuscriptor
--nxxx@xxx.com
add MASKED WITH (FUNCTION = 'PARTIAL(1,"****@correo.",3)');


alter table dbo.Suscriptores alter COLUMN numTarjeta
add MASKED WITH (FUNCTION = 'PARTIAL(4,"-****-****-***",1)');



select * from Suscriptores

 --crear vista
 create view View_Suscriptores

as

select s.idSuscriptor,s.nombreSuscriptor,s.correoSuscriptor,s.planMensual,
s.costoMensual,s.passwordSuscrip,s.numTarjeta
from Suscriptores as s

go

--pruebo la vista
select * from View_Suscriptores

--borrado y llenado de tabla suscriptores nuevamente para tener el password y numTarjeta
--asigno el idioma para q no haiga errores al ingresar datos 
delete from Suscriptores
go
SET DATEFORMAT ymd
go
SET LANGUAGE us_english
go


insert into Suscriptores (idSuscriptor, nombreSuscriptor, correoSuscriptor, planMensual, costoMensual, passwordSuscrip, numTarjeta) values (1, 'Franciska Blamires', 'fblamires0@imdb.com', 'standar', '$15', 'gK5{&w{7q', '3587-4910-8112-1234');
insert into Suscriptores (idSuscriptor, nombreSuscriptor, correoSuscriptor, planMensual, costoMensual, passwordSuscrip, numTarjeta) values (2, 'Carine Houlson', 'choulson1@upenn.edu', 'premium', '$25', 'rP2_EdG%">h(OTX', '5108-7516-9220-5678');
insert into Suscriptores (idSuscriptor, nombreSuscriptor, correoSuscriptor, planMensual, costoMensual, passwordSuscrip, numTarjeta) values (3, 'Vivien Bestman', 'vbestman2@com.com', 'premium', '$25', 'kD0{HVh1)9/2c', '4041-5917-2284-9876');
insert into Suscriptores (idSuscriptor, nombreSuscriptor, correoSuscriptor, planMensual, costoMensual, passwordSuscrip, numTarjeta) values (4, 'Emile Dugmore', 'edugmore3@163.com', 'standar', '$15', 'pG7`MRU$UvrN}', '4844-2952-0564-1352');
insert into Suscriptores (idSuscriptor, nombreSuscriptor, correoSuscriptor, planMensual, costoMensual, passwordSuscrip, numTarjeta) values (5, 'Kennett Duffy', 'kduffy4@bbb.org', 'standar', '$15', 'hG1=&vpc.ca', '5048-3780-4706-4268');
insert into Suscriptores (idSuscriptor, nombreSuscriptor, correoSuscriptor, planMensual, costoMensual, passwordSuscrip, numTarjeta) values (6, 'Alasteir Pointer', 'apointer5@hud.gov', 'premium', '$25', 'xA1~i_Wk~4g1', '2015-2136-2993-9583');
insert into Suscriptores (idSuscriptor, nombreSuscriptor, correoSuscriptor, planMensual, costoMensual, passwordSuscrip, numTarjeta) values (7, 'Tiertza Tobias', 'ttobias6@fema.gov', 'premium', '$25', 'eN4`(CUt', '3551-7565-2055-2483');
insert into Suscriptores (idSuscriptor, nombreSuscriptor, correoSuscriptor, planMensual, costoMensual, passwordSuscrip, numTarjeta) values (8, 'Almeta Patria', 'apatria7@meetup.com', 'premium', '$25', 'hE8<nlas&lyy|>B1', '3570-7589-3847-0976');
insert into Suscriptores (idSuscriptor, nombreSuscriptor, correoSuscriptor, planMensual, costoMensual, passwordSuscrip, numTarjeta) values (9, 'Daron Jeckells', 'djeckells8@accuweather.com', 'standar', '$15', 'eA8(v{QMf=?f', '5100-1499-1431-3154');
insert into Suscriptores (idSuscriptor, nombreSuscriptor, correoSuscriptor, planMensual, costoMensual, passwordSuscrip, numTarjeta) values (10, 'Donnajean Crosson', 'dcrosson9@studiopress.com', 'standar', '$15', 'nL2\9%?qjD.h)', '6381-0775-9583-4276');
--crear tabla facturas

create table Facturas(

idFactura int primary key identity(1,1) not null,
idSuscriptor int,
fechaFactura date,
CONSTRAINT [FK_idSuscriptor] FOREIGN KEY (idSuscriptor) REFERENCES Suscriptores(idSuscriptor)
)
go


--agregar 3 campos mas a la tabla facturas
alter table Facturas
add
Iva numeric(10,2),
Pani numeric(10,2),
total numeric(10,2)
go

--funcion calcula impuesto iva
ALTER FUNCTION Iva_Facturas(@Monto numeric(10,2))
	RETURNS MONEY
	AS 
	BEGIN
		DECLARE @Iva numeric(10,2)
		SET @Iva = @Monto * 0.13
		RETURN (@Iva)
	END
	GO

--funcion calcula impuesto Pani
alter FUNCTION Pani_Facturas(@Monto numeric(10,2))
	RETURNS MONEY
	AS 
	BEGIN
		DECLARE @Pani numeric(10,2)
		SET @Pani = @Monto * 0.01
		RETURN (@Pani)
	END
	GO


	--uso la funcion para calcular el monto
	SELECT f.idFactura, s.idSuscriptor, getdate() as Fecha,dbo.Iva_Facturas(costoMensual) as  IVA,
	dbo.Pani_Facturas(costoMensual) as  Pani,
	(costoMensual+dbo.Iva_Facturas(costoMensual)+dbo.Pani_Facturas(costoMensual)) as total
	from Facturas as f
	inner join Suscriptores as s on f.idSuscriptor=s.idSuscriptor
	go	

	--trigger
	alter trigger Tr_SuscripNuevo
on [Suscriptores] instead of insert
as
Begin
declare @idSuscriptor int
select @idSuscriptor=idSuscriptor from inserted

declare @fechaFact date,@iva numeric(10,2),@pani numeric(10,2),@total numeric(10,2)
select @fechaFact= GETDATE(),
@iva=dbo.Iva_Facturas(costoMensual),
@pani=dbo.Pani_Facturas(costoMensual),
@total= ((costoMensual)+@iva+@pani)
from Facturas as f
	inner join Suscriptores as s on f.idSuscriptor=s.idSuscriptor


insert into Suscriptores(idSuscriptor,nombreSuscriptor,correoSuscriptor,planMensual,costoMensual,
passwordSuscrip,numTarjeta)
select	idSuscriptor,nombreSuscriptor,correoSuscriptor,planMensual,costoMensual,
passwordSuscrip,numTarjeta
from inserted;

	insert into Facturas(idSuscriptor,fechaFactura,Iva,Pani,total)
values (@idSuscriptor,GETDATE(),@iva,@pani,@total)


	
End
go

--SP Insertar nuevo suscriptor
ALTER PROCEDURE INSERT_SUSCRIPTOR (
	@idSuscriptor int,@nombre varchar(150),@correo varchar(150),@planMensual varchar(100),
	@costoMensual numeric(10,2),@password varchar(100),@numtarj varchar(100))
	with encryption
	AS
	INSERT INTO Suscriptores(idSuscriptor,nombreSuscriptor,correoSuscriptor,planMensual,costoMensual,
	passwordSuscrip,numTarjeta)
	VALUES
	(@idSuscriptor,@nombre,@correo,@planMensual,@costoMensual,@password,@numtarj)


	GO

	--hago el insert q dispara el trigger
	EXEC INSERT_SUSCRIPTOR
	'22','Alberth castro','albert@hotmail.com','standar','15','1234albert','1111-2222-3333-4444'

	--creo tabla visualizaciones
	create table Visualizaciones(

idVisualizacion int primary key not null,
idSuscriptorVisualizacion int,
cantidadVisualizaciones int,
CONSTRAINT [FK_idSuscriptorVisual] FOREIGN KEY (idSuscriptorVisualizacion) REFERENCES Suscriptores(idSuscriptor)
)
go

--hago e insert de visualizaciones
insert into Visualizaciones(idVisualizacion,idSuscriptorVisualizacion,cantidadVisualizaciones) values (12,22,3);
insert into Visualizaciones(idVisualizacion,idSuscriptorVisualizacion,cantidadVisualizaciones) values (2,23,3);
insert into Visualizaciones(idVisualizacion,idSuscriptorVisualizacion,cantidadVisualizaciones) values (3,24,3);
insert into Visualizaciones(idVisualizacion,idSuscriptorVisualizacion,cantidadVisualizaciones) values (4,25,3);
insert into Visualizaciones(idVisualizacion,idSuscriptorVisualizacion,cantidadVisualizaciones) values (5,26,3);
insert into Visualizaciones(idVisualizacion,idSuscriptorVisualizacion,cantidadVisualizaciones) values (6,22,3);
insert into Visualizaciones(idVisualizacion,idSuscriptorVisualizacion,cantidadVisualizaciones) values (7,24,3);
insert into Visualizaciones(idVisualizacion,idSuscriptorVisualizacion,cantidadVisualizaciones) values (8,21,3);
insert into Visualizaciones(idVisualizacion,idSuscriptorVisualizacion,cantidadVisualizaciones) values (9,25,3);
insert into Visualizaciones(idVisualizacion,idSuscriptorVisualizacion,cantidadVisualizaciones) values (10,22,3);
insert into Visualizaciones(idVisualizacion,idSuscriptorVisualizacion,cantidadVisualizaciones) values (11,23,3);

go


--creo tabla descuentos
create table Descuentos(

idDescuento int primary key not null,
idSuscriptorDescuento int,
cantidadVisualizacionesDesc int,
montoGeneral numeric(10,2),
montoConDescuento numeric(10,2),
CONSTRAINT [FK_idSuscriptorDescuento] FOREIGN KEY (idSuscriptorDescuento) REFERENCES Suscriptores(idSuscriptor),
CONSTRAINT [FK_cantiVisualizDesc] FOREIGN KEY (cantidadVisualizacionesDesc) REFERENCES Visualizaciones(idVisualizacion)
)
go

alter PROCEDURE Consultar_Desc(@idSuscriptor INT)
as

		select idVisualizacion,idSuscriptorVisualizacion,cantidadVisualizaciones
		from Visualizaciones where idSuscriptorVisualizacion=@idSuscriptor
	
	DECLARE @RESULTADO decimal(10,2),@cantidadVis int,@descuento numeric(10,2),
	@costoMensual numeric(10,2),@sumaCantiVisualizSuscrip int
	set @costoMensual= (select costoMensual from Suscriptores where idSuscriptor=@idSuscriptor)
	set @cantidadVis= (select cantidadVisualizaciones from Visualizaciones where idSuscriptorVisualizacion= @idSuscriptor)
	set @sumaCantiVisualizSuscrip=(sum(@cantidadVis))
		IF @cantidadVis < 5
		begin
		set @descuento = 0
		set @RESULTADO= @costoMensual
		END
		ELSE
		if @cantidadVis=6
			BEGIN
			SET @descuento=(@costoMensual*0.01)
			set @RESULTADO=(@costoMensual-@descuento)
			END

			else
			if @cantidadVis=9
			begin
			set @descuento=(@costoMensual*0.02)
			set @RESULTADO=(@costoMensual-@descuento)
			end
			else
			if @cantidadVis=12
			begin
			set @descuento=(@costoMensual*0.03)
			set @RESULTADO=(@costoMensual-@descuento)
			end
			else
			if @cantidadVis=15
			begin
			set @descuento=(@costoMensual*0.05)
			set @RESULTADO=(@costoMensual-@descuento)
			end
			
			--RETURN (@RESULTADO)
	go

	EXEC Consultar_Desc 23