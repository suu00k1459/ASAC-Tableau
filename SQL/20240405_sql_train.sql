use train_car;
CREATE TABLE tCar
(
    car VARCHAR(30) NOT NULL,   	 -- 이름
    capacity INT NOT NULL,   		 -- 배기량
    price INT NOT NULL,   		 -- 가격
    maker VARCHAR(30) NOT NULL   	 -- 제조사
);

INSERT INTO tCar (car, capacity, price, maker) VALUES ('소나타', 2000, 2500, '현대');
INSERT INTO tCar (car, capacity, price, maker) VALUES ('티볼리', 1600, 2300, '쌍용');
INSERT INTO tCar (car, capacity, price, maker) VALUES ('A8', 3000, 4800, 'Audi');
INSERT INTO tCar (car, capacity, price, maker) VALUES ('SM5', 2000, 2600, '삼성');

CREATE TABLE tMaker
(
    maker VARCHAR(30) NOT NULL,   	 -- 회사
    factory CHAR(10) NOT NULL,   		 -- 공장
    domestic CHAR(1) NOT NULL   	 -- 국산 여부. Y/N
);

INSERT INTO tMaker (maker, factory, domestic) VALUES ('현대', '부산', 'y');
INSERT INTO tMaker (maker, factory, domestic) VALUES ('쌍용', '청주', 'y');
INSERT INTO tMaker (maker, factory, domestic) VALUES ('Audi', '독일', 'n');
INSERT INTO tMaker (maker, factory, domestic) VALUES ('기아', '서울', 'y');


-- 1) cross join
select * 
from tcar
cross join
tmaker;

-- 2) where 절 사용 회사명 일치하는 것 찾기
select * 
from tcar
cross join
tmaker
where tcar.maker = tmaker.maker;

-- 3) 차이름, 가격, 제조사, 공장만 표시
select car, price, tcar.maker, factory
from tcar
cross join
tmaker
where tcar.maker = tmaker.maker;

-- 4) 차동차 내용은 다 볼거고, 회사 정보는 공장위치만 출력.
select tcar.* , tmaker.factory
from tcar
cross join
tmaker
where tcar.maker = tmaker.maker;

-- 5) inner join활용해서 양쪽 테이블에 모두 있는 정보 출력
select * From tcar c inner join tmaker m on c.maker = m.maker;

-- 6) 아래와 같이 car, price, maker, factory 에 대해서 모든 자동차의 정보가 제조사 정보가 있으면 가져다 붙이기
-- 기준 : 자동차 테이블의 데이터는 유지를 하고, 제조사를 추가적으로..
select * From tcar c left join tmaker m on c.maker = m.maker;

-- 7) 제조사 정보에 대해서 자동차의 정보가 있으면 붙이세요!
-- 기준 : 제조사 테이블을 기준으로 자동차 정보가 있으면 가져 붙이자
select * from tcar c right join tmaker m on c.maker = m.maker;

-- 참고) 위에는 간단히 세팅을 해두어서... join 결과의 데이터의 수가 동일하게 나타남;; 
-- ++ 꼭! `1:N 데이터로 늘어날 수도 있음.


-- 구매이력이 있고, 고객 정보를 같이 보겠다. : inner join
 use sqldb ;
 select distinct u.userID, u.name, u.addr, B.prodname
 from buytbl b inner join usertbl u
 on b.userid = u.userid
 group by u.userid;
 
 -- 주의! distinct는 뒤에 뭐가 있으면 그냥 다 같이 distinct 의 기준으로 함
 -- 괄호를 써서 하나만 지정해도 뒤에 조건들이 같이 걸림
 -- => 목적에 따라서 distinct, group by 등을 잘 활용해서 해야 함.
 
 -- select : 카운팅!
 select * From buytbl group by userid;
 -- group by 하면 데이터가 응축 되니깐, 몇 건...
 select userId, count(*) from buytbl group by userid;
 -- 우회해서 카운팅 할 수 있는 컬럼  변수 1 etc
 select userId, count(num) from buytbl group by userid;
 select userId, count(1) from buytbl group by userid;

-- Q) buytbl 에서 전체 품목이 아니라 항목 전자인 항목( group Name = "전자")에 대해서
-- id별로 구매한 횟수(구매 수량이 아니라 구매 횟수)
select userID, count(num) from buytbl 
where groupName = "전자" 
group by userid;

-- Q) 위의 항목에서 구매횟수가 2인 이상인 고객드란 찾아서 userid 만 출력해주세요
select userID, count(num) '구매횟수'
from buytbl 
where groupName = "전자" 
group by userid
having count(num) >=2;

-- 컬럼명부터 별칭/ 등 다 벡틱 기반으로 하는 게 수월함.

-- where에 대한 조건
-- Q) 지역이 서울이 아닌 데이터들만 보자 not
select * from usertbl where addr != "서울";
select * from usertbl where addr <> "서울";

-- Q) 태어난 년도가 1970 년 1980년도 사이에 고객들은 누구?
-- 시작점, 끝점에 대한 포함 여부에 따라 변형 필요
select * From usertbl where birthyear between 1970 and 1980;

-- Q) 사용자의 id에 ...k를 사용하는 고객들은 누구입니까?
-- mysql 에서 세팅을 대소가리지 않고 해서
-- 엄격할 때는 관련 부분을 체크하고 할 것.
select * from usertbl where userID like '%k%';

-- case when을 활용하는 부분 리뷰
-- Q) 나이대가 유사한 고객들을 구별을 하고 싶음!
-- 	기준 : 년대를 통해서 구별을 좀 묶어주고 싶다. 70년대 80년대 ...
select userid, name, concat(substr(birthyear,3,1)*10,"년대")  as '세대'
from usertbl
group by substr(birthyear,3,1)*10;

select userID, name,
	case when birthyear between 1950 and 1959 then "50년대"
			when birthyear between 1960 and 1969 then "60년대"
            when birthyear between 1970 and 1979 then "70년대"
            when birthyear between 1980 and 1989 then "80년대"
	else "90년대"
    end as '세대'
from usertbl;

-- Q) 위의 결과에서.. 각 세대별로 몇 명이 있나용?
select concat(substr(birthyear,3,1)*10,"년대")  as '세대', count(*)
from usertbl
group by substr(birthyear,3,1)*10;

-- Q) 위의 결과를 보고 3명 이상인 세대들에 대해서 프로모션을 진행하겠다
select concat(substr(birthyear,3,1)*10,"년대")  as '세대', count(*)
from usertbl
group by substr(birthyear,3,1)*10
having count(*) >=3;

select 세대, count(1) cnt
from(
select 
	case when birthyear between 1950 and 1959 then "50년대"
			when birthyear between 1960 and 1969 then "60년대"
            when birthyear between 1970 and 1979 then "70년대"
            when birthyear between 1980 and 1989 then "80년대"
	else "90년대"
    end as '세대'
from usertbl
) aa
group by 세대;

-- 직접 할 수 있고, 이런 식으로 돌려가면서 순차적으로 진행을 할 수도 있음
-- 그 때 그 때 알아서 잘 맞춰서 해야한다.

-- Q) usertbl에서 지역에 대한 정보를 addr 바탕으로 구별 다시 하려고 함
-- 재조정 기준 : 서울, 경기 -> 수도권/ 경북, 경남 -> 경상도/ 그 외 기타지역
-- 기존의 컬럼의 값을 재조정! 출력은 지역 이름, 재조정한 지역 이름명
select * ,
	case when addr in ("서울", "경기") then "수도권"
		    when addr in ("경북", "경남") then "경상도"
            else "기타지역"
            end as "region"
	from usertbl;
    
    -- Q) 지역에 대한 정보를 수도권 : 서울, 경기, 비수도권 : 그외
    -- 해당 재조정된 지역별로 고객의 수는 몇 명인지?
    -- 요약) 우리 고객들이 수도권, 비수도권에 얼마나 가입이 되어 있느닞?
select region, count(1) ,  
from(   
select * 
	,   case when addr in ("서울", "경기")  then "수도권"     
		else "비수도권"     
        end as "region"   
	from usertbl   ) a     
    group by region ;
    
    
-- 예 ) 사용자 중에서 지역이 서울인 사람들의 아이디만 보자.
select userID from usertbl where addr = "서울";
-- 위와 동일한 결과인데, 접근 방식이 다른 부분입니다.
-- 눈에 보이는대로 하면서 뭔가 한 단계씩 할 때, from 안에 서브 쿼리를 넣을 때 별칭
select * from usertbl where addr = "서울";


