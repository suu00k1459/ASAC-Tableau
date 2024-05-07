-- 순위 관련 정보 : 랭킹 부여!
-- + 비교 : topN (그냥 보여주는 개수, 등수를 부여하는 것은 아님)
-- order by ~~limit N
-- + 명확하게 너는 몇 등이다 라는 정보를 생성하려고 할 때 : 랭킹!
-- 랭킹을 정하기 위해서는 "기준 값"
-- 1) 동일한 값에 대해서 다른 등수로 랭킹을 하겠따. : row_number()
-- 		100, 150, 200, 200, 300 : 1등, 2등, 3등, 4등, 5등
-- 2) 동일한 값에 대해서 같은 등수를 부여할지..
-- 2-1) 같은 값을 다음 값의 랭킹으로 연속되어 사용 : dense_rank()
-- 		100, 150, 200, 200, 300 : 1등, 2등, 3등, 3등, 4등
-- 2-2) 같은 값을 다음 값의 랭킹으로 점프해서 할 때 : rank()
-- 		100, 150, 200, 200, 300 : 1등, 2등, 3등, 3등, 5등
-- 추가 ) n-tile : n%의 데이터들을 활용할 때 : 순위는 아니지만 비율..

use employees;

select * from employees;-- 사원정보
select * from salaries ; -- 월급 정보

-- 사원 정보와 월급 정보를 같이 보자
select * from salaries s left join employees e
	on s.emp_no = e.emp_no;
-- emp_no 중복된다
-- join 것으로 기준, 컬럼명에 같은 경우가 있으면, 바로 안 들어감
-- 컬럼명 변경하거나, 필요한 것들은 정확히 나열
create table temp (select E.emp_no, e.first_name, E.last_name, E.gender, s.salary
	from salaries s left join employees e
    on s.emp_no = e.emp_no) ;
    
    -- salary 를 기준으로 랭킹을 부여
    -- 1) 고액 연봉 순으로 랭킹을 부여
    
    
    select emp_no, first_name, last_name, salary,
		row_number() over (order by salary desc) "rank"
        from temp;
	-- 65! 67 : 65,66,67,68 : 단순 숫자 값을 증가 시킴!
    
    -- 참고) n-tile 데이터들을 덩어리로 구별
    select emp_no, first_name, last_name, salary,
    ntile(5) over(order by salary desc) `ntil-5`
    from temp;
    
    -- ++ partion by : 동일한 사변에 대해서 (직원별로) 그 직원의 연봉의 랭킹을 부여하고 싶다.
select emp_no, first_name, last_name, salary, 
	rank() over(partition by emp_no order by salary desc) `rank`
    from temp;