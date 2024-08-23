
select *  from [Purchasing].[PurchaseOrderHeader];

-- Funcion Round
select PurchaseOrderID  as orden, TotalDue  real ,
 	ROUND(TotalDue * 1.2,2) proyeccion
	from Purchasing.PurchaseOrderHeader;

-- Funciones de agrupacion
	select COUNT(status) Cant,SUM(TotalDue) Total, min(TotalDue) Minimo,
	max(TotalDue) Maximo,avg(TotalDue) promedio
	from Purchasing.PurchaseOrderHeader  ordenes;

-- Group by
select EmployeeID , Status,COUNT(status) Cant,SUM(TotalDue) Total, min(TotalDue) Minimo,
	max(TotalDue) Maximo,avg(TotalDue) promedio
	from Purchasing.PurchaseOrderHeader  ordenes
	group by EmployeeID,Status
	order by EmployeeID;


-- Uso de Case
	select EmployeeID , 
	CASE
		WHEN status=1 THEN 'Abierta'
		WHEN status=2 THEN 'Transito'
		WHEN status=3 THEN 'Confirmado'
		ELSE 'Cerrada'
	END  Status
	,COUNT(status) Cant,SUM(TotalDue) Total, min(TotalDue) Minimo,
	max(TotalDue) Maximo,avg(TotalDue) promedio
	from Purchasing.PurchaseOrderHeader  ordenes
	where TotalDue > 1000
	group by EmployeeID,Status
	having COUNT(status) >= 10
	order by EmployeeID;

-- Inner Join
	select EmployeeID,empleados.FirstName +' ' +empleados.LastName EMpleado,
		vendedores.Name  Vendedor,
		PurchaseOrderID ,TotalDue 
		from [Purchasing].[PurchaseOrderHeader] ordenes
		inner join Person.Person empleados
		on ordenes.EmployeeID = empleados.BusinessEntityID
		INNER JOIN  Purchasing.Vendor vendedores
		on ordenes.VendorID = vendedores.BusinessEntityID
		where TotalDue >100000
		order by TotalDue desc

-- Inner join / con Group by
	select EmployeeID , empleados.FirstName +' ' +empleados.LastName EMpleado,
	CASE
		WHEN status=1 THEN 'Abierta'
		WHEN status=2 THEN 'Transito'
		WHEN status=3 THEN 'Confirmado'
		ELSE 'Cerrada'
	END  Status
	,COUNT(status) Cant,SUM(TotalDue) Total, min(TotalDue) Minimo,
	max(TotalDue) Maximo,avg(TotalDue) promedio
	from Purchasing.PurchaseOrderHeader  ordenes
	inner join Person.Person empleados
	on ordenes.EmployeeID = empleados.BusinessEntityID
	where TotalDue > 1000
	group by EmployeeID,Status,empleados.FirstName ,empleados.LastName
	having COUNT(status) >= 10
	order by EmployeeID;



-- Inner Join
		select persona.FirstName +' ' +persona.LastName EMpleado,
			empleados.BirthDate  Fecha_Nac,empleados.MaritalStatus Estado_Civil,
			empleados.Gender  Genero
		from HumanResources.Employee empleados
		inner join Person.Person persona
		on empleados.BusinessEntityID = persona.BusinessEntityID

-- Disting
		select distinct(Gender) from HumanResources.Employee empleados