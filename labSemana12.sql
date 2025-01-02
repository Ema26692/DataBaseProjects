use  master
go

create database Spotify
go

use Spotify
go

SET DATEFORMAT ymd
go
SET LANGUAGE us_english
go
SELECT @@LANGUAGE AS 'Language Name';

create table Login_Usuario
(
	IdUsuario int identity(1000,5) not null primary key,
	nombre_Usuario nvarchar(50) not null,
	password_Usuario nvarchar(50) not null
);


create table usuarios
(
	IdUsuario int identity(1000,5) not null primary key,
	nombre_Usuario varchar(50) not null,
	correo varchar(100) not null,
	fecha_Nacimiento datetime,
	tarjeta_Credito varchar(100),
	fecha_Registro datetime,
	fecha_SuscripcionP datetime
);

--insercion de usuario
insert into usuarios
values
('equesada','emaqueca.26@hotmail.com','1992-06-26 19:44:51:090','9135-4444-8798',
'2024-03-15 19:44:51:090','2024-04-02 19:44:51:090');

select *from usuarios


--crear funcion
create function dbo.ChechPasswordSegura(@password nvarchar(50))
returns bit
as
begin
	declare @HasUppercase BIT,
		 @HasLowercase BIT,
		@HasNumber BIT,
		@HasSymbol BIT,
		 @Result BIT;

set @HasUppercase= case when @password
collate Latin1_General_BIN Like N'%[ABCDEFGHIJKLMNÑOPQRSTUVWXYZ]%' then 1 else 0 end;

set @HasLowercase= case when @password
collate Latin1_General_BIN Like N'%[abcdefghijklmnñopqrstuvwxyz]%' then 1 else 0 end;

set @HasNumber= case when @password
collate Latin1_General_BIN Like N'%[0123456789]%' then 1 else 0 end;

set @HasSymbol= case when @password
collate Latin1_General_BIN Like N'%[!@#$%^&*]%' then 1 else 0 end;

if LEN (@password) >= 12 and
@HasUppercase= 1 and
@HasLowercase= 1 and
@HasNumber=1 and
@HasSymbol= 1
set @Result= 1

else
set @Result=0;
return @RESULT;

end;

go

--agregar funcion a la tabla
alter table Login_Usuario
	with NOCHECK
	add constraint chk_PasswordComplexity
	check (dbo.ChechPasswordSegura(password_Usuario)=1);
go

--insertar usuario con datos invalidos
insert into Login_Usuario
values
('equescam','246#');

--insertar usuario con datos validos
insert into Login_Usuario
values
('equescam','Equesada26692!');

select * from Login_Usuario



--enmascarar campos

alter table dbo.usuarios alter COLUMN correo
--nxxx@xxx.com
add MASKED WITH (FUNCTION = 'PARTIAL(4,"***@mail.",3)');

alter table dbo.usuarios alter COLUMN tarjeta_Credito
add MASKED WITH (FUNCTION = 'PARTIAL(4,"-****-****-",4)');


--consulta de tabla
select * from usuarios

--crear un usuario que consulte la tabla
create user UserTest without login;

--otorgar permisos de lectura a la tabla, para q haga un select
grant select on dbo.usuarios to UserTest;
go

--ejecucion de una consulta en el nombre del usuario recien creado
	execute ('select * from usuarios') as user = 'UserTest';
	go

