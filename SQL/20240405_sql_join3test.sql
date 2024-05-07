USE sqldb;
CREATE TABLE stdtbl 
( stdName    VARCHAR(10) NOT NULL PRIMARY KEY,
  addr	  CHAR(4) NOT NULL
);
CREATE TABLE clubtbl 
( clubName    VARCHAR(10) NOT NULL PRIMARY KEY,
  roomNo    CHAR(4) NOT NULL
);
CREATE TABLE stdclubtbl
(  num int AUTO_INCREMENT NOT NULL PRIMARY KEY, 
   stdName    VARCHAR(10) NOT NULL,
   clubName    VARCHAR(10) NOT NULL,
FOREIGN KEY(stdName) REFERENCES stdtbl(stdName),
FOREIGN KEY(clubName) REFERENCES clubtbl(clubName)
);
INSERT INTO stdtbl VALUES ('김범수','경남'), ('성시경','서울'), ('조용필','경기'), ('은지원','경북'),('바비킴','서울');
INSERT INTO clubtbl VALUES ('수영','101호'), ('바둑','102호'), ('축구','103호'), ('봉사','104호');
INSERT INTO stdclubtbl VALUES (NULL, '김범수','바둑'), (NULL,'김범수','축구'), (NULL,'조용필','축구'), (NULL,'은지원','축구'), (NULL,'은지원','봉사'), (NULL,'바비킴','봉사');

#########################3
use sqldb;
show tables;

-- Q) 3개 테이블 활용, 학생이름 , 지역, 가입한 동아리, 동아리방 호수를 출력해보기
-- 비교) 앞에 했던 부분과 차이점, 가져올 정보가 (학생, 동아리, 연결)
-- 	차이점은 2개씩 묶어서 확장을 해야 함( 연결 관계가 복잡!)

select * from stdtbl;
select * from clubtbl;
select * from stdclubtbl;

select s.stdName, s.addr, sc.clubName, c.roomNo
from stdtbl s
inner join stdclubtbl sc
on s.stdName  = sc.stdName
inner join clubtbl c
on sc.clubName = c.clubName
order by s.stdName;
-- 내가 필요한 정보들이 여러 테이블에 있어서,
-- 기준을 생각해서 1개씩 붙여 나가시면 됨.

-- Q) 모든 학생들에 대해 가입한 동아리가 있다면 가입한 동아리 이름, 방번호 같이 출력
-- (가입하지 않은 학생의 정보도 같이 나오게)
-- => 출발(기준) : 학생테이블 기준, 동아리정보가 있으면 참조
select s.*,
	sc.clubName,
	c.roomNo
	from stdtbl s
		left join stdclubtbl sc
			on s.stdName = sc.stdName
		left join clubtbl c
			on sc.clubName = c.clubName ;
            
-- 결론 : 