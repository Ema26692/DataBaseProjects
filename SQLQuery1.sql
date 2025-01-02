--Select basico
select *
	from Person.Person


-- Uso del distinct
	select distinct(PersonType)  
	from Person.Person 
	
	select distinct(Title)  
	from Person.Person 
		
-- Seleccion de campos y ordenamientos	
select FirstName   Nombre,MiddleName as Nombre2 ,LastName as Apellido  
	from Person.Person
	order by FirstName asc, MiddleName desc 

-- Uso del where
	select * 
	from HumanResources.Employee
	where HireDate>='01-01-2010' and HireDate<'01-01-2011' and MaritalStatus='M'
		
-- Uso del  between
		select * 
	from HumanResources.Employee
	where HireDate  between '01-01-2010' and  '01-01-2011' and MaritalStatus='M'

-- Uso del IN
	select * 
	from HumanResources.Employee
	where (OrganizationLevel=1 or OrganizationLevel=4)  and MaritalStatus='S'

	select * 
	from HumanResources.Employee emp
	where OrganizationLevel not  in (1,4)  and MaritalStatus='S'

-- Uso del IS	
	select * 
	from HumanResources.Employee
	where OrganizationLevel is not  null

-- Uso del LIKE
	select FirstName  as Nombre,MiddleName as Nombre2 ,LastName as Apellido  
	from Person.Person 
	where LastName like '%Ma%'
	order by nombre,apellido desc

	---- Uso de funciones 
	select upper(FirstName)  as Nombre,upper(MiddleName) as Nombre2 ,
	upper(LastName) as Apellido  
	from Person.Person 
	order by nombre,apellido desc

	select upper(FirstName)+' '+isnull(upper(MiddleName),'')+' '+upper(LastName) as Nombre  
	from Person.Person  
	order by nombre 
