use Northwind
go

select * from Customers

--con esto me doy cuenta si hay transacciones q no han sido terminadas,sin commit o rollback
set transaction isolation level read uncommitted
--puede q si hacemos una consulta y hay alguna transaccin sin finalizar, nos puede mostrar informacion
--fantasma, entonces no es consistente

