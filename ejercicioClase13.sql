use Northwind
go

--transacciones automaticas

--insertar und ato en la tabla
insert into Customers(CustomerID,CompanyName,ContactName,City)
values
('AZFM','Serrano consulting','Alejandro Serrano','San Jose')
go
select * from Customers

--actualizar dato en tabla
update Customers
set CustomerID= 'ASPE'
where CustomerID= 'AZFM'
GO

--transacciones explicitas
select * from Customers where CustomerID= 'ASPE'
	--aqui le aviso q voy hacer una transaccion
	BEGIN TRANSACTION
	delete from Customers where CustomerID= 'ASPE'	
	GO

--confirmacion de transaccion
commit transaction --tambien podriamos decir commit tran

--sino quiero hacer el delete hago un descarte de transaccion
rollback transaction

--hacemos consulta de bloqueos
exec sp_lock

--transacciones implicitas, activar un comando q indica q no son transacciones automaticas
set implicit_transactions on --cualkier transaccion insert,update,delete inicia la transaccion
--las implicitas casi no se usan
--inicia la transaccion
insert into Customers(CustomerID,CompanyName,ContactName,City)
values
('AZFM','Serrano consulting','Alejandro Serrano','San Jose')
go

select *from Customers

exec sp_lock --aqui tenemos la transaccion pendiente entonces o commit o rollback

commit transaction

--aqui vamos a ver otro tema
select * from Customers
--transaccion normal
begin transaction update Customers set CompanyName= CompanyName +'1'
go

rollback transaction

--vamos a crear otro usuario, nos vamos a security, login y creamos un login nuevo llamado clase13,
--autenticacion sql server y le ponemos 1234, luego en mapping seleccionamos northwind y datareader y
--datawriter, tambien en general quitarle el policy
--abrimos otro sql server y entramos con el nuevo usuario q cree




