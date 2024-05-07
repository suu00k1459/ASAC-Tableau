use eda01;
-- 과제, kaggle
-- 마우스로 db or table 에서 마우스 우클릭  : table data import wizard ~
-- csv 로 mysql 에서 table data import 할 때 엄청 느리니깐
-- gui 말고, 보통은 쿼리로 하거나
-- ~~ .sql  (dump) 로 처리하는 게 편함
select * From dataset2;

-- 컬럼 설명 
-- clothingID : 상품 관련 코드 번호 (unique value : PK)
-- Age : 리뷰 작성자의 연령
-- title : 작성 리뷰 제목
-- reviw text : 실제 작성한 리뷰 내용.
-- rating : 구매 상품에 대한 평점( 리뷰 작성자가 생각하는 평점) 
-- recommened ~ : 리뷰어가 추천할 것인지에 대한 판단...
-- positive feedb~ : 해당 리뷰가 다른 고객들이 도움이 되었다고 한 사람 수
-- division name : 상품이 속한 division (대분류)
-- department name : 상품이 속한 department (중분류)
-- class name : 상품의 타입정도... (소분류)

# Q1) Division Name의 종류별로 평점의 평균!!!!!! + 평점 내림차순으로 정렬..
select `division Name`, avg(rating) "평균"
from dataset2
group by `division Name`
order by 평균 desc;

# Q.2) Department Name의 종류별로 평점의 평균!!!! + 평점 내림차순으로 정렬..
select `department Name`, avg(rating) "평균"
from dataset2
group by `department Name`
order by 평균 ;

-- 참고) 빈칸의 정체를 확이하려면?
select * from dataset2 where `Department Name` is null;
select count(1) from dataset2 where `Department Name` = "";

# Q.3) Department Name의 값이 Trend인 항목에 대해서,,,
select * 
from dataset2
where `department name` = "Trend";

# Q.4) 3번의 데이터를 나이대별로 처리!!! 10대, 20~~ case when
select * , 
	case when age div 10 = 1 then '10대'
    when age div 10 = 2 then '20대'
    when age div 10 = 3 then '30대'
    when age div 10 = 4 then '40대'
    when age div 10 = 5 then '50대'
    else '그 외'
    end as "연령대"
from dataset2
where `department name` = "Trend";

-- case when ~ end : 정확하게 내가 원하는대로 기준으로 값을 구별!
-- 단점: 규칙의 여지가 있을 때 어떻게/ 약간의 꼼수스러운 여러 함수들을 잘 찾아야 함
select floor(11/10)*10;

# Q5) Trend 항목에 대한 리뷰 평점에 대해서 나이대별로 몇 건인지 확인!!!
select 연령대, count(*)
from (
select * , 
	case when age div 10 = 1 then '10대'
    when age div 10 = 2 then '20대'
    when age div 10 = 3 then '30대'
    when age div 10 = 4 then '40대'
    when age div 10 = 5 then '50대'
    when age is null then "나이 정보 없음"
    else '그 외'
    end as "연령대"
from dataset2
where `department name` = "Trend"
) a
group by 연령대
order by 연령대;

# Q6) Trend 항목에 대한 리뷰 중에서 50대들의 3점 이하의 리뷰들을 출력( 10개만)
select * 
from dataset2
where age div 10 =5
and rating <=3
limit 10;

# Q7) (Deparment and ClothID)의 항목을 기준으로 평점을 계산을 해서..
#     --> 출력 부분은 Deparment, clothID, 평점의 평균
select `department NAme`, `Clothing ID`, avg(rating)
from dataset2
group by `department NAme`, `Clothing ID`
order by `department NAme`,  avg(rating) desc;


# Q8) 랭킹을 하기는 하는데, Department별로 랭킹을 독립적으로 부여를 하고자 함!!
#     랭킹의 산정 기준은 7번에서 했던 평점의 평균-->내림차순,,,
#     --> 출력 : Deparment, clothid, 평점의 평균, 랭킹!!!!!!
select `department NAme`,
 `Clothing ID`,
 avg(rating) "AVG_rating", 
 rank() over(partition by `department name` order by avg(rating) desc) "ranking"
from dataset2
group by `department NAme`, `Clothing ID`
order by `department NAme`,  avg(rating) desc;


# Q9) 8번 문제에서 너무 많은 항목들이 있어서...
#     Department 별로 평점 평균 순위가 Top 10만 출력!!!!!
select * from (
select `department NAme`,
 `Clothing ID`,
 avg(rating) "AVG_rating", 
 rank() over(partition by `department name` order by avg(rating) desc) "ranking"
from dataset2
group by `department NAme`, `Clothing ID`
order by `department NAme`,  avg(rating) desc
) aa
where ranking <=10;


# Q10) Department & 연령대를 기준으로 그룹을 만들어서,, 평점의 평균
#     ---> 출력 : Deparment, 연령대, 평점평균
select `department Name`, concat((age div 10 )*10, "대") "연령대", avg(rating) "평점평균"
from dataset2
group by `department Name`, concat((age div 10 )*10, "대")
order by `department Name`, concat((age div 10 )*10, "대");


# Q11) 연령대별로 생성한 평점평균에 대한 점수를 기준으로 랭킹을 부여!!!!!
select concat((age div 10 )*10,"대") " 연령대", avg(rating), rank() over(order by avg(rating) desc) "순위"
from dataset2
group by concat((age div 10 )*10,"대");

# Q12) 리뷰중에서 size 관련된 언급이 있는 리뷰인지 아닌지 체크용 필드 생성.
#      -> 리뷰 필드에 size라는 단어가 있으면 1, 없으면 0으로 출력!!!
#      -> 출력 : 리뷰, size언급유무
select `Review Text`,
	case when `Review Text` like "%size%" then 1
		else 0
        end as sizeYorN
from dataset2
;

# Q13) 전체 리뷰 데이터 수하고, size가 언급된 리뷰데이터 수 하고 출력!!!!
select count(`Review Text`) "전체 리뷰 데이터 수" , sum(sizeYorN) "사이즈 언급 리뷰데이터 수" 
from (
select `Review Text`,
	case when `Review Text` like "%size%" then 1
		else 0
        end as sizeYorN
from dataset2
) A;

# Q14) 리뷰 중에서 size언급된 리뷰수, large언급된 리뷰수, 
#                loose언급된 리뷰수, small언급된 리뷰수,
#                tight언급된 리뷰수, 전체 리뷰수
select sum(sizeYorN) "size 수" ,
			sum(largeYorN) "large 수" ,
            sum(looseYorN) "loose 수" ,
            sum(smallYorN) "small 수" ,
            sum(tightYorN) "tight 수" 
from (
select `Review Text`,
	case when `Review Text` like "%size%" then 1
		else 0
        end as sizeYorN,
	case when `Review Text` like "%large%" then 1
		else 0
        end as largeYorN,
	case when `Review Text` like "%loose%" then 1
		else 0
        end as looseYorN,
	case when `Review Text` like "%small%" then 1
		else 0
		end as smallYorN,
	case when `Review Text` like "%tight%" then 1
		else 0
		end as tightYorN
from dataset2
) A;

# Q15) 14번의 해당한는 항목들을 Department 별로 보자!!!!!!
select `department Name`,
			sum(sizeYorN) "size 수" ,
			sum(largeYorN) "large 수" ,
            sum(looseYorN) "loose 수" ,
            sum(smallYorN) "small 수" ,
            sum(tightYorN) "tight 수" 
from (
select `department Name`,
	`Review Text`,
	case when `Review Text` like "%size%" then 1
		else 0
        end as sizeYorN,
	case when `Review Text` like "%large%" then 1
		else 0
        end as largeYorN,
	case when `Review Text` like "%loose%" then 1
		else 0
        end as looseYorN,
	case when `Review Text` like "%small%" then 1
		else 0
		end as smallYorN,
	case when `Review Text` like "%tight%" then 1
		else 0
		end as tightYorN
from dataset2
) A
group by `department Name`;
