--Basic SQL
--1.Find the names of all the instructors from Biology department
 select name
 from instructor
 where dept_name = 'Biology';
-- name
-- Crick
--2.Find the names of courses in Computer science department which have 3 credits
select title
from course
where dept_name = 'Comp. Sci.' and credits = 3;
--title
--Robotics
--Image Processing
--Database System Concepts
--3.For the student with ID 12345 (or any other value), show all course_id and title of all courses registered for by the student.
select t.course_id, c.title
from course as c,takes as t
where t.course_id = c.course_id and t.ID = '12345';
--course_id	title
--CS-101	Intro. to Computer Science
--CS-190	Game Design
--CS-315	Robotics
--CS-347	Database System Concepts
--4.As above, but show the total number of credits for such courses (taken by that student). Don't display the tot_creds value from the student table, you should use SQL aggregation on courses taken by the student.
select sum(c.credits)
from course as c, takes as t
where t.course_id = c.course_id and t.ID = '12345'; 
--(No column name)
--14
--5.As above, but display the total credits for each of the students, along with the ID of the student; don't bother about the name of the student. (Don't bother about students who have not registered for any course, they can be omitted)
select t.ID, sum(c.credits) as CreditsInTake
from course as c, takes as t
where t.course_id = c.course_id
group by t.ID; 
--ID	CreditsInTake
--00128	7
--12345	14
--19991	3
--23121	3
--44553	4
--45678	11
--54321	8
--55739	3
--76543	7
--76653	3
--98765	7
--98988	8

--6.Find the names of all students who have taken any Comp. Sci. course ever (there should be no duplicate names)
select distinct s.name 
from student as s,takes as t,course as c
where s.ID = t.ID and t.course_id = c.course_id and c.dept_name = 'Comp. Sci.';
--name
--Bourikas
--Brown
--Levy
--Shankar
--Williams
--Zhang
--7.Display the IDs of all instructors who have never taught a couse (Notesad1) Oracle uses the keyword minus in place of except; (2) interpret "taught" as "taught or is scheduled to teach")
select i.ID
from instructor as i
except
	(select i.ID
	from instructor as i,teaches as t
	where i.ID = t.ID);
--ID
--33456
--58583
--76543
--8.As above, but display the names of the instructors also, not just the IDs.
select i.ID, i.name
from instructor as i
except
	(select i.ID,i.name
	from instructor as i,teaches as t
	where i.ID = t.ID);
--ID	name
--33456	Gold
--58583	Califieri
--76543	Singh
--9.You need to create a movie database. Create three tables, one for actors(AID, name), one for movies(MID, title) and one for actor_role(MID, AID, rolename). Use appropriate data types for each of the attributes, and add appropriate primary/foreign key constraints.
create table actors
	(AID		varchar(7),
	 name		varchar(20) not null,
	 primary key(AID)
	 );
create table movies
	(MID		varchar(7),
	 title		varchar(20) not null,
	 primary key(MID)
	 );
create table actor_role
	(AID			varchar(7),
	 MID			varchar(7),
	 role_name		varchar(20) not null,
	 primary key(AID,MID),
	 foreign key(AID) references actors,
	 foreign key(MID) references movies
	 );
--Commands completed successfully.
--10.Insert data to the above tables (approx 3 to 6 rows in each table), including data for actor "Charlie Chaplin", and for yourself (using your roll number as ID).
insert into actors values('1025834','Charlie Chaplin');
insert into actors values('1574267','Donald Shade');
insert into actors values('2573648','Benedict Cumberbatch');
insert into actors values('6548129','Patrick Dudenhofer');
insert into actors values('7945126','David Gallagher');
insert into actors values('7945621','Jacob Moore');
insert into actors values('8054961','Keith Shomper');
insert into movies values('0003245','The Great Dictator');
insert into movies values('0008956','The Imitation Game');
insert into movies values('0015896','Avengers: Endgame');
insert into movies values('0024785','Aladdin');
insert into movies values('0065845','The Music Man');
insert into movies values('6652340','Return of the Jedi');
insert into actor_role values('1025834','0003245','Hynkel');
insert into actor_role values('1574267','0008956','Extra');
insert into actor_role values('1574267','0024785','Jafar');
insert into actor_role values('1574267','0065845','Olin Brit');
insert into actor_role values('2573648','0008956','Alan Turing');
insert into actor_role values('2573648','0015896','Dr. Strange');
insert into actor_role values('6548129','0015896','Extra');
insert into actor_role values('6548129','6652340','Storm Trooper');
insert into actor_role values('7945126','6652340','Palpatine');
--There was rows affected.
--11.Write a query to list all movies in which actor "Charlie Chaplin" has acted, along with the number of roles he had in that movie.
select m.title
from actors as a,movies as m, actor_role as r
where a.name = 'Charlie Chaplin' and a.AID = r.AID and r.MID = m.MID;
--title
--The Great Dictator
--12.Write a query to list all actors who have not acted in any movie
select a.AID,a.name
from actors as a
	except
	(select distinct a.AID,a.name
	 from actors as a,actor_role as r
	 where a.AID = r.AID);
--AID	name
--7945621	Jacob Moore
--8054961	Keith Shomper
--13.List names of actors, along with titles of movies they have acted in. If they have not acted in any movie, show the movie title as null. (Do not use SQL outerjoin syntax here, write it from scratch.)
select a.name,m.title
from actors as a,movies as m, actor_role as r
where a.AID = r.AID and m.MID = r.MID
union
select sec.name, NULL as title
from
	(select a.AID,a.name
	from actors as a
		except
		(select distinct a.AID,a.name
		 from actors as a,actor_role as r
		 where a.AID = r.AID)) as sec;
--name	title
--Benedict Cumberbatch	Avengers: Endgame
--Benedict Cumberbatch	The Imitation Game
--Charlie Chaplin	The Great Dictator
--David Gallagher	Return of the Jedi
--Donald Shade	Aladdin
--Donald Shade	The Imitation Game
--Donald Shade	The Music Man
--Jacob Moore	NULL
--Keith Shomper	NULL
--Patrick Dudenhofer	Avengers: Endgame
--Patrick Dudenhofer	Return of the Jedi