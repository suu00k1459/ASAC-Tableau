use test_sql;

select * from sample;

-- 1. United Kingdom의 Stockcode는 몇 종류 인가요?
select count(distinct stockCode)
from sample ;

-- 2. United Kingdom의 Stockcode가 22960인 상품의 총 매출액은 얼마인가요?
select sum(Quantity *UnitPrice)
from sample 
where STockCode = 22960;

-- 3. United Kingdom의 Stockcode가 84879인 상품을 구매한 고객의 수는 몇 명인가?
select count(distinct CustomerID)
from sample
where Stockcode = 84879;

-- 4. 구매량이 가장 많은 상품의 코드 번호는 무엇인가?
select StockCode, sum(Quantity) sq from sample
group by StockCode
order by sq desc;

use test_sql;

select StockCode
from sample
group by StockCode
having max(sum(Quantity)) = sum(Quantity);
-- order by sum_Quantity desc;


5. CUSTOMERID의 값이 17809번인 고객의 첫 구매일은 언제인가?
select * 
From sample
where CustomerID = 17809 
order by InvoiceDate;

-- 6. 2011년 2월 2일의 첫 구매 고객의 수는 몇 명인가요? : 
select count(distinct CustomerID) 
from sample
where InvoiceDate ='2011-02-02'
and CustomerID not in (
select distinct CustomerID 
from sample
where InvoiceDate<'2011-02-02') ;

-- 7. CUSTOMERID가 17850인 회원의 STOCKCODE가 71053인 물품의 첫 구매일자는 언제인가요?
select *
from sample
where CustomerID=17850
and stockCode =71053
order by InvoiceDate;

-- 8. 첫 구매 후 이탈하는 고객의 비율은 어떻게 되는가?
select sum(once)/count(*)
from(
select CustomerID, 
	case when count(distinct InvoiceDate) >1 then 0
		else 1
        end as "once"
from sample
group by CustomerID
) A
;

-- 9. 첫 구매 후 이탈하는 고객의 비중이 나라별로 봤을 때, Australia는 얼마인가?
select Country, sum(once)/count(*)
from(
select Country, 
		CustomerID, 
	case when count(distinct InvoiceDate) >1 then 0
		else 1
        end as "once"
from sample
group by  Country, CustomerID
) A
group by Country
having Country ="Australia";

-- 10. 2011년에 한해서 2011년의 1주차의 총매출액은 얼마인가? (해당 기능에 대한 함수를 검색해서 찾아서 해보세요!) 
select round(sum(Quantity*UnitPrice),2) from(
select * , week(InvoiceDate, 0) wday from sample
where Year(InvoiceDate)='2011') A
where wday = 1;