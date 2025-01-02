use master
go

CREATE DATABASE ControlInventario
go

use ControlInventario
go

create table ventas
(idventa int not null primary key,
idcliente int not null,
idproducto int not null,
nombreproducto varchar(50),
cantidad int
)
go


create table inventario
(idproducto int not null primary key,
nombreproducto varchar(50),
cantidaddisponible int,
precio money
)
go

insert into inventario (idproducto, nombreproducto, cantidaddisponible, precio)
values
	(01, 'Plywood 18mm', 20, 40000)
go

--con este insert se tiene q disparar el trigger a crear, primero creo el trigger
insert into ventas (idventa, idcliente,idproducto,nombreproducto,cantidad)
values
	(2, 123, 1, 'Plywood 18mm',20)
go
--consulto las ventas realizadas
select * from ventas

--consulto la cantidad disponible en inventario
select *from inventario

--creo el trigger
create trigger Tr_ControlVentas

on [ventas] instead of insert
as
begin

declare @cantidadVenta int, @cantDisponible int, @idproducto int;
select @idproducto=idproducto,@cantidadVenta= cantidad from inserted
select @cantDisponible= cantidaddisponible from inventario where idproducto= @idproducto
if @cantidadVenta<=@cantDisponible
	begin

insert into ventas (idventa, idcliente,idproducto,nombreproducto,cantidad)
select	idventa,idcliente, idproducto,nombreproducto,cantidad
from inserted;

Update inventario 
set cantidaddisponible=cantidaddisponible - @cantidadVenta
 
where idproducto=@idproducto
End

else
begin
print 'Cantidad de venta mayor a la disponible';
end

end
go
