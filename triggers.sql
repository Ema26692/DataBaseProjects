
Use Northwind
go
--Crear una tabla HistorialEliminacion
Create table HistorialEliminacion
(codigo int identity(1,1) primary key
,fecha date
,IDCustomer nchar (5)
, usuario varchar(100)
)
go
--Creación de trigger Tr_insert_cliente
Create trigger Tr_insert_cliente
on customers for Delete
as
Begin
declare @ID nchar (5);

select  @ID = CustomerID from deleted;

Insert into HistorialEliminacion (fecha, IDCustomer, usuario ) 
values (getdate(),
		@ID, 
		user)
End;

--consulta código trigger
sp_helptext Tr_insert_cliente
go

--Eliminar un cliente para probar el registro en HistorialEliminacion

select * from Customers

Delete from customers where customerid='Paris'


select * from HistorialEliminacion

--Modificar tabla y trigger

exec sp_rename 'HistorialEliminacion.fecha', 'fecha_eliminacion', 'column'
go

Alter table HistorialEliminacion

add
	CompanyName nvarchar(40),
	City nvarchar(15)
go

select * from HistorialEliminacion


Alter trigger Tr_insert_cliente
on customers for Delete
as
Begin
IF @@ROWCOUNT > 0
	begin
	declare @ID nchar (5),
			@Company nvarchar (40),
			@Place nvarchar (15)

	select  @ID = CustomerID, @Company = CompanyName, @Place = City from deleted;

	Insert into HistorialEliminacion (fecha_eliminacion, IDCustomer, usuario, CompanyName, City ) 
	values (getdate(),
			@ID, 
			ORIGINAL_LOGIN(),
			--user,
			@Company,
			@Place)
	end;
End;

--Consultar triggers existentes en una base de datos
SELECT * FROM sys.triggers

insert into Customers (CustomerID, CompanyName,City)
values
	('ASPE', 'Alejandro Serrano SA', 'Tibas'),
	('RPDP', 'Ruedas y roles', 'San Isidro'),
	('MNDO', 'Tornillos SA', 'La Uruca')

Delete from customers where customerid='ASPE'
Delete from customers where customerid='RPDP'

select * from HistorialEliminacion

select * from Customers

--Crear trigger que actualiza precios
select * from products
Select * from [Order Details]
go
--Creando el trigger
Create trigger Tr_actualizar_precio
on [order details] for insert
as
Begin
Update d set d.UnitPrice=p.UnitPrice
from [order details] d 
inner join products p on d.productid=p.productid
inner join inserted i on i.OrderID=d.OrderID and i.ProductID=d.ProductID
End
-----Insertar un dato

Insert into [order details] (orderid, productid, quantity, discount)
values (10248, 2, 10, 0)
-----Verificar que el trigger ponga el precio que no enviamos en el insert
Select * from [Order Details] where orderid=10248
go

-----------Trigger de insercion que quita del inventario
Create trigger Tr_actualizar_stock
on [order details] for insert
as
Begin
Update p set 
p.UnitsInStock=p.UnitsInStock - i.Quantity
from inserted i 
inner join products p 
on i.productid=p.productid
End
go

-----Insertar un dato
Insert into [order details] (orderid, productid, quantity, discount)
values (10248, 3, 10, 0)
-----Verificar que el trigger ponga el precio que no enviamos en el insert
Select * from [Order Details] where orderid=10248

select * from Products