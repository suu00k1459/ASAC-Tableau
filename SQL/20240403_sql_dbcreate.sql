drop database if exists sqldb; -- 만약 기존에 sqldb가 있다면 우선 삭제!!
create database sqldb;
use sqldb;
create table usertbl( 
	userID char(8) NOT NULL PRIMARY KEY, -- id컬럼 :PK
	name varchar(10) NOT NULL,           -- 이름
    birthYear int not null,              -- 출생년도
    addr char(2) not null,               -- 지역(경기, 서울)
    mobile1 char(3),                     -- 휴대폰 앞자리
    mobile2 char(8),                     -- 휴대폰 뒤에..
    height smallint,                     -- 키
    mDate DATE                           -- 회원 가입일..
);

create table buytbl (
	num int auto_increment not null primary key, -- 순번
    userID char(8) not null, -- 아이디 FK : 밑에 어디와 연결하는지 세팅..
    prodName char(6) not null,  -- 상풍명
    groupName char(4),          -- 분류
    price int not null,         -- 가격
    amount smallint not null,   -- 
    foreign key( userID ) references usertbl(userID)
);

INSERT INTO usertbl VALUES('LSG', '이승기', 1987, '서울', '011', '1111111', 182, '2008-8-8');
INSERT INTO usertbl VALUES('KBS', '김범수', 1979, '경남', '011', '2222222', 173, '2012-4-4');
INSERT INTO usertbl VALUES('KKH', '김경호', 1971, '전남', '019', '3333333', 177, '2007-7-7');
INSERT INTO usertbl VALUES('JYP', '조용필', 1950, '경기', '011', '4444444', 166, '2009-4-4');
INSERT INTO usertbl VALUES('SSK', '성시경', 1979, '서울', NULL  , NULL      , 186, '2013-12-12');
INSERT INTO usertbl VALUES('LJB', '임재범', 1963, '서울', '016', '6666666', 182, '2009-9-9');
INSERT INTO usertbl VALUES('YJS', '윤종신', 1969, '경남', NULL  , NULL      , 170, '2005-5-5');
INSERT INTO usertbl VALUES('EJW', '은지원', 1972, '경북', '011', '8888888', 174, '2014-3-3');
INSERT INTO usertbl VALUES('JKW', '조관우', 1965, '경기', '018', '9999999', 172, '2010-10-10');
INSERT INTO usertbl VALUES('BBK', '바비킴', 1973, '서울', '010', '0000000', 176, '2013-5-5');
INSERT INTO buytbl VALUES(NULL, 'KBS', '운동화', NULL   , 30,   2);
INSERT INTO buytbl VALUES(NULL, 'KBS', '노트북', '전자', 1000, 1);
INSERT INTO buytbl VALUES(NULL, 'JYP', '모니터', '전자', 200,  1);
INSERT INTO buytbl VALUES(NULL, 'BBK', '모니터', '전자', 200,  5);
INSERT INTO buytbl VALUES(NULL, 'KBS', '청바지', '의류', 50,   3);
INSERT INTO buytbl VALUES(NULL, 'BBK', '메모리', '전자', 80,  10);
INSERT INTO buytbl VALUES(NULL, 'SSK', '책'    , '서적', 15,   5);
INSERT INTO buytbl VALUES(NULL, 'EJW', '책'    , '서적', 15,   2);
INSERT INTO buytbl VALUES(NULL, 'EJW', '청바지', '의류', 50,   1);
INSERT INTO buytbl VALUES(NULL, 'BBK', '운동화', NULL  , 30,   2);
INSERT INTO buytbl VALUES(NULL, 'EJW', '책'    , '서적', 15,   1);
INSERT INTO buytbl VALUES(NULL, 'BBK', '운동화', NULL   , 30,   2);

-- ----------------------
show tables;
select * from buytbl;
select * from usertbl;
select * from usertbl where name = "김경호";


-- 1) 이름이 김범수인 사람의 모든 정보를 찾기
select * 
from usertbl
where name ="김범수";

-- 2) 이름이 조관우인 사람의 모든 정보 찾기
select * 
from usertbl
where name ="조관우";

-- 3) 주소지가 서울인 사람 찾기
select * 
from usertbl
where addr ="서울";

-- 4) 출생년도가 1973년도인 사람들 찾기
select * 
from usertbl
where birthYear =1973;

-- 5) mobile1의 정보가 없는 사람의 정보 찾기
select *
from usertbl
where mobile1 is null;

-- where에 들어가는 여러 조건들 사이의 관계 지정
-- 예) 고객들 중에서 1970이후에 태어나신 분 들 중에서
-- 	  키가 182 이상인 고객들에 한해서 이벤트를 알림하겠다.
--    볼 항목 : userID, Name
select userid, name from usertbl where birthyear >=1970;


-- 1) 주소지가 서울인 사람들 모두 조회
select *
from usertbl
where addr = "서울";

-- 2) 주소지가 서울이면서 핸드폰 번호 앞자리가 011인 사람
select * 
from usertbl
where addr = "서울"
and mobile1='011';

-- 3) 주소지가 서울이면서, mobile1의 번호를 011 을 사용하는 사람의 userID, name, mobile1, mobile2 번호 조회
select userID,
	name,
	mobile1,
	mobile2
from usertbl
where addr = "서울"
and mobile1='011';

-- 조건이 '숫자' 연속된 범위  1) 부등식 여러개, 2) between A and B
-- 예) 키가 180에서 183 사이 --> 이름, 키 정보를 봅시다.
select name, height from usertbl where height between 182 and 185;

-- 조건이 항목값들 (지역) : 여러 지역에 대한 조건
-- 예) 수도권 : 서울, 경기에 사는 고객들을 선택,,, 이름, 주소만 보자
select name, addr from usertbl where addr = "서울" or addr = "경기";
select name, addr from usertbl where addr in ("서울", "경기");

-- 문자열에 검색 1) 정확한 매칭 = "~~"
-- 			  2) 유사 검색 : like % 
-- 예) 고객들 중에 김씨인 사람은?
select * from usertbl where name like "김%";

-- 예) 고객 중에 김씨고 외자인 사람은?
select * from usertbl where name like "김_";

-- 예) 고객 중에 2번째 이름이 용인 사람은?
select * from usertbl where name like "_용%";

-- 정리) where을 통해서 하고자 하는 일을 필터링!
-- 	필터링 조건을 작성하는 과정에서
-- 	정확하게 값으로 조건을 할 때 : = 값(is null)
--     조건이 여러개 : and, or, not etc
-- 		효율적으로 작성하는 부분 값이 숫자 : between A and B
-- 							항목값들 : in (항목1 , 항목2...)
-- 							문자열 유사검색 : like "%김_"

-- 기본적으로 1개 쿼리문에서 1개 조건, 여러 조건
-- 서브 쿼리 : 쿼리 속 쿼리
-- 예) 고객 이름의 김경호인 고객의 키보다 크거나 같은 사람들의 이름과 키를 출력해주세요!
select name,
	height
from usertbl
where height >=(select height from usertbl where name ="김경호");

-- 예) 키가 177 이상인 사람들의 이름과 키를 출력해주세요
select name,
	height
from usertbl
where height>=177;

-- 예) 키가 김경호보다 큰 사람을 출력해주세요.
select *
from usertbl
where height >= (select height from usertbl where name = "김경호");

-- 예) 지역이 경남이 사람의 키보다 큰 사람의 이름과 키의 값을 찾아주세요!
select name,
	height
from usertbl
where height>= (select avg(height) from usertbl where addr="경남" group by addr);
-- 서브 쿼리가 값이 여러개면 에러가 발생
-- 명확하게 여러개의 값이 올 때 선택해야함
-- any : 서브쿼리 나온 결과가 여러개가 있을 때 여러 개 중 하나라도 만족하면 가능! in()!
-- all : 서브 쿼리 나온 결과가 나온 결과가 모두 만족해야만 함
select height from usertbl where height > any ( -- 173, 170 둘 중 아무꺼나 초과
	select height from usertbl where addr= "경남");
    
select height from usertbl where height > all( -- 173, 170 모두 초과하는 경우
	select height from usertbl where addr= "경남")
  
-- 서브쿼리를 활용해서 any 를 하더라도
-- 서브쿼리가 명확하게 컴팩트하지 않으면 에러가 발생함

# 정렬 : 워하는 기준에 맞춰서 정렬해서 출력을 하고 싶을 때
-- order by 기준들
-- 기본 정렬 기준 : 오름차순이 기보 ASC (ascending) -생략 가능
-- 내림 차순 정렬 : DESC (descending)

-- 예) 고객들이 가입한 날짜 순서대로 고객의 이름과 가입 날짜 조회!
-- 중요! 정렬을 할 대상이 먼저 세티잉 되어야 함. => 정렬을 옵션
select name, mDate from usertbl; -- 필요한 정보 세팅!
select naem, mDate from usertbl order by ;

-- 예) 고객 정보들 중에서 이름과 키만 보고자 합니다.
-- 	  키는 내림차순, 키가 동일하면 이름 오름차순으로 보고 싶음)
select * from usertbl order by height desc, name;

-- 예) 키 순서대로 오름차순으로 하고, 보고자하는 항목은 그 고객의 id만 보여줘
select userID, height from usertbl order by height;

-- 중복된 값을 제거하고 유니크한 값들만 뭔가 할 때: distinct 
select distinct addr from usertbl;

-- 출력 갯수 제한 : limit
-- limit N;

use employees;
-- 예) 고용테이블에서 사번과 입사날짜만 보려고 함
--     입사 일자 기준으로 오름차순으로 보여줘
select emp_no, hire_date from employees order by hire_date asc limit 5;

-- 테이블을 복사 : 앞에서 진행을 했던 쿼리문!
-- create table ~~ select ~~
-- 테이블에서 선택한 내용들을 다른 테이블로 복사
-- create table 새로운테이블명 (select 복사할 내용 from 원본 테이블 );
-- 주의 사항 ) 원본테이블 PK, FK - >복사가 안됨. 제약 조건은 복사 안됨
use sqldb;

-- 특정한 컬럼들만(userid, 상품이름) 따로 테이블로 만들어서 하고 싶다!

