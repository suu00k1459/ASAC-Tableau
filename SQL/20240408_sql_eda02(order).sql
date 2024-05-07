-- EDA2에서의 목적은 여러 테이블에서 필요 정보 수집!!
use eda_02_test_db;
-- 구매 관련 데이터 셋!!!! 
-- 여러 정보들이 여러 테이블에 흩어져 있는 경우!!!!!

-- order 테이블
-- 1) order_id : 주문 관려된 id 값
-- 2) user_id  : 구매한 유저의 id 값
-- 3) eavl_set : 데이터 구분 - skip
-- 4) order_number : 구매 순서
-- 5) order_dow : 주문 요일
-- 6) order_hour~~ : 주문 시간
-- 7) days_since_prior_order : 마지막 주문부터 걸린 날짜(단위 일)
--    첫 구매 : order_number = 1, NA (이전 기록이 없으니..)
-- ex) eval_set에 종류별로 몇 건이지 체크
--     pandas : df["col"].value_counts()    [ 데이터가 적당사이즈 
select eval_set, count(eval_set) from orders group by eval_set; -- [  데이터가 엄청 클 때 ]

-- order_products__prior 테이블
-- 주문 order, 해당 주문에 여러 개별 상품들이 담기게!!
-- 1) order_id : 주문 관련 id값 --> orders 테이블과 연결!!!
-- 2) product_id : 주문한 개별 상품의 id
-- 3) add_to_cart_order : (주문에 있었던 개별 상품에 대한)장바구니에 담는 순서
-- 4) reorded : 이 상품 재구매한 상품인지 여부!!!!!!!
--      1:재구매,0: 처음 구매
select * from order_products__prior;

-- products 테이블 : 구입한 개별 상품에 대한 구체적인 정보...
-- 1) product_id : 주문한 상품의 id --> order_products__prior에 연결
-- 2) product_name : 실제 그 상품의 이름...
-- 3) aisle_id : 상세 캍테고리 id
-- 4) department_id : 카테리고 id
select * from products;

-- departments 테이블 : 카테고리
-- id값, 실제 카테고리명 ( 21개 항목) 
select * from departments; 

-- aisles 테이블 : 상세 카테고리
-- id, 이름 (134개 항목)(
select * from aisles; 


-- EDA 시작) 내가 필요한 정보들이 어디에 있는지 파악!!!
-- Q1) 전체 주문 건수 확인해보기
-- => 출처 : orders
select * from orders; 
select count(*) from orders;
select count( distinct order_id) from orders;
select count(order_id) from orders;
-- PK로 명확히 지정이 안 되어 있는 상태에서
-- order_id가 이 orders 테이블에서는 유니크하게 존재한느 값!!!!!!


-- Q2) 구매자의 수를 확인을 해보세요!! --> 왜 1번과 결과가 다를까?
-- 대상 : orders, user_id 
select * from orders;
select user_id from orders;
select count(user_id) from orders; -- 어...user_id 값이 3220개? 데이터의 수!!!
select count(distinct user_id) from orders; -- 재주문!!!!!


-- Q3) 상품이름별로 몇 건의 주문이 있었는지 체크!!!!( 주문 건수 있는 애들을 중심으로)
-- 출저 : 상품-주문(상품,주문의 코드값), 상품 테이블( 상품 이름)
-- Step1) 필요 정보
-- Step2) 부가 정보 붙이기.
select * from order_products__prior;
select * 
	from order_products__prior OP left join products P
    on OP.product_id = P.product_id;

select OP.product_id, count(OP.product_id) as `Count`, 
	   P.product_name
	from order_products__prior OP left join products P
    on OP.product_id = P.product_id
    group by OP.product_id
    order by `Count` desc;
    

-- Q4) 카트에 제일 먼저 1번으로 담는 상품10개 대해서, 
--     --> 출력 : 상품번호, 상품이름, 몇 번 1번으로 담겼는지 정보!!!
-- : 사람들이 주문할 때 제일먼저 생각하는 상품들에 대해서 알아보자!!!!
--  대상 : 몇 번째 담기는 정보(OP), + 카운팅 + top10
select * from order_products__prior;
-- case when ~~ end : 내가 관심있는 것과 아닌 거으로 구별 size
select product_id, add_to_cart_order from order_products__prior;
-- 필터링 : where/ case when ~~~~~~
select product_id, 
	sum(case when add_to_cart_order = 1 then 1 else 0 end) as `1stCNT`
	from order_products__prior
    group by product_id;
-- 계산이 된 값들을 중심으로 정렬 & limit =-=> top 10
select product_id, 
	sum(case when add_to_cart_order = 1 then 1 else 0 end) as `1stCNT`
	from order_products__prior
    group by product_id
    order by `1stCNT` desc limit 10;
-- 참고) 눈에 보이면서 진행... 이름까지 같이 가져다 붙인다면,,,,
select product_id, 
	sum(case when add_to_cart_order = 1 then 1 else 0 end) as `1stCNT`
	from order_products__prior
    group by product_id
    order by `1stCNT` desc limit 10;
    
select A.*, P.product_name from (select product_id, 
	sum(case when add_to_cart_order = 1 then 1 else 0 end) as `1stCNT`
	from order_products__prior
    group by product_id
    order by `1stCNT` desc limit 10)A left join products P
	on A.product_id = P.product_id;
-- 필요한 정보들을 1개 통 테이블로 만들고 작업하는 방식....
select OP.product_id, P.product_name, count(add_to_cart_order) as `1stCNT`
	from order_products__prior OP left join products P
		on OP.product_id = P.product_id
        where add_to_cart_order = 1
        group by OP.product_id
        order by `1stCNT` desc
        limit 10;
-- 기본적으로 join 테이블이 큰 경우들이 있을 때,,
-- join을 하고 처리하는 것 보다는,
-- 메인이되는 것들을 처리를 하고, 붙이는 방식(join) 조금더 효율적일 듯...



-- Q5) 시간대 별로 주문 건수 테이블 작성 
--     --> 출력 : 시간 순서대로 나열 하면서, 그 시간대 주문이 몇 건인지 출력
-- 목적은 주로 주문하는 시간대는 언제? 프로모션, 특가 행사 ,반짝 행사,,, 사전 정보 수집..
-- orders 테이블에 존재.. order_hour_of_day 컬럼의 정보를 활용!!!! (카운팅!!)
-- 참고) 내가 3시 대만 보겠다... sum case when~~~~~
--      그냥 전체 시간대로 다 보려고 하는 것이니,,,그냥 주어진 컬럼의 값으로 카운팅!!!!
select * from orders;
select order_id, order_hour_of_day from orders;
-- 필요한 시간대 별로 묶어서,,카운팅!!!!
-- 참고) 굳이 컬럼명까지 부여하지 않고, 결과만 볼 때 숫자로 기준 지정....
-- * 주문이 많이 일어난 건수 기준으로 볼 때..
select order_hour_of_day, count(order_hour_of_day) from orders
	 group by order_hour_of_day
     order by 2 desc;
select order_hour_of_day, count(order_hour_of_day) from orders
	 group by order_hour_of_day
     order by 1 asc;

# Q6) 첫 구매 후에 다음 구매까지 걸리는 평균 일수는 얼마인가?
select * from orders;
select order_number, days_since_prior_order from orders;
-- 필터링 : 기존의 그냥 값으로
select order_number, avg(days_since_prior_order) 
from orders
where order_number=2 ;

# Q7) 1번 주문할 때 평균 몇 '종류'의 상품을 같이 주문하는가?
select count(product_id) / count(distinct order_id) From order_products__prior;
; -- 목적은 카운팅을 할 때, count, count( distinct A ) : order 별로 product_id 는 유니크함,.alter
select avg(num) from(
select order_id, count(*) as num from order_products__prior
group by order_id
) a
; -- 똑같이 나옴
#     --> 참고) 전체 수량이 아니라 종류에 대한 부분임!!

# Q8) 지금 시점에서 고객 1명당 평균 몇 번 주문을 했는가?
select count(order_id)/ count(distinct user_id) From orders;
-- 데이터가 많이 필터링 데이터여서 조금 이상하게 나옴
-- 결론 : 우리 가입된 ㅗ회원들은 보통 1건 정도만 이용하더라...
-- 정리) 7번화 8번에서 group by 묶어서 진행을 할 수는 있지만,
-- 간단하게 pk, fk 등에 대한 비율 이런 부분에서는 count. count unique
-- 를 활용하면 간단히 계산 할 수 있음!

# Q9) 상품별로 재구매율을 구해보세요
#     --> 상품아이디, 재구매율
-- 재구매율 : 재구매된 상품/전체 상품 --> 상품별로 진행하자!
select product_id, sum(reordered) / count(*) " 재구매율" from order_products__prior
group by product_id;

# Q10) 9번의 테이블에서 재구매율이 높은 순서대로 순위를 부여해보세요.
#     --> 출력 : 상품아이디, 재구매율, 랭킹
select product_id, sum(reordered) / count(*) " 재구매율" ,
	rank() over( order by sum(reordered) / count(*) desc) "rank"
from order_products__prior
group by product_id;

# Q11) 9번의 재구매율이 높은 상품이 무엇인지 이름까지 같이 출력해주세요.
#     --> 출력 : 상품아이디, 상품이름, 재구매율, 주문건수
-- select * from B 위에 쿼리문 실행 결과가 B 테이블이라고 가정하고,
-- product 테이블을 참조해서, 이름만 가져다가 붙이겠다.

select B.* , P.product_name
from (
select product_id, sum(reordered) / count(*) " 재구매율" ,
	rank() over( order by sum(reordered) / count(*) desc) "rank"
from order_products__prior
group by product_id
) B 
left join products P
on B.product_id = P.product_id
-- 일반저긍로 사용하는 쿼리의 스타일하고
-- eda 것들을 하는 스타일의 쿼리하고 다른 부분이 있고
-- eda 를 하다보면, 본인 생각하는 새로운 기준으로 하다보니
-- 중첩을 많이 사용하게 됨. 쿼릴의 구조가 서브쿼리가 많이 사용되는 양식으로 작성이 됨.
-- 항상 쿼리를 덩어리 별로 보시는 것이 좋음.

-- 정리1) 카운트 관련 부분
-- count(*), count(1), count(PK), count(distinct ~~ )
-- 비율, 특정한 값을 수 sum( case when ~~ end 1/0)
-- 비율( 관계 속에서 할 때) count(A)/ count(distinct B)
-- 기본 : group by 를 통해서, count하는 게 기본이기는 함.

-- 정리2) join 을 할 때 생각할 부분
-- join 을 할 때 시간에 대한 비용이 큼
-- 최대한 컴팩트하게 정리를 1개 테이블에 끝내고 다른 테이블을 참조하는 방식이 좋음
-- 필요한 거 다 가져다 놓고 처리하는 것 보다는.
-- 최대한 데이터 핸들링 할 때 : 컴팩트하게 다루는 게 용이
-- 분석에서는 결과만 도출하면 되어서, 아주 크게 효율성까지는 체크하지 않지만, 그래도 늘 고민할 것
-- (부서에서 보통 고민된 결과들이 있고 사용하는 방식도 다르기 때문에!)

;
select aa.product_id, 
	bb.product_name,
	sum(reordered) / count(*) " 재구매율" ,
	rank() over( order by sum(reordered) / count(*) desc) "rank",
    count(order_id) 주문건수
from order_products__prior AA,
	products BB
where AA.product_id = BB.product_id
group by product_id;