use sqldb;
select *
from buytbl;

-- 예 ) 구매 이력 관련 테이블에서 고객별로 구매건수(총합) 체크
-- 고객 등급 관리...
select userID, sum(amount) amounts
from buytbl
group by  userID;

select userID, price*amount as pay from buytbl;

-- q) 1건의 구매가 발생할 때 구매 수량의 평균은 얼마? #꼭 group by 를 안 써도 됨.ㅇ
select avg(amount) from buytbl;

-- Q) 회원 id하고, 그 사람이 구매할 때 구매한 건수만 다시 보여주세요. 
select userID,
	amount
from buytbl;

-- Q) 회원 id별로 구매한 물품의 총 갯수를 보여주세요.
-- 	단, 회원 id별로 정렬해서 a-z 사전순으로 보여주세요.
select userID,
	sum(amount) amounts
from buytbl
group by userID;
order by userID;

-- Q) 위의 문제와 동일한데, 정렬을 구매 건수 기준으로 내림차순으로 보여주세요.
select *
from buytbl
order by amount desc;

-- Q) 회원 id 별로 총 소비금액을 확인하고 싶습니다. 가능하면 소비금액이 높은 분을 먼저 보고 싶음(우량고객 위주)
select userID, sum(pay)
from (select userID, price*amount as pay from buytbl) A
group by userID
order by pay desc;

-- Q) 1번 사갈 때 제일 많은 물건을 구매하신 고객님 3분을 선정해서 감사 쿠폰을 전송하려고 한다. 고객 중 3명을 누구로 선정해야하나?
select userID, sum(pay) as pay
from (select userID, price*amount as pay from buytbl) A
group by userID
order by pay desc
limit 3;

-- 정답)
select userID,
	sum(price*amount) pay 
from buytbl 
group by userID 
order by pay 
desc limit 3;

-- 함수 관련 내용 연습
-- Q) 회원 정보 에서 가장 키가 큰 회워의 이름과 키를 출력하세요

-- Q) 회워 정보를 보고, 가장 키가 큰 회원의 이름과 키, 가장 키가 작은 회원의 이름과 키를 출력
-- Q) 핸드폰 정보가 있는 회원은 몇 사람?
-- Q) 회원 정보가 등록된 회원은 몇 사람?


-- 실제 그 사람의 핸드폰 번호가 있다면 핸드폰 번호를 출력하겠다.

select A.userID,
	A.pay,
    B.mobile1,
	B.mobile2
from (select userID,
			sum(price*amount) pay 
		from buytbl 
		group by userID 
		order by pay 
		desc limit 3
		) A,
		usertbl B
where A.userID = B.userID;


-- 주의 ! hacing!
-- 집계 함수처리하고 나서 그것으로 필터링!
-- Q) 아페서 했던 고객별로 구매 금액에 대한 총합
select userid, sum(price* amount) from buytbl group by userid;

-- Q) ++ 고객별로 총 구매 금액이 1000이상인 사용자한테만 증정품을 어느 고객이 여기에 해당이 될까? 
-- 차이!) 앞에서는 집계처리한 총 금액을 청렬의 기준을 사용을 함!
-- 		여기서는 집계처리한 총 금액을 필터링 조건으로 사용을 함
select *
from (
	select userid, sum(price* amount) pay
	from buytbl 
	group by userid) A
where pay >=1000;

select userid, sum(price* amount) pay
from buytbl 
group by userid
having pay>=1000;

-- ++ 중요! having vs order by 의 순서
-- order by 기본적으로 다 세티이 되고 나서 정렬!
select userid, sum(price*amount) pay 
from buytbl 
group by userid
having pay>= 1000 #where /gorup by - having / order by 순서
order by pay asc;

-- 쿼리문에서는 사용하는 덩어리의 순서가 있음
-- ** 집계에서 필터링 할 때 무조건 where 대신에 having 으로 사용

select num, groupNAme, sum(price*amount) as "비용"
from buytbl
group by groupName, num
with rollup;
