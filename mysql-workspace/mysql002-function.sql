/*====================================================================
일반함수
ifnull(컬럼, 대체값) : 첫번째 인자값이 null이면 0으로 대체해서 출력한다.
if(컬럼, 대체1, 대체2) : 컬럼의 값이 null아니면 대체1로, null이면 대체2로 출력한다. 
nullif(표현식1, 표현식2 ) : 표현식1과 표현식2가 같으면 NULL, 다르면 표현식1로 출력한다.

--대체할 값이 숫자이면 두번째 인자값에 숫자를 지정한다.
--대체할 값이 문자이면 두번째 인자값에 문자를 지정한다.
--대체할 값이 날짜이면 두번째 인자값에 날짜를 지정한다. 
=======================================================================*/

/*================================
case when 조건1 then 결과1
     when 조건2 then 결과2
     when 조건3 then 결과3
     else 결과n
end AS alias;
자바에서 if-else와 비슷한 의미
==================================*/
-- department_id이 10이면 'ACCOUNTING', 20이면 'RESEARCH', 
--                30이면 'SALES', 40이면 'OPERATIONS', 'OTHERS'


SELECT first_name, department_id,
	CASE department_id
		WHEN 10 THEN 'ACOUNTIMG'
		WHEN 20 THEN 'RESEARCH'
		WHEN 30 THEN 'SALES'
		WHEN 40 THEN 'OPERATIONS'
		ELSE 'OTHERS'
	END AS 'deptname'
FROM employees ;

-- dayofweek() : 1 일요일...7토요일
-- 입사일을 이용해서 한글로 요일을 출력하시오.
SELECT  first_name, hire_date,
	CASE dayofweek(hire_date)
		WHEN 1 THEN '일'
		WHEN 2 THEN '월'
		WHEN 3 THEN '화'
		WHEN 4 THEN '수'
		WHEN 5 THEN '목'
		WHEN 6 THEN '금'
		WHEN 7 THEN '토'
	END as'요일'
FROM employees ;

-- 직급이 'PR_REP' 인 사원은 5%, 'SA_MAN'인 사원은 10%, 
-- 'AC_MGR'인 사원은 15%, 'PU_CLERK' 인 사원은 20% 를 인상 
SELECT job_id, salary,
	CASE job_id
		WHEN 'PR_REP' THEN salary *1.05
		WHEN 'SA_MAN' THEN salary *1.1
		WHEN 'AC_MGR' THEN salary *1.15
		WHEN 'PU CLERK' THEN salary *1.2
	END AS newsal
FROM employees ;

-- 입사일에서 월이 1-3이면 '1사분기', 4-6이면 '2사분기', 
--              7-9이면 '3사분기', 10-12이면 '4사분기'
-- 로 처리를 하고 사원명(first_name), 
-- 입사일(hire_date), 분기로 출력하시오.
SELECT first_name, hire_date,
      CASE
          WHEN MONTH(hire_date) <= 3 THEN '1사분기'
          WHEN MONTH(hire_date) <= 6 THEN '2사분기'
          WHEN MONTH(hire_date) <= 9 THEN '3사분기'
          WHEN MONTH(hire_date) <= 12 THEN '4사분기'
      END AS '분기'
FROM employees;

/*=================================================
집계함수(Aggregate Function), 그룹함수(Group Function)
https://dev.mysql.com/doc/refman/8.4/en/aggregate-functions.html#function_max
===================================================*/

-- max(컬럼) : 최대값
SELECT max(salary)
FROM employees;

-- min(컬럼) : 최소값
SELECT min(salary)
FROM employees;


SELECT count(COMMISSION_PCT)
FROM employees;


SELECT count(*)
FROM employees;

-- sum(컬럼) : 합계
SELECT sum(salary)
FROM employees;

-- avg(컬럼) : 평균
SELECT avg(salary)
FROM employees;

-- 집계함수와 단순 칼럼은 출력되는 레코드 수가 다르기 때문에 함께 사용할 수 없다.
SELECT first_name, count(*)
FROM employees;

-- 집계함수와 단순컬럼을 사용하기 위해서는 단순컬럼을 그룹화 해야 한다.( GROUP BY)
SELECT department_id, count(*)
FROM employees
GROUP BY department_id;

-- 50이하인 부서에 대해서 NULL이 아닌 부서별의 직원수를 출력하시오.
SELECT department_id, count(employee_id)
FROM employees 
WHERE department_id <=50
GROUP BY department_id ;

SELECT department_id, count(*)
FROM employees 
WHERE department_id <=50
GROUP BY department_id ;

SELECT department_id, count(*)
FROM employees 
GROUP BY department_id 
HAVING department_id <= 50 ;


-- 업무별(job_id) 급여합계를 출력하시오.
SELECT job_id, sum(salary)
FROM employees 
GROUP BY job_id;

-- 부서별 최소급여, 최대급여가 같지 않을때만  부서, 부서최소급여, 부서최대급여을 부서별 오름차순으로 출력하시오.
SELECT department_id, min(salary), max(salary)
FROM employees 
GROUP BY department_id 
HAVING min(salary) != max(salary) 
ORDER BY department_id ASC;

/*--------------------------
시스템 함수
----------------------------*/
 -- 현재 사용자와 현재 선택된 데이터베이스
 -- user() = current_user() = dsession_user()
 -- datebase() = schema()
SELECT user(), database();  -- root@localhost	myxedb

--select문에서 조회된 행의 개수를 구함
-- found_rows( )
SELECT * FROM employees;
SELECT found_rows();

 -- 바로 앞의 INSERT, UPDATE, DELETE문에서 입력, 수정, 삭제된 행의 갯수를 구함
 -- CREATE, DROP문은 0을 반환하고, SELECT문은 -1을 반환한다.
 -- row_count()
*DELETE FROM employees
WHERE 1=0 ;
SELECT row_count();

--현재 mysql의 버전을 구한다(mysql에서 제공하는 )
SELECT version();

 
/*=======================================================
join : 여러개의 테이블에서 원하는 테이블을 추출해주는 쿼리문이다.
모든 제품에서 공통적으로 사용되는 표준(ANSI) join이 있다.
========================================================*/

-- 1. cross조인 = carteian product(카티션 곱) 조인 : 
--   테이블 행의 갯수만큼 출력해주는 조인이다.

SELECT count(*) FROM employees ; -- 107
SELECT count(*) FROM department ; -- 27
SELECT 107*27 ; 

SELECT e.department_id, d.department_id, e.first_name
FROM employees e CROSS JOIN departements d ;
FROM employees 

/*
 2. inner join
    가장 많이 사용되는 조인방법으로 조인 대상이 되는 두 테이블에서 공통적으로 존재하는 컬럼의 값이
    일치되는 행을 연결하여 결과를 생성하는 방법이다.
 */
SELECT e.department_id, e.first_name
FROM employees e INNER JOIN jobs j
ON e. job_id = j. job_id ; -- 공통 칼럼 명시

SELECT e.department_id, e.first_name, d.department_name 
FROM employees e INNER JOIN departments d
ON e. job_id = d. department_id ; -- 공통 칼럼 명시 / 관계설정되어있음=공통된 칼럼이 있음 / on -표준제공 방식

SELECT e.department_id, e.first_name, e. job_id, j.job_title
FROM employees e , job_id j
WHERE e. job_id = j.job_id ;  -- ?



-- employees와 departments테이블에서 사원번호(employee_id),
-- 부서번호(department_id), 부서명(department_name)을 검색하시오.
SELECT e.employees_id, d.department_name, d. department_name 
FROM employees e INNER JOIN departments d
ON e. job_id = d. department_id ; --?

SELECT e. employees_id, d.department_name, d. department_name 
FROM employees e , departments d
WHERE e. department_id = d. department_id ; -- ?


-- employees와 jobs테이블에서 사원번호(employee_id),
-- 업무번호(job_id), 업무명(job_title)을 검색하시오.
SELECT e.employee_id, j.job_id, j. job_title
FROM employees e INNER JOIN jobs j
ON e.job_id = job_id  

SELECT e.employee_id, j.job_id, j.job_title
FROM employees e, jobs j
WHERE e.job_id = j.job_id; 


-- job_id가 'FI_MGR'인 사원이 속한
 -- 급여(salary)의 최소값(min_salary), 최대값(max_salary)을 출력하시오. 
SELECT e.salary, j.min_salary, j.max_salary
FROM employees e INNER JOIN jobs j
ON e.job_id = j.job_id
WHERE j.job_id = 'FI_MGR';

SELECT e.salary, j.min_salary, j.max_salary
FROM employees e, jobs j
WHERE e.job_id = j.job_id
AND j.job_id = 'FI_MGR';

-- 부서가 'Seattle'에 있는 부서에서 근무하는
-- 직원들의  first_name, hire_date, department_name, city
-- 출력하는 SELECT을 작성하시오.
SELECT e.first_name, e.hire_date, d.department_name, l.city
FROM employees e INNER JOIN departments d   ON e.department_id = d.department_id 
                 INNER JOIN locations l     ON d.location_id = l.location_id
WHERE l.city ='Seattle'; 

SELECT e.first_name, e.hire_date, d.department_name, l.city
FROM employees e, departments d, locations l
WHERE e. dpartment_id  = d. department_id 
	AND d. location_id = l.location_id
	AND l.city = 'Seattle';  -- ?

-- 20번 부서의 이름과 그 부서에 근무하는 사원의 이름(first_name)을 출력하시오.
 SELECT d.department_name, e.first_name
 FROM departments d INNER JOIN employees e 
 ON d.department_id = e.department_id 
 WHERE d.department_id=20;
 
 SELECT d.department_name, e.first_name
 FROM departments d , employees e 
 WHERE d.department_id = e.department_id 
   AND d.department_id=20;

 -- 1400, 1500번 위치의 도시이름과 그 곳에 있는 부서의 이름을 출력하시오.  
 SELECT location_id, city
 FROM locations
 WHERE location_id IN (1400, 1500) ;
 
SELECT l.city, d.department_name
FROM locations l INNER JOIN departments d 
ON  l.location_id = d.location_id 
WHERE l.location_id IN(1400, 1500);

SELECT l.city, d.department_name
FROM locations l,  departments d
WHERE  l.location_id = d.location_id
AND l.location_id IN(1400, 1500);

/*=================================================================
3. outer join
  한 테이블에는 데이터가 있고 다른 반대쪽에는 데이터가 없는 경우에
  데이터가 있는 테이블의 내용을 모두 가져오는 조건이다.
  ===============================================================*/

SELECT *
FROM employees e LEFT OUTER JOIN departments d
ON e.department_id = d. department_id;

SELECT e.first_name, e.salary, d.department_name
FROM employees e LEFT OVER JOIN departments d
ON e.department_id = d. dpartment_id;

SELECT e.first_name, e.salary, d.department_name
FROM employees e RIGHT OVER JOIN departments d
ON e.department_id = d.dpartment_id;
--
SELECT e.first_name, e.salary, d.department_name
FROM employees e LEFT OUTER JOIN departments d
ON e.department_id = d.department_id;

SELECT e.first_name, e.salary, d.department_name
FROM employees e RIGHT OUTER JOIN departments d
ON e.department_id = d.department_id;

/*=================================================
4. self join
 하나의 테이블을 두개의 테이블로 설정해서 사용하는 조인방법이다.
 하나의 테이블에 같은데이터가 두개의 컬럼에 다른 목적으로 저장되여 있는 경우
 employees, employee_id, manager_id
====================================================*/ 
 
/*사원번호    사원명     관리자번호
10        홍길동      null
20        김민재       10
30        이정진       10
40        이옥순       20 */

SELECT employee_id, first_name, manager_id
FROM employees e
WHERE emloyee_id=200; -- ?


SELECT employee_id, first_name, manager_id
FROM employees e
WHERE employee_id=101; -- 100 Steven null

SELECT employee_id, first_name, manager_id
FROM employees e
WHERE employee_id=101; -- 101 neena 100

SELECT e.employee_id AS 사원번호, e,fisrt_name AS 사원명, -- 한글이어도 공백 없ㅇ면 ""사용하지 않아도 됨, 영어여도 공백 있으면 ""사용
		e. manager_id AS 관리자번호, m. first_name AS 관리자명
FROM employees e INNER JOIN employees m
ON e.manager_id = m.employee_id ; -- ? 

서브쿼리(subquery)
 하나의 SQL문안에 포함되어 있는 또 다른 SQL문을 말한다.
 서브쿼리는 알려지지 않은 기준을 이용한 검색을 위해 사용한다.
 서브쿼리는 메인쿼리가 서브쿼리를 포함하는 종속적인 관계이다.
 서브쿼리는 메인쿼리의 컬럼을 모두 사용할 수 있지만 메인쿼리는 서브쿼리의 컬럼을 사용할 수 없다. 
 질의 결과에 서브쿼리 컬럼을 표시해야 한다면 조인방식으로 
    변환하거나 함수, 스칼라 서브쿼리(scarar subquery)등을 사용해야 한다. 
 조인은 집합간의 곱(Product)의 관계이다. 
 
외부 쿼리 (메인쿼리)
 :일반 쿼리를 의미합니다.
스칼라 서브쿼리
 :SELECT 절에 쿼리가 사용되는 경우로, 함수처럼 레코드당 정확히 하나의 값만을 반환하는 서브쿼리입니다.
인라인 뷰
 :FROM 절에 사용되는 쿼리로, 원하는 데이터를 조회하여 가상의 집합을 만들어 조인을 수행하거나 가상의 집합을 다시 조회할 때 사용합니다.



서브쿼리를 사용할 때 다음 사항에 주의
  서브쿼리를 괄호로 감싸서 사용한다. 
  서브쿼리는 단일 행(Single Row) 또는 복수 행(Multiple Row) 비교 연산자와 함께 사용 가능하다. 
  단일 행 비교 연산자는 서브쿼리의 결과가 반드시 1건 이하이어야 하고 복수 행 비교 연산자는 서브쿼리의 결과 건수와 상관 없다. 
  서브쿼리에서는 ORDER BY를 사용하지 못한다. 
  ORDER BY절은 SELECT절에서 오직 한 개만 올 수 있기 때문에 ORDER BY절은 메인쿼리의 마지막 문장에 위치해야 한다.
  

서브 쿼리 사용가능한 위치
SELECT, FROM, WHERE, HAVING,ORDER BY 
INSERT문의 VALUES,
UPDATE문의 SET, 
CREATE문

서브쿼리의 종류는 동작하는 방식이나 반환되는 데이터의 형태에 따라 분류할 수 있다.
1 동작하는 방식에 따른 서브쿼리 분류
  Un-Correlated(비연관) : 서브쿼리가 메인쿼리 컬럼을 가지고 있지 않는 형태의 서브쿼리이다.
          메인쿼리에 값(서브쿼리가 실행된 결과)를 제공하기 위한 목적으로  주로 사용한다.
  Correlated(연관) : 서브쿼리가 메인쿼리 칼럼을 가지고 있는 형태의 서브쿼리이다.
          일반적으로 메인쿼리가 먼저 수행되어 읽혀진 데이터를 서브쿼리에서 조건이 맞는지 확인
	  하고자 할 때 주로 사용된다.  (EXISTS서브쿼리는 항상 연관 서브쿼리로 사용된다. 조건을 만족하는 1건만 찾으면
	  추가 검색을 하지 않는다.)
2 반환되는 데이터의 형태에 따른 서브쿼리 종류
  Single Row(단일행 서브쿼리) : 서브쿼리의 실행결과가 항상 1건 이하인 서브쿼리를 의미한다. 
          단일행 서브쿼리는 단일 행 비교 연산자와 함께 사용된다.
	  단일 행 비교 연산자는 =, <, <=, >, >=, <>이 있다.
  Multi Row(다중행 서브쿼리) : 서브쿼리의 실행 결과가 여러 건인 서브쿼리를 의미한다. 
          다중 행 서브쿼리는 다중 행 비교 연산자와 함께 사용된다. 
	  다중 행 비교 연산자에는 in, all, any, some, exists가 있다.
	      in : 메인쿼리의 비교조건('='연산자로 비교할 경우)이 서브쿼리의 결과 중에서
               하나라도 일치하면 참이다.
           any,some : 메인 쿼리의 비교 조건이 서브 쿼리의 검색 결과와 하나 이상이 일치하면
                참이다.
           all : 메인 쿼리의 비교 조건이 서브 쿼리의 검색 결과와 모든 값이 일치하면 참이다.
           exists : 메인 쿼리의 비교 조건이 서브 쿼리의 결과 중에서 만족하는 값이 하나라도
               존재하면 참이다.
  Multi Column(다중칼럼 서브쿼리) : 서브쿼리의 실행 결과로 여러 컬럼을 반환한다.
          메인쿼리의 조건절에 여러 컬럼을 동시에 비교할 수 있다. 
	  서브쿼리와 메인쿼리에서 비교하고자 하는 컬럼 갯수와 컬럼의 위치가 동일해야 한다.
--------------------------------------------------------------------------------- */   

-- 90 번 부서에 근무하는 Lex의 부서명을 출력하시오.  
SELECT department_name
FROM departments
WHERE department_id = 90;

-- Lex가 근무하는 부서명을 출력하시오.
SELECT department_id
FROM employees 
WHERE first_name = 'Lex';

SELECT department_name
FROM departments
WHERE department_id = 90;

-- join
SELECT d.department_name
FROM employees e INNER JOIN departments d
ON e.department_id = d.department_id
WHERE first_name = 'Lex';

-- sub qury
SELECT department_name
FROM departments
WHERE department_id = (
                        SELECT department_id
                        FROM employees 
                        WHERE first_name = 'Lex'
                        );  -- 연산이 줄어들고 속도도 빨라진다.
                        
 -- 'Lex'와 동일한 업무(job_id)를 가진 사원의 이름(first_name), 
 -- 업무명(job_title), 입사일(hire_date)을 출력하시오.
                        
SELECT e.fisrt_name, j.job_title, e.hire_date
FROM employees e, INNER JOIN jobs j
ON e.job_id = j.job_id
WHERE e.job_id = (                               -- e. job_id or j. job_id 둘 다 윗줄에 언급되어 사용 가능
                   SELECT job_id
                   FROM eployees 
                   WHERE first_name = 'Lex'
                   ); -- ?

-- 'IT'에 근무하는 사원이름(first_name), 부서번호을 출력하시오.
SELECT first_name, department_id
FROM employees e 
WHERE department_id = (
                      SELECT department_id
                      FROM departments
                      WHERE department_name='IT'
                      );

-- 'Bruce'보다 급여를 많이 받은 사원이름(first_name), 부서명, 급여를 출력하시오.
SELECT e.first_name, d.department_name, e.salary
FROM employees e INNER JOIN departments d
ON e. department_id = d.department_id
WHERE salary > (
                     SELECT salary
                     FROM employees
                     WHERE first_name = 'Bruce'
                     )
ORDER BY salary; 

-- Steven와 같은 부서에서 근무하는 사원의 이름, 급여, 입사일을 출력하시오.(in)
SELECT department_id
FROM employees 
WHERE first_name = 'Steven'; -- /*2 Row*/            

SELECT department_id
FROM employees 
WHERE department_id IN (SELECT department_id 
                        FROM employees 
                        WHERE first_name = 'Steven');


-- 부서별로 가장 급여를 많이 받는 사원이름, 부서번호, 급여를 출력하시오.(in)   
SELECT department_id, max(salary)
FROM employees 
GROUP BY department_id;

SELECT first_name, department_id, salary
FROM employees 
WHERE (department_id, salary) IN(SELECT department_id, max(salary)
                                 FROM employees
                                 GROUP BY department_id)
ORDER BY department_id ASC; -- 부서별로 정렬

-- 30소속된 사원들 중에서 급여를 가장 받은 사원보다 더 많은 급여를 받는
-- 사원이름, 급여, 입사일을 출력하시오. (ALL)-subqury에 있는 모든 조건을 만족해야만 main qury가 참이다.
-- (서브쿼리에서 max()함수를 사용하지 않는다);

select salary
FROM employees
WHERE department_id=30;

SELECT first_name, salary, hire_date
FROM employees 
WHERE salary >ALL (select salary
                   FROM employees
                   WHERE department_id=30 );

-- 30소속된 사원들이 받은 급여보다  높은 급여를 받는 
-- 사원이름, 급여, 입사일을 출력하시오. (ANY)-하나라도 만족하면 가져오도록 함
-- (서브쿼리에서 min()함수를 사용하지 않는다); 
select_first_naem, salary, hire_date
FROM employees
WHERE salary> ANY (SELECT salary
                   FROM employees
                   WHERE department_id=30);

SELECT department_id, department_name
FROM departments; -- /*27 Row*/ -main qury로 사용

SELECT department_id, department_name
FROM employees /*12 Rows*/

SELECT department_id, department_name
FROM departments 
WHERE department_id IN(SELECT DISTINCT department_id 
                        FROM employees);

/*-----------------------------------------------------
 상관관계 서브쿼리
 : 서브쿼리에서 메인쿼리의 컬럼을 참조한다.(메인쿼리를 먼저수행한다.)
   서브쿼리는 메인쿼리 각각의 행에 대해서 순서적으로 한번씩 실행한다.
 <아래 쿼리 처리순서>
 1st : 바깥쪽 쿼리의 첫째 row에 대하여 
 2nd : 안쪽 쿼리에서 자신의 속해있는 부서의 MAX salary과
       비교하여 true 이면 바깥의 컬럼값을 반환하고 , 
       false 이면 값을 버린다. 
 3rd : 바깥쪽 쿼리의 두 번째 row에 대하여 마찬가지로 실행하며, 
       이렇게 바깥쪽 쿼리의 마지막 row까지 실행한다. 
	   
https://www.w3resource.com/sql/subqueries/correlated-subqueries-using-aliases.php	   
----------------------------------------------------*/                    

-- 부서별 최고 급여를 받는 사원을 출력하시오.
SELECT department_id, max(salary)
FROM employees 
GROUP BY department_id;

SELECT department_id, salary, first_name, hire_date -- 요청 칼럼이 없어 임의로 정리
FROM employees 
WHERE (department_id, salary) IN (SELECT department_id, max(salary)
                                  FROM employees 
                                  GROUP BY department_id )
ORDER BY department_id ASC;

-- 사원이 있는 부서만 출력하시오.
SELECT department_id, department_name
FROM departments d
WHERE EXISTS (SELECT 1
              FROM employees e
              WHERE e. department_id = d.department_id);

-- 사원이 없는 부서만 출력하시오.
SELECT department_id, department_name
FROM departments d
WHERE NOT EXISTS (SELECT 1
              FROM employees e
              WHERE e. department_id = d.department_id);

-- 부서가 있는 사원의 정보를 출력하시오.
SELECT e.employee_id, e.first_name, e.department_id
FROM employees e
WHERE EXISTS (
              SELECT 1
              FROM departments d
              WHERE d.department_id=e.department_id
              );

-- 관리자가 있는 사원의 정보를 출력하시오
SELECT e.employee_id, e.first_name, e.department_id
FROM employees e
WHERE EXISTS ( SELECT 1
               FROM employees m
               WHERE m.employee_id = e.manager_id);

-- 관리자가 없느 사원 정보 출력.
SELECT e.employee_id, e.first_name, e.department_id
FROM employees e
WHERE NOT EXISTS ( SELECT 1
               FROM employees m
               WHERE m.employee_id = e.manager_id);

/*==========================================================
 WITH ROLLUP
 총합 또는 중간 합계가 필요할때 GROUP by 절과 함께 WITH ROLLUP문을 사용한다.
 ===========================================================*/
SELECT department_id, job_id, count(*)AS count
FROM employees 
GROUP BY department_id, job_id WITH ROLLUP
ORDER BY department_id DESC, job_id DESC;

/*=================================================================================
 그룹내 순위관련함수
 RANK( ) OVER( ) : 특정 컬럼에 대한 순위를 구하는 함수로 동일한 값에 대해서는 동일한 순위를 준다. 
 DENSE_RANK( ) OVER( ) : 동일한 순위를 하나의 건수로 취급한다.
 ROW_NUMBER( ) OVER( ) : 동일한 값이라도 고유한 순위를 부여한다.
 ===================================================================================*/
 /*    RANK        DENSE_RANK       ROW_NUMBER
  90    1              1                1  - 누가 먼저 처리했는가에 따라 순위 부여
  90    1              1                2 
  85    3              2                3
  80    4              3                4  
 */

SELECT job_id, first_name, salary, RANK() OVER (ORDER BY salary DESC)
FROM employees ;


SELECT job_id, first_name, salary, DENSE_RANK() OVER (ORDER BY salary DESC)
FROM employees ;


SELECT job_id, first_name, salary, ROW_RANK() OVER (ORDER BY salary DESC)
FROM employees ;


SELECT job_id, first_name, salary, ROW_NUMBER() OVER (ORDER BY salary DESC)
FROM employees ;

SELECT job_id, first_name, salary, ROW_NUMBER() OVER()
FROM employees 
ORDER BY salary DESC;

-- 급여가 제일 높으 상위 3명을 검색하시오.
SELECT row_number()over()AS rownum, first_name, salary
FROM employees 
ORDER BY salary DESC 
LIMIT 3 ; /*개수*/ -- my sqㅣ의 장점, 

SELECT row_number()over(ORDER BY salary DESC )AS rownum, first_name, salary
FROM employees 
LIMIT 0, 1 ; -- 0에서부터 한 개라는 뜻(mysqll 전체는 1부터, limit기능만 0부터) /*시작번호, 개수*/

SELECT row_number()over(ORDER BY salary DESC )AS rownum, first_name, salary
FROM employees 
LIMIT 4, 5 ;

-- 월 별 입사자 수를 조회하되 입사자 수가 가장 많은 상위 3개만 출력되도록 하시오.
-- <출력: 월  입사자 수>

SELECT MONTH(hire_date) AS 월, count(*) AS "입사자 수"
FROM employees 
GROUP BY month(hire_date)
ORDER BY count(*)DESC 
LIMIT 3;
