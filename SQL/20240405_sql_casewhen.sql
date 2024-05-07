use select_train;
CREATE TABLE tCity
(
	name CHAR(10) PRIMARY KEY,
	area INT NULL ,
	popu INT NULL ,
	metro CHAR(1) NOT NULL,
	region CHAR(6) NOT NULL
);

INSERT INTO tCity VALUES ('서울',605,974,'y','경기');
INSERT INTO tCity VALUES ('부산',765,342,'y','경상');
INSERT INTO tCity VALUES ('오산',42,21,'n','경기');
INSERT INTO tCity VALUES ('청주',940,83,'n','충청');
INSERT INTO tCity VALUES ('전주',205,65,'n','전라');
INSERT INTO tCity VALUES ('순천',910,27,'n','전라');
INSERT INTO tCity VALUES ('춘천',1116,27,'n','강원');
INSERT INTO tCity VALUES ('홍천',1819,7,'n','강원');

SELECT * FROM tCity;

CREATE TABLE tStaff
(
	name CHAR (15) PRIMARY KEY,
	depart CHAR (10) NOT NULL,
	gender CHAR(3) NOT NULL,
	joindate DATE NOT NULL,
	grade CHAR(10) NOT NULL,
	salary INT NOT NULL,
	score DECIMAL(5,2) NULL
);

INSERT INTO tStaff VALUES ('김유신','총무부','남','2000-2-3','이사',420,88.8);
INSERT INTO tStaff VALUES ('유관순','영업부','여','2009-3-1','과장',380,NULL);
INSERT INTO tStaff VALUES ('안중근','인사과','남','2012-5-5','대리',256,76.5);
INSERT INTO tStaff VALUES ('윤봉길','영업부','남','2015-8-15','과장',350,71.25);
INSERT INTO tStaff VALUES ('강감찬','영업부','남','2018-10-9','사원',320,56.0);
INSERT INTO tStaff VALUES ('정몽주','총무부','남','2010-9-16','대리',370,89.5);
INSERT INTO tStaff VALUES ('허난설헌','인사과','여','2020-1-5','사원',285,44.5);
INSERT INTO tStaff VALUES ('신사임당','영업부','여','2013-6-19','부장',400,92.0);
INSERT INTO tStaff VALUES ('성삼문','영업부','남','2014-6-8','대리',285,87.75);
INSERT INTO tStaff VALUES ('논개','인사과','여','2010-9-16','대리',340,46.2);
INSERT INTO tStaff VALUES ('황진이','인사과','여','2012-5-5','사원',275,52.5);
INSERT INTO tStaff VALUES ('이율곡','총무부','남','2016-3-8','과장',385,65.4);
INSERT INTO tStaff VALUES ('이사부','총무부','남','2000-2-3','대리',375,50);
INSERT INTO tStaff VALUES ('안창호','영업부','남','2015-8-15','사원',370,74.2);
INSERT INTO tStaff VALUES ('을지문덕','영업부','남','2019-6-29','사원',330,NULL);
INSERT INTO tStaff VALUES ('정약용','총무부','남','2020-3-14','과장',380,69.8);
INSERT INTO tStaff VALUES ('홍길동','인사과','남','2019-8-8','차장',380,77.7);
INSERT INTO tStaff VALUES ('대조영','총무부','남','2020-7-7','차장',290,49.9);
INSERT INTO tStaff VALUES ('장보고','인사과','남','2005-4-1','부장',440,58.3);
INSERT INTO tStaff VALUES ('선덕여왕','인사과','여','2017-8-3','사원',315,45.1);

-- 1. tCity의 모든 값들을 확인하세요
select * from tcity;

-- 2.  tStaff의 모든 값들을 확인하세요
select * from tstaff;

-- 3. tCity의 도시 이름과 인구에 대한 정보를 확인하세요
select name, popu
 from tcity;

-- 4. tCity의 도시이름, 지역, 면적에 대한 정보를 확인하세요.
select name, region, area from tcity;


-- 5.  tStaff의 이름과 월급에 대한 정보를 확인하세요.
select name, salary from tstaff;


-- 6. 직원테이블에서 이름, 부서, 직급만 출력하세요.
select name, depart, grade from tstaff;


-- 7. 도시테이블에서 도시명, 면접(제곱km) 인구(만명)으로 이름이 보이도록 출력하세요.
select name as "도시명", area as "면적(제곱km)" , popu as "인구(만명)" From tcity;

-- 8. 도시테이블에서 name, popu 값에 10000을 곱해서 인구(명)으로 이름이 보이도록 출력하세요.
select name, popu*10000 "인구(명)" from tcity;

-- 9. 도시테이블에서 이름, 면적, 인구와 인구밀도라는 이름으로 (기존의 popu * 10000 / area 로 계산이 되는)것을 보고 나타내도록 하세요.
select name "이름", area "면적", popu "인구밀도", popu*10000/area "인구밀도" from tcity;

-- 10. 도시테이블에서 면적이 1000제곱키로미터 이상인 도시만 출력하세요
select * from tcity where area>=1000;

-- 11. 도시테이블에서 면적이 1000재곱키로미터 이상인 도시의 이름과 면적을 출력하세요.
select name, area from tcity where area>=1000;

-- 12. 인구가 10만명 미만의 도시의 이름을 출력하세요
select name from tcity where popu<10;

-- 13. 전라도에 있는 도시의 정보를 출력하세요
select * From tcity where region = "전라";

-- 14. 월급이 400만원 이상인 직원의 이름을 출력하세요
select * from tstaff where salary>=400;

-- 15. 스탭의 테이블에서 SCORE의 값이 NULL인 정보를 출력하세요
select * from tstaff where score is null;

-- 16. 스탭의 테이블에서 SCORE의 값이 있는 사람들의 정보를 출력하세요.
select * from tstaff where score is not null;

-- 17. 도시테이블에서 인구가 100만이상이면서, 면적이 700제곱키로 이상인 도시를 찾아보세요
select * from tcity where popu>=100 and area >=700;

-- 18. 도시테이블에서 경기권 도시 중에서 인구가 50만명 이상이거나 또는 경기원이 아니고 인구가 50만보다 적더라도 면적이 500이상인 도시를 찾아보세요.
select * from tcity where (region="경기" and popu>=50) or area>=500;

-- 19.  직원 목록에서 월급이 300미만이면서 성취도는 60 이상인 직원이 누구인지 찾아보세요
select * from tstaff where salary<300 and  score >=60;

-- 20. 영업무의 여직원 분들의 이름을 찾아보세요
select * from tstaff where depart = "영업부" and gender ="여";

-- 21.  도시 이름에 ‘천’이 들어가는 도시들을 찾아보세요.
select * from tcity where name like "%천%";


-- 22. 직원 목록에서 성이 “정”씨인 사람들을 찾아보세요
select * From tstaff where name like "정%";

-- 23.  이름에 “신”자가 포함된 직원을 찾아보세요.
select * From tstaff where name like "%신%";

-- 24.  인구가 50~100만 사이인 도시를 찾아보세요.
select * From tcity where popu between 50 and 100;

-- 25. 직원들 중에서 입사일이 2015년부터 2018년 사이의 분들을 찾아보세요
select * from tstaff where year(joindate) between 2015 and 2018;

-- 26. 면적인 50~1000사이의 도시의 목록을 조사하세요
select * from tcity where area between 50 and 1000;

-- 27. 월급이 200만원대의 직원들을 조사하세요.
select * From tstaff where salary>=200 and salary<300;

-- 28. 지역이 경상/전라인 모든 도시를 찾아보세요.
select  * from tcity where region in ("경상", "전라");

-- 29. 인구가 적은 도시부터 출력하세요.
select * from tcity order by area;

-- 30. 지역, 도시이름, 면적, 인구에 대한 것을 지역과 도시 이름에 대해서 정렬해보세요.
select region, name, area, popu from tcity order by region, name;

-- 31. 면적에 의해서 도시들의 정보들을 정렬해보세요.
select * From tcity order by area;

-- 32.  도시이름을 인구수에 따라서 도시의 이름만 출력해보세요.
select name from tcity order by popu;

-- 33. 경기도에 있는 도시만 골라서 면적별로 그 도시의 정보들을 출력해보세요.
select * from tcity where region="경기" order by area;

-- 34. 직원 목록을 월급이 적은 사람부터 순서대로 출력하되, 월급이 같다면 성취도가 높은 사람을 먼저 출력하세요.]
select * from tstaff order by salary, score desc;

-- 35. 영업부 직원을 먼저 입사한 순서대로 정렬하세요.
select * from tstaff where depart = "영업부" order by joindate;

-- 참고: case when 에 대해서 진행
-- 조건이 다양하고, 할 일이 더 복잡할 때 같이 사용
-- 여러 집계 함수도 같이 사용될 수 있음!
-- > 이제는 선택들을 case by case 로 좀 다양하게 하자!

-- 예) buytbl의 내용들 중에서,,, 구매액(price * amount)을 기준으로
-- 	 1500원 이상은 최우수고객, 1000원 이상 ~1500 미만 : 우수고객, 없으면 : 유령고객

use sqldb;
select userID, price * amount from buytbl;
-- 고객 단위로 묶어서 봐야하는 것이고, 누적 구매금액 sum 집계처리
select userID, sum(price * amount) from buytbl group by userID;
-- 누적 금액이 큰 고객을 먼저 보자..
select userID, sum(price * amount) 'totalprice'
from buytbl 
group by userID 
order by 'totalprice' desc;

-- 문제가 구매한 이력이 없는 유령고객은 나타나지 않음
-- ++ 구매이력이 있따면, 총 구매금액, 혹 구매이력이 없다면, 없는대로 고객정보는 보자
select U.userID, U.name, sum(B.price * B.amount) as'totalprice'
from buytbl B
right join usertbl U
on B.userID = U.userID
group by B.userID, U.name 
order by 'totalprice' desc;

-- case when
select U.userID, U.name, sum(B.price * B.amount) as'totalprice',
	case when (sum(price* amount) >=1500) then "VVIP"
		 when (sum(price* amount) >=1000) then "VIP"
         when (sum(price* amount) >=1) then "Basic"
         else "ghost"
         end as "cust"
from buytbl B
right join usertbl U
on B.userID = U.userID
group by B.userID, U.name 
order by 'totalprice' desc;

-- 해결방법1) 그냥 원천 컬럼이 있는 것들을 귀찮아도 연산식을 계속 when에 넣어서 처리!
--         원본 컬럼명으로 sql이 직접적으로 추적을 해서 값을 가지고 올 수 있어서!
-- 해결방법2) 자기 자신을 돌려서 처리하는 방식이 있음!
--         기존 컬럼들을 대상으로 1차 가공하고, 다시 그 대상으로 2차 가공을 할 때.. 순서적으로 진행할 때 자기 참조...
--         mysql 에서는 자기참조에 대한 별칭을 꼭 세팅해줘야함.

-- 눙에 보였던 컬럼이 명시적으로 존재함. 이제 컬럼명 가져다 쓸 수 있음!

select *,
case when (totalprice >=1500) then "VVIP"
		 when (totalprice >=1000) then "VIP"
         when (totalprice >=1) then "Basic"
         else "ghost"
         end as "customerClass"
from (
	select U.userID, U.name, sum(B.price * B.amount) as'totalprice'
	from buytbl B
	right join usertbl U
	on B.userID = U.userID
	group by B.userID, U.name 
	order by 'totalprice' desc) A;
    
-- 1) 필요한 정보들 세팅/ 소스
-- 2) 필요한 정보들에 대한 출력
-- 3) 부가적이 정보들이 있으면 가져다 붙이고, 조건...
-- 4) 위의 내용을 기반으로 다시 뭔가 작업을 해야한다
-- 	3번까지 내용이 새로운 게산으로 만들어진 것을 활용해서 게산
--     눈에 보이는 테이블을 명시적인 테이블로 만들어서 활용하면서 추후 진행
--     --> 금액들 중심으로 고객 분류!
--     --> 눈에 보이는 테이블을 명시화해서 쓸 때 : from A : 참조문자 꼭 !
-- 5) 필요한 정보들을 순차적으로 하나씩 해결해나간다!
-- select * From ()a, ()B...(()d,()e)c


