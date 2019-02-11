--1. Find the titles of all of the courses along with the id(s) of the instructors that have taught the course (i.e. courses that have been taught by different professors will be listed more than once).  Include courses that have never been taught.  Order your results by title ascending.
select c.title, t.ID
from course as c left outer join teaches as t
on c.course_id = t.course_id
order by (c.title);
--title							ID
--Computational Biology			NULL
--Database System Concepts		10101
--Game Design					83821
--Game Design					83821
--Genetics						76766
--Image Processing				45565
--Image Processing				83821
--Intro. to Biology				76766
--Intro. to Computer Science	10101
--Intro. to Computer Science	45565
--Intro. to Digital Systems		98345
--Investment Banking			12121
--Music Video Production		15151
--Physical Principles			22222
--Robotics						10101
--World History					32343
--2. Exactly the same as the above query, but this time return name of the instructor instead of the id.
select myTable.title,i.name
from (select c.title, t.ID
	from course as c left outer join teaches as t
	on c.course_id = t.course_id) as myTable left outer join instructor as i
on myTable.ID = i.ID
order by (myTable.title);
--title							name
--Computational Biology			NULL
--Database System Concepts		Srinivasan
--Game Design					Brandt
--Game Design					Brandt
--Genetics						Crick
--Image Processing				Katz
--Image Processing				Brandt
--Intro. to Biology				Crick
--Intro. to Computer Science	Srinivasan
--Intro. to Computer Science	Katz
--Intro. to Digital Systems		Kim
--Investment Banking			Wu
--Music Video Production		Mozart
--Physical Principles			Einstein
--Robotics						Srinivasan
--World History					El Said
--3. Insert the ‘Bible’ department into the department table, and designate its building as ‘BTS’.
insert into department values ('Bible','BTS',null);
--Done
--4. Insert a professor into the instructor table with id ‘55555’ and name ‘Jones’.
insert into instructor values('55555','Jones',null,null); 
--I have added Dr. Jones. When will be returning from his hunt for the crystal skull?
--5. Return a list of all instructor names and which building their department is located in, and also include buildings with no instructors assigned to work in them.
select i.name,d.building
from instructor as i full outer join department as d
on i.dept_name = d.dept_name;
--name			building
--Srinivasan	Taylor
--Wu			Painter
--Mozart		Packard
--Einstein		Watson
--El Said		Painter
--Gold			Watson
--Katz			Taylor
--Jones			NULL
--Califieri		Painter
--Singh			Painter
--Crick			Watson
--Brandt		Taylor
--Kim			Taylor
--NULL			BTS
--6. For every course, return the course title and the total count of students who have ever enrolled in that course.  For courses that no students have ever taken, the count should be 0.  Order by number of enrollees descending.
select c.course_id,count(t.course_id) as enrolled
from course as c full outer join takes as t
on c.course_id = t.course_id
group by c.course_id
order by enrolled desc;
--course_id	enrolled
--CS-101	7
--CS-190	2
--CS-315	2
--CS-319	2
--CS-347	2
--EE-181	1
--FIN-201	1
--HIS-351	1
--MU-199	1
--PHY-101	1
--BIO-101	1
--BIO-301	1
--BIO-399	0
--7. For each student, return their name and the sum of all their credits.  If a student got an ‘F’ in a class, this should not count towards his credits.  If a student is currently enrolled in a class, go ahead and give him credit for that class.  If a student has never taken a class, he should have 0 total credits.  Sort by total credits descending.   (HINT: To do this query, I used coalesce(sum(credits), 0) to change Snow’s credit from null to 0.  Tanaka should have 8 total credits, 4 for the class he has already taken and 4 for the class he is currently enrolled in.  Levy should have 7 total credits because the first time he took CS-101 he failed).
select s.name, coalesce(sum(a.totalCredits), 0) as 'Total Credits'
from student as s left outer join (select t.ID,sum(c.credits) as totalCredits
								from takes as t, course as c	
								where (t.grade != 'F' or t.grade is null) and  c.course_id = t.course_id
								group by t.ID) as a
on s.ID = a.ID
group by s.name
order by 'Total Credits' desc;

--name		Total Credits
--Shankar	14
--Tanaka	8
--Williams	8
--Zhang		7
--Levy		7
--Bourikas	7
--Brown		7
--Peltier	4
--Sanchez	3
--Chavez	3
--Brandt	3
--Aoi		3
--Snow		0
--8. This query returns all of the instructor ids, including the ones that have no advisees:
select a.s_id as adviseeID, i.id as advsorID
from instructor i left outer join advisor a on a.i_id = i.id
order by a.s_id asc;
--This query returns all of the student ids, including the ones that have no advisor:
select s.id as adviseeID, a.i_id as advsorID
from student s left outer join advisor a on a.s_id = s.id
order by a.i_id asc;
--Now compose a query that returns all of the students and all of the instructors and their advisors / advisees, including the ones that don’t have an advisor / advisee.  Order by adviseeID ascending, and then by advisorID ascending.  (HINT: this can be accomplished by performing an outer join on an outer join (i.e. by ‘combining’ the two different joins in the above queries)). 
select s.id as adviseeID, i.ID as advisorID
from (student as s full outer join advisor as a on s.ID = a.s_ID) full outer join instructor as i on a.i_ID = i.ID
order by s.id, i.id;
--adviseeID	advisorID
--NULL		12121
--NULL		15151
--NULL		32343
--NULL		33456
--NULL		55555
--NULL		58583
--NULL		83821
--00128		45565
--12345		10101
--19991		NULL
--23121		76543
--44553		22222
--45678		22222
--54321		NULL
--55739		NULL
--70557		NULL
--76543		45565
--76653		98345
--98765		98345
--98988		76766
--9. Return the list of all course titles and the titles of their prereqs (i.e. you need 2 columns titled ‘course_title’ and ‘prereq_course_title’).  For courses that do not have a prereq, return ‘None’.  Courses that have multiple prereqs would return multiple rows.  Make sure you are returning titles and not ids!
select c.title as Title,coalesce(p.title, 'None') as 'Prerequisite'
from (course as c left outer join prereq on c.course_id = prereq.course_id) left outer join course as p on prereq.prereq_id = p.course_id;
--Title	                        Prerequisite
--Intro. to Biology	            None
--Genetics	                    Intro. to Biology
--Computational Biology	        Intro. to Biology
--Intro. to Computer Science	None
--Game Design	                Intro. to Computer Science
--Robotics	                    Intro. to Computer Science
--Image Processing	            Intro. to Computer Science
--Database System Concepts	    Intro. to Computer Science
--Intro. to Digital Systems	    Physical Principles
--Investment Banking	        None
--World History             	None
--Music Video Production	    None
--Physical Principles	        None
GO
--10. Write a DDL statement to create a new schema named ‘library’. A schema is essentially a namespace within a database. (The default namespace for University is dbo.)
CREATE SCHEMA library;
GO
--I done did that
--11. Create a table named ‘staff’ in the library schema with attributes id (primary key), name (not nullable), salary.
CREATE TABLE library.staff (
    id      char(5),
    name    varchar(20) not null,
    salary  numeric(8,2),
    primary key(id)
)
--I done did that too!
--12. Insert ‘Baldwin’ into the staff table with id ‘55555’ and salary of $50,000.
insert into library.staff values ('55555','Baldwin',50000);
--Mr. Alec Baldwin would prefer to teach theatre but will settle for being a writer
--13. Insert ‘Baldwin’ into the staff table with id ‘66666’ and salary of $25,000 (maybe this is the other Baldwin’s son).
insert into library.staff values ('66666','Baldwin',25000);
--Maybe his son, but what about his daughter?
--14. Find the id, instructor name, and library staff name of people with conflicting ids (i.e. ids that exist in both the instructor table and the staff table).
select i.id,i.name,l.name
from instructor as i,library.staff as l
where i.id = l.id;
--It appears that Dr. Jones and Mr. Baldwin will be having a tussle for that ID.
--id	name	name
--55555	Jones	Baldwin
--15. Return the name and the count of all people in the library staff table with the same name.
select l.name,count(l.name) as 'NumPeople'
from library.staff as l
group by l.name;
--name	    NumPeople
--Baldwin	2
--16. Using the SQL Server Management Studio GUI, create a new user (Security -> Logins -> (right-click) New Login… ) named ‘susie’ with password ‘password’.  Use SQL Server Authentication for this user’s authentication.  Make the University database her default and from the ‘User Mapping’ page, add her to the University database and make ‘dbo’ her default schema.  
--Next create a new Database Connection Engine query (File -> New -> Database Engine Query) and sign in as ‘susie’.   NOTE: the sign in will fail unless a change is made!  Check the server logs (in the Object Explorer go to Management -> SQL Server Logs) to diagnose the problem and fix it.  Once you are signed in successfully, execute:
select user as 'current_user';
--current_user
--guest
--then
select * from course;
--Include the results after executing each statement.
--Msg 208, Level 16, State 1, Line 204
--Invalid object name 'course'.
--17. Now go back to the ‘user’ query window (the one where you are signed in as ‘CEDARVILLE-CS-VM\user’) and grant permission for ‘susie’ to select from the course table.  Record the DDL statement that your wrote.  To make sure it worked, go back to the ‘susie’ query window and re-execute :
grant select on "Prac_University"."dbo"."course" to [susie];
--I hope that works...
select * from course;
--course_id	title						dept_name	credits
--BIO-101	Intro. to Biology			Biology		4
--BIO-301	Genetics					Biology		4
--BIO-399	Computational Biology		Biology		3
--CS-101	Intro. to Computer Science	Comp. Sci.	4
--CS-190	Game Design					Comp. Sci.	4
--CS-315	Robotics					Comp. Sci.	3
--CS-319	Image Processing			Comp. Sci.	3
--CS-347	Database System Concepts	Comp. Sci.	3
--EE-181	Intro. to Digital Systems	Elec. Eng.	3
--FIN-201	Investment Banking			Finance		3
--HIS-351	World History				History		3
--MU-199	Music Video Production		Music		3
--PHY-101	Physical Principles			Physics		4
--18. As ‘user’ create a view called ‘cs_faculty’ that shows the id, name, and dept_name for all ‘Comp. Sci.’ instructors.  '
Go
create view "cs_faculty" as 
	select id,name,dept_name
	from instructor
	where dept_name = 'Comp. Sci.';
--19. Again using the GUI, create a role named ‘dept_admin’ (Databases -> University -> Security -> Roles -> (right click on) Database Roles).  Add ‘susie’ as a Role Member.  Now as ‘user’ write the DDL that gives select, update, and insert permissions for the ‘cs_faculty’ view to the ‘dept_admin’ role.   
grant select,insert,update on cs_faculty to [dept_admin]
--20. As ‘susie’ insert a new faculty member into the ‘Comp. Sci.’ department named ‘DG’ with id 11122;
insert into cs_faculty values ('11122','DG','Comp. Sci.');
--It has been added.
--21. As ‘user’ execute:
select * from instructor;
--ID	name		dept_name	salary
--10101	Srinivasan	Comp. Sci.	65000.00
--11122	DG			Comp. Sci.	NULL
--12121	Wu			Finance		90000.00
--15151	Mozart		Music		40000.00
--22222	Einstein	Physics		95000.00
--32343	El Said		History		60000.00
--33456	Gold		Physics		87000.00
--45565	Katz		Comp. Sci.	75000.00
--55555	Jones		NULL		NULL
--58583	Califieri	History		62000.00
--76543	Singh		Finance		80000.00
--76766	Crick		Biology		72000.00
--83821	Brandt		Comp. Sci.	92000.00
--98345	Kim			Elec. Eng.	80000.00
