use master
go

SET DATEFORMAT ymd
go
SET LANGUAGE us_english
go
SELECT @@LANGUAGE AS 'Language Name';

create database LabFinal


--creacion de grupos logicos
--aqui indica los archivos de las bases de datos, donde se va almacnar archivos de bases de datos
--para un entorno empresarial, las rutas q tengo aca, lo logico es q no este almancenado dentro de un mismo disco
--esto afecta el rendimiento, x lo cual mejor es tener 2 rutas de almacenamiento
On PRIMARY --archivo primario de formato .mdf
(name =ClaseF_Primary, filename= 'C:\LabFinalAdminBases\LabFinal.mdf',
size=50MB,filegrowth = 10%) --crecimiento del archivo


log on --crea el log de la base de datos y lo pone activo, es extension .ldf
(name =ClaseF_Log, filename= 'C:\LabFinalAdminBases\LabFinal.ldf',
size=40MB,filegrowth = 8%) --crecimiento del archivo

go


use LabFinal
go

alter Database LabFinal
--tener 3 rutas diferentes, tablas de datos, tablas de logs y archivos de sistema
add filegroup Adicional
go

--creacion de archivos adicinales .ndf
alter Database LabFinal
add file (name=ClaseF_NDF, filename='C:\LabFinalAdminBases\LabFinal.ndf',
size=30MB,filegrowth = 5%) to filegroup Adicional --crecimiento del archivo
go

alter database LabFinal
modify filegroup [Adicional] default

go

create login UserFBD
with password = 'Admin1234',
CHECK_EXPIRATION = ON,
CHECK_POLICY=ON;
go


create user UserAdmin1 for login UserFBD --no es necesario que login tenga el mismo nombre
with default_schema = PracticaFinal; --aun no existe epro se define para que no tome el esquema
go

create schema PracticaFinal authorization UserAdmin1; --elusuario usara el esquema ClasesAdminBD
go

grant create table to UserAdmin1;-- darle permisos al usuario para crear tablas
go


create table Genero_Pelicula(
idGenero int not null primary key,
nombreGenero varchar(150) not null
)
go

insert into Genero_Pelicula(idGenero, nombreGenero) values (1, 'Crime');
insert into  Genero_Pelicula(idGenero, nombreGenero) values (2, 'Drama');
insert into Genero_Pelicula(idGenero, nombreGenero) values (3, 'Comedy');
insert into Genero_Pelicula(idGenero, nombreGenero) values (4, 'Thriller');
insert into  Genero_Pelicula(idGenero, nombreGenero) values (5, 'Adventure');
go

create table Productora(
idProductora int not null primary key,
nombreProductora varchar(150) not null,
paisOrigen varchar(100) not null,
DirectorCine varchar(100) not null

)
go

insert into Productora (idProductora, nombreProductora, paisOrigen, DirectorCine) values (1, 'Gislason, Paucek and Wyman', 'United States', 'Byrann Bohea');
insert into Productora (idProductora, nombreProductora, paisOrigen, DirectorCine) values (2, 'Wehner, Williamson and Larkin', 'Indonesia', 'Jeane Zupa');
insert into Productora (idProductora, nombreProductora, paisOrigen, DirectorCine) values (3, 'DuBuque Group', 'Armenia', 'Eartha Bland');
insert into Productora (idProductora, nombreProductora, paisOrigen, DirectorCine) values (4, 'Konopelski Group', 'Ukraine', 'Stevie Arkill');
insert into Productora (idProductora, nombreProductora, paisOrigen, DirectorCine) values (5, 'Hirthe LLC', 'Kyrgyzstan', 'Penelope Handsheart');
insert into Productora (idProductora, nombreProductora, paisOrigen, DirectorCine) values (6, 'Toy-Ritchie', 'Croatia', 'Sandra Brislawn');
insert into Productora (idProductora, nombreProductora, paisOrigen, DirectorCine) values (7, 'Vandervort-McDermott', 'France', 'Chick Siss');
insert into Productora (idProductora, nombreProductora, paisOrigen, DirectorCine) values (8, 'Morissette-Ondricka', 'China', 'Andy Sooley');
insert into Productora (idProductora, nombreProductora, paisOrigen, DirectorCine) values (9, 'Batz and Sons', 'United States', 'Tory Dahlgren');
insert into Productora (idProductora, nombreProductora, paisOrigen, DirectorCine) values (10, 'Waelchi, Murray and Jacobs', 'China', 'Ferguson Rule');
go

create table Suscriptores(
idSuscriptor int not null primary key,
nombreSuscriptor varchar(100) not null,
correoSuscriptor varchar(100) not null,
planMensual varchar(50) not null,
costoMensual money
)
go



create table Pelicula(
idPelicula int not null primary key,
tituloPelicula varchar(150) not null,
autorPelicula varchar(100) default ('Autor Desconocido'),
fechaCreacion date default getdate(),
idGenero int,
idProductora int,
CONSTRAINT [FK_idGenero] FOREIGN KEY (idGenero) REFERENCES Genero_Pelicula(idGenero),
CONSTRAINT [FK_idProductora] FOREIGN KEY (idProductora) REFERENCES Productora(idProductora)
)on EsquemaParticionPelicula(idPelicula)
go

insert into Pelicula (idPelicula, tituloPelicula, autorPelicula, fechaCreacion, idGenero, idProductora) values (1, 'Curly Sue', 'Birk Hagston', '10/31/2023', 1, 1);
insert into Pelicula (idPelicula, tituloPelicula, autorPelicula, fechaCreacion, idGenero, idProductora) values (2, 'Rush Hour 2', 'Bastian Dickman', '7/3/2023', 2, 2);
insert into Pelicula (idPelicula, tituloPelicula, autorPelicula, fechaCreacion, idGenero, idProductora) values (3, 'Bloody Child, The', 'Madel Domerq', '8/5/2023', 3, 3);
insert into Pelicula (idPelicula, tituloPelicula, autorPelicula, fechaCreacion, idGenero, idProductora) values (4, 'Special When Lit', 'Cobbie Tillard', '10/23/2023', 4, 4);
insert into Pelicula (idPelicula, tituloPelicula, autorPelicula, fechaCreacion, idGenero, idProductora) values (5, 'Mystery Train', 'Hersh Le Franc', '6/30/2023', 5, 5);
insert into Pelicula (idPelicula, tituloPelicula, autorPelicula, fechaCreacion, idGenero, idProductora) values (6, 'Before the Rains', 'Helen Cunniff', '7/12/2023', 5, 6);
insert into Pelicula (idPelicula, tituloPelicula, autorPelicula, fechaCreacion, idGenero, idProductora) values (7, '25th Hour', 'Merwyn Julian', '6/17/2023', 4, 7);
insert into Pelicula (idPelicula, tituloPelicula, autorPelicula, fechaCreacion, idGenero, idProductora) values (8, 'Loser Takes All, The (O hamenos ta pairnei ola)', 'Parsifal Ashlin', '3/12/2024', 8, 8);
insert into Pelicula (idPelicula, tituloPelicula, autorPelicula, fechaCreacion, idGenero, idProductora) values (9, 'Blue Dahlia, The', 'Noelani Stileman', '1/29/2024',3, 9);
insert into Pelicula (idPelicula, tituloPelicula, autorPelicula, fechaCreacion, idGenero, idProductora) values (10, 'Tamara', 'Sela Cappineer', '5/13/2023', 2, 10);
insert into Pelicula (idPelicula, tituloPelicula, autorPelicula, fechaCreacion, idGenero, idProductora) values (11, 'History of the Eagles', 'Eldridge Nassie', '12/5/2023', 3, 9);
insert into Pelicula (idPelicula, tituloPelicula, autorPelicula, fechaCreacion, idGenero, idProductora) values (12, 'Sebastian', 'Nydia McGuigan', '10/15/2023', 1, 8);
insert into Pelicula (idPelicula, tituloPelicula, autorPelicula, fechaCreacion, idGenero, idProductora) values (13, 'Jo Jo Dancer, Your Life is Calling', 'Remington McGlaughn', '2/28/2024', 2, 7);
insert into Pelicula (idPelicula, tituloPelicula, autorPelicula, fechaCreacion, idGenero, idProductora) values (14, '19th Wife, The', 'Robinett Rutty', '5/14/2023', 1, 6);
insert into Pelicula (idPelicula, tituloPelicula, autorPelicula, fechaCreacion, idGenero, idProductora) values (15, 'Hypothesis of the Stolen Painting, The (L''hypothèse du tableau volé)', 'Vale Fullylove', '3/26/2024', 3, 5);
insert into Pelicula (idPelicula, tituloPelicula, autorPelicula, fechaCreacion, idGenero, idProductora) values (16, 'In the Mood For Love (Fa yeung nin wa)', 'Teddy MacIlriach', '8/31/2023', 4, 4);
insert into Pelicula (idPelicula, tituloPelicula, autorPelicula, fechaCreacion, idGenero, idProductora) values (17, 'Le grand soir', 'Ilene Erickssen', '9/14/2023', 3, 3);
insert into Pelicula (idPelicula, tituloPelicula, autorPelicula, fechaCreacion, idGenero, idProductora) values (18, 'Lovecraft: Fear of the Unknown', 'Sigismund Igglesden', '11/28/2023', 5, 2);
insert into Pelicula (idPelicula, tituloPelicula, autorPelicula, fechaCreacion, idGenero, idProductora) values (19, 'Cosmonaut, The', 'Otes Nieass', '5/7/2023', 4, 1);
insert into Pelicula (idPelicula, tituloPelicula, autorPelicula, fechaCreacion, idGenero, idProductora) values (20, 'Shanghai Surprise', 'Bonita McCutheon', '4/24/2023', 3, 2);
insert into Pelicula (idPelicula, tituloPelicula, autorPelicula, fechaCreacion, idGenero, idProductora) values (21, 'Dragon Ball Z: Bardock - The Father of Goku (Doragon bôru Z: Tatta hitori no saishuu kessen - Furiiza ni itonda Z senshi Kakarotto no chichi)', 'Bobbi Goodings', '12/4/2023', 5, 21);
insert into Pelicula (idPelicula, tituloPelicula, autorPelicula, fechaCreacion, idGenero, idProductora) values (22, 'House III: The Horror Show', 'Gordon Glendinning', '6/15/2023', 2, 3);
insert into Pelicula (idPelicula, tituloPelicula, autorPelicula, fechaCreacion, idGenero, idProductora) values (23, 'Centurion', 'Bobbe McCrudden', '9/17/2023', 1, 4);
insert into Pelicula (idPelicula, tituloPelicula, autorPelicula, fechaCreacion, idGenero, idProductora) values (24, 'Cat from Outer Space, The', 'Mada Dagwell', '8/6/2023', 3, 5);
insert into Pelicula (idPelicula, tituloPelicula, autorPelicula, fechaCreacion, idGenero, idProductora) values (25, 'Nobody Walks', 'Giff Asmus', '5/19/2023', 4, 6);
insert into Pelicula (idPelicula, tituloPelicula, autorPelicula, fechaCreacion, idGenero, idProductora) values (26, 'Silent Trigger', 'Carree Hyrons', '5/13/2023', 2, 7);
insert into Pelicula (idPelicula, tituloPelicula, autorPelicula, fechaCreacion, idGenero, idProductora) values (27, 'Ciao Bella', 'Nicki Lanmeid', '6/27/2023', 3, 8);
insert into Pelicula (idPelicula, tituloPelicula, autorPelicula, fechaCreacion, idGenero, idProductora) values (28, 'Malcolm X', 'Hercules Hirthe', '2/23/2024', 1, 9);
insert into Pelicula (idPelicula, tituloPelicula, autorPelicula, fechaCreacion, idGenero, idProductora) values (29, 'The Legend of Sarila', 'Manda Rosenfelt', '8/7/2023', 4, 10);
insert into Pelicula (idPelicula, tituloPelicula, autorPelicula, fechaCreacion, idGenero, idProductora) values (30, 'One Hundred Mornings', 'Gabe Cahalin', '6/21/2023', 5, 11);


select * from Pelicula

--agrego 3 grupos mas para las 3 particiones de la funcion y el esquema
--creacion de filegroups
ALTER DATABASE LabFinal
ADD FILEGROUP Particion1
GO
ALTER DATABASE LabFinal
ADD FILEGROUP Particion2
GO
ALTER DATABASE LabFinal
ADD FILEGROUP Particion3
GO

--creacion de archivos
ALTER DATABASE LabFinal
add file (name=idPelicula1, filename='C:\LabFinalAdminBases\idPelicula1.ndf',
size=15MB,filegrowth = 25%) to filegroup Particion1 --crecimiento del archivo
go

ALTER DATABASE LabFinal
add file (name=idPelicula2, filename='C:\LabFinalAdminBases\idPelicula2.ndf',
size=15MB,filegrowth = 25%) to filegroup Particion2 --crecimiento del archivo
go

ALTER DATABASE LabFinal
add file (name=idPelicula3, filename='C:\LabFinalAdminBases\idPelicula3.ndf',
size=15MB,filegrowth = 25%) to filegroup Particion3 --crecimiento del archivo
go

-- funcion que tiene la division para indicar a que particion deben ir los datos
CREATE PARTITION FUNCTION FuncionParticion (int)
AS RANGE RIGHT
FOR VALUES(10,20)
GO

--Esquema hace la reparticion a traves de los filegroups
CREATE PARTITION SCHEME EsquemaParticionPelicula As PARTITION FuncionParticion --utiliza la funcion
TO (Particion1,Particion2,Particion3)

--verificacion de datos por particion
SELECT idPelicula,tituloPelicula,autorPelicula,fechaCreacion,idGenero,idProductora, $PARTITION.FuncionParticion (idPelicula) as Particion
FROM Pelicula
GO

--creacion indice particionado
create nonclustered index IDX_IdPelicula
on Pelicula(tituloPelicula)
on EsquemaParticionPelicula(idPelicula)
go

--insert de 10 clientes
insert into Suscriptores (idSuscriptor, nombreSuscriptor, correoSuscriptor, planMensual, costoMensual) values (1, 'Marice Lethbridge', 'mlethbridge0@pinterest.com', 'standar', '$15');
insert into Suscriptores (idSuscriptor, nombreSuscriptor, correoSuscriptor, planMensual, costoMensual) values (2, 'Amelita Soitoux', 'asoitoux1@buzzfeed.com', 'premium', '$25');
insert into Suscriptores (idSuscriptor, nombreSuscriptor, correoSuscriptor, planMensual, costoMensual) values (3, 'Hewie Mendenhall', 'hmendenhall2@delicious.com', 'premium', '$25');
insert into Suscriptores (idSuscriptor, nombreSuscriptor, correoSuscriptor, planMensual, costoMensual) values (4, 'Rudiger Maw', 'rmaw3@washingtonpost.com', 'standar', '$15');
insert into Suscriptores (idSuscriptor, nombreSuscriptor, correoSuscriptor, planMensual, costoMensual) values (5, 'Robby McVrone', 'rmcvrone4@bandcamp.com', 'premium', '$25');
insert into Suscriptores (idSuscriptor, nombreSuscriptor, correoSuscriptor, planMensual, costoMensual) values (6, 'Ty Erricker', 'terricker5@shop-pro.jp', 'standar', '$15');
insert into Suscriptores (idSuscriptor, nombreSuscriptor, correoSuscriptor, planMensual, costoMensual) values (7, 'Juliet Marcome', 'jmarcome6@shutterfly.com', 'premium', '$25');
insert into Suscriptores (idSuscriptor, nombreSuscriptor, correoSuscriptor, planMensual, costoMensual) values (8, 'Domingo Hovie', 'dhovie7@sina.com.cn', 'standar', '$15');
insert into Suscriptores (idSuscriptor, nombreSuscriptor, correoSuscriptor, planMensual, costoMensual) values (9, 'Winnah Campaigne', 'wcampaigne8@bigcartel.com', 'premium', '$25');
insert into Suscriptores (idSuscriptor, nombreSuscriptor, correoSuscriptor, planMensual, costoMensual) values (10, 'Jed Durtnall', 'jdurtnall9@homestead.com', 'standar', '$15');


--creacion de la vista
create view View_PeliculasGenerosProductoras(idPelicula, tituloPelicula, autorPelicula, fechaCreacion,
idGenero,nombreGenero,idProductora,nombreProductora, paisOrigen, DirectorCine)
with encryption, schemabinding, VIEW_METADATA
as
select p.idPelicula,p.tituloPelicula,p.autorPelicula,p.fechaCreacion,g.idGenero,
g.nombreGenero,prod.idProductora,prod.nombreProductora,prod.paisOrigen,prod.DirectorCine
from DBO.Pelicula as p
inner join DBO.Genero_Pelicula as g on g.idGenero = p.idGenero
inner join DBO.Productora as prod on prod.idProductora = p.idProductora

go

select* from View_PeliculasGenerosProductoras
go
