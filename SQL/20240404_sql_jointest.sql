CREATE DATABASE  IF NOT EXISTS `test_join` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `test_join`;
-- MySQL dump 10.13  Distrib 8.0.17, for Win64 (x86_64)
--
-- Host: localhost    Database: test_join
-- ------------------------------------------------------
-- Server version	8.0.17

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `members`
--

DROP TABLE IF EXISTS `members`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `members` (
  `id` int(11) NOT NULL,
  `first_name` varchar(45) DEFAULT NULL,
  `last_name` varchar(45) DEFAULT NULL,
  `movie_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `members`
--

LOCK TABLES `members` WRITE;
/*!40000 ALTER TABLE `members` DISABLE KEYS */;
INSERT INTO `members` VALUES (1,'Adam','Smith',1),(2,'Ravi','Kumar',2),(3,'Susan','Davidson',5),(4,'Jenny','Adrianna',8),(6,'Lee','Pong',10),(10,'Kwon','MK',5);
/*!40000 ALTER TABLE `members` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `movies`
--

DROP TABLE IF EXISTS `movies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `movies` (
  `id` int(11) NOT NULL,
  `title` varchar(45) DEFAULT NULL,
  `category` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `movies`
--

LOCK TABLES `movies` WRITE;
/*!40000 ALTER TABLE `movies` DISABLE KEYS */;
INSERT INTO `movies` VALUES (1,'ASSASSIN’S CREED: EMBERS','Animations'),(2,'Real Steel(2012)','Animations'),(3,'Alvin and the Chipmunks','Animations'),(4,'The Adventures of Tin Tin','Animations'),(5,'Safe (2012)','Action'),(6,'Safe House(2012)','Action'),(7,'GIA','18+'),(8,'Deadline 2009','18+'),(9,'The Dirty Picture','18+'),(10,'Marley and me','Romance');
/*!40000 ALTER TABLE `movies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'test_join'
--

--
-- Dumping routines for database 'test_join'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-11-04  0:33:38

use test_join;
show tables;

select * from movies;
-- cross join : 양쪽 테이블에서 만들 수 있는 모든 데이터들의 조합!
-- 결합 방식) n: N
-- 방법1) FM  명시적으로 cross join
select * from movies cross join members;
select * from members cross join movies;


-- 방법2) 비공식 : 그냥 나열
select * from movies, members;
select * from members, movies;

-- inner join : 두 테이블에서 모두 정보가 있는 데이터만 보겠다!
-- 여러개를 연결할 때 : 연결 기준으로 반듯이 표현!  ( on )
select * from members inner join movies
	on members.movie_id = movies.id;
    
-- 보려는 정보가 : 고객이 이름, 영화제목만 보도록 하자. (빌려간 고객들만 대상으로)
select ME.first_name, ME.last_name, M.title
from members ME
inner join movies M
on ME.movie_id = M.id;

-- left/ right join : 한 쪽 테이블을 기주능로 다른 테이블을 참조!
-- 정보를 가지고 올 수 있으면, 가지고 오고, 없음 말고!
-- 기준이 되는 쪽의 테이블의 데이터는 누락되지 않는다.(개수는 늘 수 도 있다.)

-- Q) 기준 : 영화 테이블 기준으로, 기준의 위치를 왼쪽으로 세팅
-- => 영화정보를 기준으로 빌려간 고객이 있다면 고객 정보 같이 보자.
select *
from movies aa
left join members bb
on aa.id = bb.id;

-- 주의! ) 1:N 의 연결 구조로 연결되어 있거나, 기준 movies 테이블의 개수가 증가할 수 있음
-- 단, 기존 movies에서 누락된 것은 엇음
-- 전처리를 할 때 주로 활용이 되므로, 늘 하기 전에 체크!

-- Q) 위의 영화정보를 기준으로, 고객 정보가 있으면 보고, 없으면 말고인 상태에서
-- 보려는 항목: 영화 id, 제목, 빌려간 사람의 이름(first, last)

select aa.id, 
	title, 
    first_name, 
    last_name
from movies aa
left join members bb
on aa.id = bb.id;

-- Q) 위와 같은 기능에서 기준이 되는 영화 테이블을 오른 쪽에 세팅하면 쿼리문은?
select bb.id, 
	title, 
    first_name, 
    last_name
from  members aa
right join movies bb
on aa.id = bb.id;

-- Q) 고객들이 무슨 영화를 빌려갔는지 : 구비한 영화들 중에서 시제 대여가 된 것들
-- 	빌려간 고객들이 우리가 구비한 영화들 중에서 무엇을 빌려갔는지 상세정보를 보자
-- 볼 항목 : 고객이름, 영화 제목, 장르

select A.first_name,
	A.last_name,
	B.title,
    B.category
from members A
left join
	movies B
on A.movie_id = B.id;

-- 1) 구매 정보가 있는 고객들의 정보만 같이 보자( 구매이력과 구매한 고객 정보 같이 )
use sqldb;
select * 
From usertbl A 
inner join buytbl B
on A.userID = B.userID;

-- 2) 구매한 고객드르이 정보만 보려고 함
-- 볼 정보 : 고객의 아이디, 고객의 이름, 구매한 상품명, 연락처full, 주소 
select BB.userID,
	BB.name,
    aa.prodName,
    concat(BB.mobile1,'-', substr(BB.mobile2,1,4),'-',substr(BB.mobile2,5,8)) cell_p,
    BB.addr
from buytbl AA
inner join
usertbl BB
on AA.userID = BB.userID;

-- 3) +정렬을 추가
select BB.userID,
	BB.name,
    aa.prodName,
    concat(BB.mobile1,'-', substr(BB.mobile2,1,4),'-',substr(BB.mobile2,5,8)) cell_p,
    BB.addr
from buytbl AA
inner join
usertbl BB
on AA.userID = BB.userID
order by cell_p;


-- 4) 조건을 설정하고 싶음!
-- userID가 jyp인 사람의 구매한 물품에 그 사람에 대한 기본정보만 출력!
-- 필요한 데이터 중에서 : 필터링! where
select BB.userID,
	BB.name,
    aa.prodName,
    concat(BB.mobile1,'-', substr(BB.mobile2,1,4),'-',substr(BB.mobile2,5,8)) cell_p,
    BB.addr
from buytbl AA
inner join
usertbl BB
on AA.userID = BB.userID
where bb.userID = "jyp";

-- 5) 우리 쇼핑몰에 1번이라도 구매한 고객들에게 감사 메일을 보내고자 합니다
-- 	: 어떤 회워들에게 보내야할지 선택해보세요.
-- 	: 출력: ID, 연락처

select U.* 
from (
select distinct userID
from buytbl) B
inner join usertbl U
on B.userID = U.userID;


-- 참고) 결측치에 대한 데이터를 확인을 하려고 함!
-- Q) 우리 사이트에 회원가입은 되었는데, 전혀 구매를 하지 않은 유령회원들에게
-- -->첫 구매시 할인해드릴께요 쿠폰, 알림
-- 코드적) 회원 테이블에는 있는데, 구매 정보는 없는 고객

select *
from usertbl
where userId not in (select distinct userID from buytbl);


select * from usertbl;
select count(1) from usertbl;



select *
from usertbl U
left join buytbl B
on U.userID = B.userID;

select U.userID, U.name, U.addr
from usertbl U
left join buytbl B
on U.userID = B.userID
where B.prodName is null; 

select * from usertbl where userID is null;