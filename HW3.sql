--1. Find the names of all the students who have taken at least 1 Computer Science course.  Remove duplicates from the result.
select distinct name
from student as s
where exists (  select c.course_id
				from course as c,takes as t
				where c.dept_name = 'Comp. Sci.' and S.ID = T. ID and c.course_id = t.course_id );		
--name
--Bourikas
--Brown
--Levy
--Shankar
--Williams
--Zhang
--2. Return the number of times a grade of A or A- has been achieved.
select 'A or A-' as Grade, count(grade) as Num
from takes
where grade = 'A' or grade = 'A-';
--Grade	    Num
--A or A-	10
--3. List the department names housed in the Watson, Taylor or Packard buildings.
select dept_name as Department
from department
where building = 'Watson' or building = 'Taylor' or building = 'Packard';
--Department
--Biology
--Comp. Sci.
--Elec. Eng.
--Music
--Physics
--4. Find the sum of all the department budgets.
select sum(budget) as Total_Budget
from department;
--Total_Budget
--595000.00
--5. Find the sum of all the department budgets and prepend the result with a ‘$’.
select concat('$',sum(budget)) as Total_Budget
from department;
--Total_Budget
--$595000.00
--6. Find the names of all instructors that have an ‘e’ or ‘E’ in their name.
(select name
from instructor
where name like '%e%' )
union
(select name
from instructor
where name like '%E%')
--name
--Califieri
--Einstein
--El Said
--7. Find the names of all instructors that have at least 6 letters in their name.
select name
from instructor
where name like '______%';--that is six
--name
--Srinivasan
--Mozart
--Einstein
--El Said
--Califieri
--Brandt
--8. Return the names of all the departments in all upper case letters in reverse alphabetical order.
select upper(dept_name) as 'Rev. Alph.'
from department
order by dept_name DESC;
--Rev. Alph.
--PHYSICS
--MUSIC
--HISTORY
--FINANCE
--ELEC. ENG.
--COMP. SCI.
--BIOLOGY
--9. Find all the department names with more than 2 instructors.
with instructorNumber (dept_name,numInstructors) AS 
	(select dept_name,count(dept_name) as numInstructors
	 from instructor
	 group by dept_name)
select dept_name as 'Department Name'
from   instructorNumber
where numInstructors>=2;
--Department Name
--Comp. Sci.
--Finance
--History
--Physics
--10. Return a list of the first 5 student names (first 5 as defined as first 5 in the alphabet) along with a column named ‘active’ with the value of ‘A’  in the active column for every student. 
select  top 5 name as "Name",'A' as "Active"
from student group by name;
--Name	Active
--Aoi	A
--Bourikas	A
--Brandt	A
--Brown	A
--Chavez	A
--11. Return the sum of the salaries (sorted from greatest to least) paid to the instructors for each department with a 10% raise tacked on (i.e. we are interested in what the total salary of all the Biology department (for instance) professors would be if we gave everybody a 10% raise).
with departmentSalary (dept_name,avgSalary) AS 
	(select dept_name,avg(salary) as avgSalary
	 from instructor
	 group by dept_name)
select dept_name as 'Department Name', avgSalary * 1.1 AS 'Aver. Salary'
from   departmentSalary;
--Department Name	Aver. Salary
--Biology	79200.000000
--Comp. Sci.	85066.666666
--Elec. Eng.	88000.000000
--Finance	93500.000000
--History	67100.000000
--Music	44000.000000
--Physics	100100.000000
--12. For each department, find the maximum salary of instructors in that department.
with departmentSalary (dept_name,maxSalary) AS 
	(select dept_name,max(salary) as maxSalary
	 from instructor
	 group by dept_name)
select dept_name as 'Department Name', maxSalary as 'Max Salary'
from   departmentSalary;
--Department Name	Max Salary
--Biology	72000.00
--Comp. Sci.	92000.00
--Elec. Eng.	80000.00
--Finance	90000.00
--History	62000.00
--Music	40000.00
--Physics	95000.00
--13. Find the minimum maximum salary (see preceding query) and the department name .
with departmentSalary (dept_name,maxSalary) AS 
	(select dept_name,max(salary) as maxSalary
	 from instructor
	 group by dept_name)
select min(maxSalary) as 'MinMax Salary'
from   departmentSalary;
--MinMax Salary
--40000.00
--14. Find the name and salary of all instructors that make more than the average instructor salary.
with avgSalary (avgSalary) AS 
	(select avg(salary) as avgSalary
	 from instructor)
select i.name as 'Instructor Name', i.salary as 'Salary'
from   instructor as i,avgSalary as a
where i.salary>a.avgSalary;
--Instructor Name	Salary
--Wu	90000.00
--Einstein	95000.00
--Gold	87000.00
--Katz	75000.00
--Singh	80000.00
--Brandt	92000.00
--Kim	80000.00
--15. Find the names of all instructors that make between $80-$90K, inclusive.
select i.name
from instructor as i
where i.salary>=80000 and i.salary<=90000;
--name
--Wu
--Gold
--Singh
--Kim
--16. Find the enrollment of each section (course_id/section_id) that was offered in Fall 2009.
--with departmentSalary (dept_name,maxSalary) AS 
--	(select dept_name,max(salary) as maxSalary
--	 from instructor
--	 group by dept_name)
--select min(maxSalary) as 'MinMax Salary'
--from   departmentSalary;
select t.course_id,t.sec_id,count(t.course_id) as 'Num Enrolled'
from takes as t
where t.semester = 'Fall' and t.year = '2009'
group by course_id,sec_id;
--course_id	sec_id	Num Enrolled
--CS-101	1	6
--CS-347	1	2
--PHY-101	1	1
--17. Find the maximum enrollment across all sections, for Fall 2009.
with enrolled (course_id,section_id,enrolledCount) AS
	(select t.course_id,t.sec_id,count(t.course_id) as 'Num Enrolled'
	from takes as t
	where t.semester = 'Fall' and t.year = '2009'
	group by course_id,sec_id)
select max(enrolledCount)
from enrolled;
--(No column name)
--6
--18. Find the section name(s) (course_id/section_id) and the enrollment for all sections that had the maximum enrollment in Fall 2009.
with enrolled (course_id,section_id,enrolledCount) AS
	(select t.course_id,t.sec_id,count(t.course_id) as 'Num Enrolled'
	from takes as t
	where t.semester = 'Fall' and t.year = '2009'
	group by course_id,sec_id)
select course_id,section_id,enrolledCount
from enrolled
where enrolledCount = ( select max(enrolledCount)
						from enrolled);
--course_id	section_id	enrolledCount
--CS-101	1	        6
--19. Produce a sorted list (in descending order) of all the ID’s used in the student and instructor relations.
(select id
from student)
union
(select id
from instructor)
--20. Increase the salary of every instructor in the Computer Science department by 10%.
update instructor
set salary = salary *1.1
where dept_name = 'Comp. Sci.';
--Congrats, they got a raise
--21. Create a new course that matches this class (i.e. CS-3610 ‘Database Concepts’ offered through the Computer Science department for 3 credits).
insert into course values ('CS-361','Database Concepts','Comp. Sci.','3');
--You got it
--22. Add a new section corresponding to this real-life section.  This will require you to add a row to the classroom relation and 2 rows to the time_slot relation.  
insert into time_slot values ('I','T','8','30','9','45');
insert into time_slot values ('I','R','8','30','9','45');
insert into classroom values ('ENS','205','30');
insert into section values ('CS-361','1','Spring','2019','ENS','205','I');
--New Class!
--23. Insert yourself as a student that takes this class and leave letter grade null.  This will require you to add yourself to the student table.
insert into student values ('15432','Shade','Comp. Sci.','240');
insert into takes values ('15432','CS-361','1','Spring','2019',null);
--Do I have to pay for this?
--24. Insert every student in the Biology department into this class and give them all A’s, using 1 SQL insert statement. 
INSERT INTO takes (ID,course_id,sec_id,semester,year,grade)
SELECT ID,'CS-361' as course_id,'1'as sec_id,'Spring'as semester,'2019' as classYear,'A' as grade
FROM student
where dept_name = 'Biology';
--I added the student
--25. Delete the course BIO-399, Computational Biology.
delete from course where course_id = 'BIO-399';
--Its gone
--26. Find the name(s) of the student that have taken a class in the Biology department.
select distinct S.name
from student as S
where exists	(select c.course_id
				from course as c, takes as t
				where dept_name = 'Biology' and c.course_id=t.course_id and S.ID = T.ID);
--name
--Tanaka
--27. Find the name(s) of the students that have taken every course offered in the Biology department.
select distinct S.name
from student as s
where not exists ((select course_id
					from course
					where dept_name='Biology')
					except
					(select t.course_id
					from takes as t
					where S.ID = t.id));
--name
--Tanaka
--She classifies because we deleted that other class.
--28. Modify the instructor table by adding the attribute phone_number.
ALTER TABLE instructor
	ADD phone_number char(12);
--29. Using 1 SQL statement, give all instructors the same phone number, 555-555-5555.
update instructor
set instructor.phone_number = '555-555-5555';
--30. Modify the instructor table by deleting the phone_number attribute.
ALTER TABLE instructor
	DROP COLUMN phone_number;
--31. Write SQL DDL to create the bank schema from figure 3.19 (page 107) from the textbook.  Make reasonable assumptions for data types and FKs.  The PKs are given.  Feel free to add other constraints if you want.  Execute the DDL against a new ‘Bank’ database that you create.  Then, to confirm you have done this, execute the following statement:
create table branch
	(branch_name		varchar(20),
	 branch_city		varchar(20),
	 assests		numeric(16,3),
	 primary key (branch_name)
	);
create table customer
	(customer_name		varchar(25),
	 customer_street	varchar(20),
	 customer_city		varchar(20),
	 primary key (customer_name)
	);
create table loan
	(loan_number		varchar(25),
	 branch_name		varchar(20),
	 amount				numeric(10,3),
	 primary key (loan_number),
	 foreign key (branch_name) references branch
	);
create table borrower
	(customer_name		varchar(25),
	 loan_number		varchar(25),
	 primary key (customer_name,loan_number),
	 foreign key (customer_name) references customer,
	 foreign key (loan_number) references loan
	);
create table account
	(account_number		varchar(25),
	 branch_name		varchar(20),
	 balance			numeric(11,3),
	 primary key (account_number),
	 foreign key (branch_name) references branch
	);
create table depositor
	(customer_name		varchar(25),
	 account_number		varchar(25),
	 primary key (customer_name,account_number),
	 foreign key (customer_name) references customer,
	 foreign key (account_number) references account
	);
--Congrats on the ownership of the new Bank Database!
use Bank
select name 
from sys.tables;
--name
--branch
--customer
--loan
--borrower
--account
--depositor
