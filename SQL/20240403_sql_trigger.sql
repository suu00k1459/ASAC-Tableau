use shopdb;
show tables; 
select * from meberTBL;
select * from producttbl;


# 사용하려는 DB 선택 
use shopdb;
-- select
select * from membrtbl;

# 참고  :BACKTICT(`): 키보드 ~ 랑 같이 있느 애
-- `` : 테이블명에 공백이 있을 때
-- 원래 : select * from table name
-- 띄워져 있을 때 : select * from `table name'

# 참고 : 불필요한 테이블 삭제 ( 완전 삭제 ) : drop
drop table `table name`;
-- 꼭 select 에서만 사용하는 것은 아님
-- 전반적인 sql 쿼리문에서 다 적용 가능
use employees;
### 인덱스 처리 관련 부분
create table indextbl (
	first_name varchar(14), 
    last_name varchar(14),
    hire_data date
);

Insert into indextbl
	select first_name, last_name, hire_date
    from employees
    limit 500;

select * from indextbl;

-- 원본 db는 엄청 많은 사람의 데이터/레코드가 존재
-- 혹시 이름이 Mary(first_name) 조회 해보기
select * from indextbl where first_name = "Mary";

# 전체 데이터에 스캔!
-- 혹시 이 부분에 대한 속도가 중요하다면
-- 이 컬럼을 미리 색인, 인덱스 작업을 해두면 됨!
-- 할 일 : first_name 컬럼을 미리 색인 작업을 하겠다.

create index idx_indextbl_firstname on indextbl(first_name);

# 기존은 그대로 두고
-- 새롭게 indxtbl 의 first_name 컬럼에 인덱스가 된
-- indx_indextbl_firstname 인덱스 이름
select * from indextbl where first_name ="Mary";


# 뷰
create view uv_membertbl as 
select membername, memberaddress from shopdb.membertbl;

select * from uv_membertbl;

# 기타 : sql 쿼리문 하나가 아니라 덩어리로 묶어서 할 수 있음
# --> 스토어드 프로시져
# (블럭단위로 코드 실행, 전채 묶어서 실행.py)
# --> 매주 보고, 매달
# 상황 : 매번 회원 테이블에서 이름이 당탕이 정보
-- 			제품 테이블에서 냉장고 정보를 동시조회
select * From membertbl where memberName = "당탕이";
select * from producttbl where productName = "냉장고";

use shopdb;
# 매번 여러 쿼리를 사용하기 귀찮을 때
# 하나의 스토어드 프로시저
DELIMITER //
create procedure myProc()
begin
	select * From membertbl where memberName = "당탕이" ;
	select * from producttbl where productName = "냉장고" ;
end //
DELIMITER ; # delimiter는 공백 띄우고 ;  사용

# 여러번 사용할 때 drag대신 프로시저로 묶어서 사용하자.

# 트리거 : 데이터, 테이블에 대한 변경 모니터링
select * from membertbl;
insert into membertbl values ("Figure", "연아", "경기도 군포시 당정군");
select * from membertbl;
desc membertbl;

# 회원정보 수정 update
update membertbl set memberAddress='서울 강남구 역삼동' where memberName ='연아';


데이터 삭제
delete from membertbl where memberID = "Fiugire"; 
select * from membertbl;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             




create table deletemembertbl(
	memberID char(8),
    memberName char(5),
    memberAddress char(20),
    deletedDate DATE -- 삭제한 날짜.
);
# --> 특정한 이벤트가 발생할 때만다 데이터가 자동으로 기록을 하도록 설정!!!!

DELIMITER //
create trigger trg_deletedmembertbl -- 트리거 이름
	after delete -- delete 쿼리문이 실행하고 나서,,,(관찰 이벤트)
    on membertbl -- 트리거를 부착할 테이블을 지정...(관찰 대상)
    for each row  -- 각 가로줄 마다 적용하겠다!!!!!
begin
	-- 할 일 : 기존 테이블의 내역을 deletedmembertbl에 기록
    insert into deletemembertbl 
			value ( old.memberID, 
				    old.memberName,
                    old.memberaddress,
                    CURDATE() );
    
end //
DELIMITER ;

# ---> test
delete from membertbl where memberName="당탕이";

select * from membertbl;
select * from deletemembertbl;

-- 테이터 베이스 관련해서 저장을 할 때 : data export( 폴더 구조, 1개 sql파일)
-- 복원할 때도 어느 양식(폴더구조, sql 파일) : 어디로 복원할 것인가 선택!
-- dump
-- 모델, 파일들로 save.load 

use employees;
select * from employees;
-- employees 테이블에서 first_name, last_name, gender
select first_name, last_name, gender From employees;
show tables;
desc employees;

-- 상황 : 사원들에 생일 관련 이벤트를 하고자 함
-- 필요 정보 : 생일, 이름(전체 다 확인), 입사일

select * from employees;
select birth_date, hire_date, first_name, last_name from employees;

# ckarh
show table status; -- table 은 단수명  : show tables(복수)

-- as : 별명을 생성하는 기능! 출력용으로도 많이 사용되는 것
select first_name as 이름, last_name as 성, gender as 성별 from employees;


