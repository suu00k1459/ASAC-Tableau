use shopdb;
show tables;

SELECT * FROM producttbl;

# 1. select 보고자하는 항목들 나열(세로, 컬럼명,,,*) from 소속테이블 where 가로필터링조건
# membertbl 테이블에서 회원이름, 주소만 보여주세요!
select * from memberTBL;
select memberName, memberAddress from memberTBL;

# df.loc[:,["id","address"]]

# 2. 회원테이블에서, 회원이름이 "지운이" 회원의 정보를 조회
select * from membertbl where memberName ="지운이";
# --> 공백주의해서 필터링 조건 해야함.
# --> 체크를 정확히 해야함.
