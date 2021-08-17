use BikeStores
--http://www.sqlservertutorial.net/sql-server-sample-database/
--http://www.sqlservertutorial.net/sql-server-stored-procedures/

--select * from sales.customers where state = 'CA' order by first_name

--select city, count(*) from sales.customers
--	where state = 'CA'
--	group by city
	
--select first_name, last_name from sales.customers order by len(first_name) -- first_name asc, last_name desc 

---- offset -fetch
--select product_name, list_price from production.products order by list_price, product_name
--	ilk 10 taneyi getirir // select top 10 ... ile de olur
	--offset 5 rows
	--fetch first 10 rows only

--	--ilk 10dan sonrasýný getirir
--	offset 10 rows

---- select top (expression) [percent] [with ties] from table_name order by column_name // with ties varsa order by olmak zorunda
--select top 1 percent with ties product_name, list_price from production.products order by list_price desc
---- with ties, sonuncu ile ayný deðerde olanlarý da tabloya ekler

--select distinct city, state, zip_code from sales.customers 

--select product_id, product_name, category_id, model_year, list_price from production.products
--	-- where list_price between 1899.00 and 1999.99 and model_year > 2018
--	where list_price in (1999.99,1899.99,1599.99)
--	order by list_price desc

--select first_name, last_name from sales.customers
--	where first_name like '_Ai%'

--select first_name, last_name, phone from sales.customers
--	where phone is NULL -- phone = NULL çalýþmaz

---- and    true false unknown             or		true false unknown
----true	  t		f		u				 t		t		t	u
----false   f		f		f				 f		t		f	u
----unknow  u		f		u				 u		t		u	u

--select  * from production.products
--	where brand_id = 1 or ( brand_id = 2 and list_price > 1000 )


--create schema hr;
--go
--create table hr.candidates(
--	id int primary key identity,
--	fullname varchar(100) not null
--	);

--create table hr.employees(
--	id int primary key identity,
--	fullname varchar(100) not null
--	);

--insert into hr.candidates(fullname) values ('Jhon Doe'),('Liza Jhon'),('Ahmet Sahin'),('Ayse Yilmaz')

--insert into hr.employees(fullname) values ('Jhon Doe'),('Liza Jhon'),('Mehmet Ali'),('Fatma Yavuz')

 --left, right joinleri çalýþtýr
--select c.id candidates_id, c.fullname candidates_name, e.id employee_id, e.fullname employee_name
--	from hr.candidates c full join hr.employees e
--	on c.fullname = e.fullname where e.id is null or c.id is null

--select pp.product_name, pp.list_price, pp.category_id from production.products pp 
--	inner join production.categories pc on pp.category_id = pc.category_id

--select product_name, category_name, brand_name, list_price from production.products pp
--	inner join production.categories pc on pp.category_id = pc.category_id
--	inner join production.brands pb on pp.brand_id = pb.brand_id
--	order by product_name

-------------ÖDEV SORULARI--------------
-- 'Debra' ÝSMÝNDEKÝ MÜÞTERÝLERÝN ALDIÐI ÜRÜNLERÝN TOPLAM FÝYATI NEDÝR
-- MARKA BAZINDA YAPTIÐI HARCAMA
-- EN AZ 4 TABLOYU BÝRLEÞTÝRECEK HERHANGÝ BÝR SORGU

---- SUBQUERY Alt Sorgu --
--select order_id, order_date, customer_id
--	from sales.orders
--	where customer_id in (
--		select customer_id from sales.customers
--			where city = 'New York')
--	order by order_date desc

--select product_name, list_price
--	from production.products
--	where list_price > ( select AVG(list_price)
--		from production.products
--		where brand_id in (select brand_id
--			from production.brands
--			where brand_name = 'Strider' or brand_name = 'Trek')
--		)
--	order by list_price

--select order_id, order_date,
--	(select max(list_price) from sales.order_items i 
--		where i.order_id = o.order_id)
--	as max_list_price
--	from sales.orders o
--	order by order_date desc

--select product_name, list_price from production.products
--	where list_price >= ANY(
--		select AVG(list_price)
--		from production.products group by brand_id )

--her grubun en pahalý ürününü getirir
--select product_name, list_price, category_id 
--	from production.products p1
--	where list_price in (
--		select max(p2.list_price)
--		from production.products p2
--		where p2.category_id = p1.category_id
--		group by p2.category_id
--		)
--	order by category_id, product_name

-- !!! EXIST araþtýr --

-- !!! intersect araþtýr --
-- UNION (ALL) or EXCEPT --
--select first_name, last_name from sales.staffs
--union all --except
--select first_name, last_name from sales.customers

-- Bunu incele -- tablo ekliyor vs.
--select b.brand_name as brand,
--	c.category_name as category,
--	p.model_year,
--	round( sum( quantity * i.list_price * (1-discount)), 0) sales INTO sales.sales_summary
--	from sales.order_items i
--	INNER JOIN production.products p on p.product_id = i.product_id
--	INNER JOIN production.brands b on b.brand_id = p.brand_id
--	INNER JOIN production.categories c on c.category_id = p.category_id
--	group by b.brand_name, c.category_name, p.model_year

--select sum( sales ) sales from sales.sales_summary group by brand

-- GROUPING sets --
--select brand, category, sum(sales) sales
--	from sales.sales_summary
--	group by 
--		GROUPING sets(
--			(brand, category),
--			(brand),
--			(category),
--			()
--			)
--	order by brand, category

-- CUBE --
--select brand, category, sum(sales) sales
--	from sales.sales_summary
--	group by 
--		cube(
--			(brand, category)
--			)
--	order by brand, category

-- ROLLUP --
--select brand, category, sum(sales) sales
--	from sales.sales_summary
--	group by 
--		rollup( brand, category)

-- !!! MERGE -- araþtýr

-- Viewler 

-- !!! Concat() -- araþtýr

-- Stored Procedur yazýlacak
-- fonksiyonlar bir deðiþiklik yapmaz, gelen veri ile bir sonuç döndürür. ama Prosedürler veritabanýnda deðiþiklikler yapabilir.
--Prosedürlerde loops vs..

-- Örnek -while
--CREATE or alter PROCEDURE sayac
--AS
--declare @counter INT = 1;
--while @counter <= 5
--begin
--	print @counter;
--	set @counter = @counter + 1;
--	if @counter = 3
--		break;
--		--continue;
--end

--exec sayac

-- SQL CURSOR çalýþ!!!!! kim cursor oluþturabilir, kim kullanabilir vs..
--DECLARE 
--    @product_name VARCHAR(MAX), 
--    @list_price   DECIMAL;
 
--DECLARE cursor_product CURSOR
--FOR SELECT 
--        product_name, 
--        list_price
--    FROM 
--        production.products;

--OPEN cursor_product;

--FETCH NEXT FROM cursor_product INTO 
--    @product_name, 
--    @list_price;
 
--WHILE @@FETCH_STATUS = 0 -- bir fonksiyondur. son satýra kadar ilerlemesini saðlar
--    BEGIN
--        PRINT @product_name + CAST(@list_price AS varchar); --CAST nedir?
--        FETCH NEXT FROM cursor_product INTO 
--            @product_name, 
--            @list_price;
--    END;
--	CLOSE cursor_product;

--Try-Catch... !!!!!!!!!! TRANSACTION => commit - rollback!!!!
-- örnek try-catch
--create procedure usp_divide
--(
--	@a decimal,
--	@b decimal,
--	@c decimal output
--)as
--begin
--	begin try
--		set @c = @a / @b;
--	end try
--	begin catch
--		select
--			ERROR_NUMBER() as ErrorNumber,
--			ERROR_SEVERITY() as ErrorSeverity,
--			ERROR_STATE() as ErrorState,
--			ERROR_PROCEDURE() as ErrorProcedure,
--			ERROR_LINE() as ErrorLine,
--			ERROR_MESSAGE() as ErrorMessage;
--		end catch
--	end;

--declare @r decimal;
--exec usp_divide 10,2, @r output
--print @r

--declare @r2 decimal;
--exec usp_divide 10,0, @r2 output;
--print @r2

-- Transactions!!!!!!!!!!!!!
-- 2 tablo oluþturup ver eklendi
--CREATE PROC usp_report_error
--AS
--    SELECT   
--        ERROR_NUMBER() AS ErrorNumber  
--        ,ERROR_SEVERITY() AS ErrorSeverity  
--        ,ERROR_STATE() AS ErrorState  
--        ,ERROR_LINE () AS ErrorLine  
--        ,ERROR_PROCEDURE() AS ErrorProcedure  
--        ,ERROR_MESSAGE() AS ErrorMessage;  
--GO

--CREATE PROC usp_delete_person(
--    @person_id INT
--) AS
--BEGIN
--    BEGIN TRY
--        BEGIN TRANSACTION;
--        -- delete the person
--        DELETE FROM sales.persons 
--        WHERE person_id = @person_id;
--        -- if DELETE succeeds, commit the transaction
--        COMMIT TRANSACTION;  
--    END TRY
--    BEGIN CATCH
--        -- report exception
--        EXEC usp_report_error;
        
--        -- Test if the transaction is uncommittable.  
--        IF (XACT_STATE()) = -1  
--        BEGIN  
--			-- PRINT den sonra N"...." gelince string in unicode olduðunu belirtir. ç þ vb. harfleri göstermek için
--            PRINT  N'The transaction is in an uncommittable state.' +  
--                    'Rolling back transaction.'  
--            ROLLBACK TRANSACTION;  
--        END;  
        
--        -- Test if the transaction is committable.  
--        IF (XACT_STATE()) = 1  
--        BEGIN  
--            PRINT N'The transaction is committable.' +  
--                'Committing transaction.'  
--            COMMIT TRANSACTION;     
--        END;  
--    END CATCH
--END;

--EXEC usp_delete_person 2;

--EXEC usp_delete_person 1;

--RaiseError-Throw!!!!!!!
--Dynamic SQL!!!!!
--http://www.sqlservertutorial.net/sql-server-stored-procedures/sql-server-dynamic-sql/
DECLARE 
    @table NVARCHAR(128),
    @sql NVARCHAR(MAX);

SET @table = N'production.products';
SET @sql = N'SELECT * FROM ' + @table;
EXEC sp_executesql @sql;

CREATE PROC usp_query (
    @table NVARCHAR(128)
)
AS
BEGIN
 
    DECLARE @sql NVARCHAR(MAX);
    -- construct SQL
    SET @sql = N'SELECT * FROM ' + @table;
    -- execute the SQL
    EXEC sp_executesql @sql;
    
END;

EXEC usp_query 'production.brands';

create table sales.tests(id INT)