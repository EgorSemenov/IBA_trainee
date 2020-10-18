/* 
--already was done, no need to watch
SELECT LASTNAME, SALARY, SALARY * 1.05, SALARY / 12 * 1.05
FROM EMPLOYEE
WHERE SALARY * 1.05 <= 20000 AND EDLEVEL IN (18,20);

SELECT DEPTNO, DEPTNAME, COALESCE(MGRNO, 'UNKNOWN')
FROM DEPARTMENT
WHERE MGRNO IS NULL;

--For all departments with at least one designer, display the number of designers and the department number. Name the derived column DESIGNER.
 SELECT WORKDEPT, COUNT(*) AS DESIGNER
 FROM EMPLOYEE
 WHERE JOB = 'DESIGNER'
 GROUP BY WORKDEPT;
*/

--7
select deptno, deptname, lastname, firstnme
from employee as e
     inner join department as d
     on e.workdept = d.deptno
where (
        select count(*)
        from employee
        where workdept = e.workdept
              and  sex = 'F'
       ) = 0;

--8 with STERN
select lastname, job, edlevel, 
       max(0, year('2000-01-01' - hiredate)) as years, salary
from employee
where (job, edlevel) in (
        select job, edlevel
        from employee
        where lastname = 'STERN'
        )
order by salary desc;

--8 without STERN
select lastname, job, edlevel, 
       max(0, year('2000-01-01' - hiredate)) as years, salary
from employee
where (job, edlevel) in (
        select job, edlevel
        from employee
        where lastname = 'STERN'
        )
        and lastname != 'STERN'
order by salary desc;

drop table userphone;
drop table userphones;

create table userphone (
        user_id int NOT NULL,
        phone_type char(1),
        phone_number bigint NOT NULL,
        primary key (user_id, phone_number)
);

insert into userphone values
        (101,'w',375291997780),
        (121, 'h',2557734),
        (11,'w',375291499706),
        (11,'h',2119980),
        (121,'w',375291991270),
        (1,'w',375291329970);
        
select * from userphone;

create table userphones(
        user_id int not null,
        home_number bigint,
        work_number bigint,
        primary key(user_id)
);

insert into userphones
        (user_id)
        select distinct user_id
        from userphone;

update userphones
set home_number = (
        select phone_number
        from userphone uph
        where userphones.user_id = uph.user_id
              and uph.phone_type = 'h'
);

update userphones
set work_number = (
        select phone_number
        from userphone uph
        where userphones.user_id = uph.user_id
              and uph.phone_type = 'w'
);

select * from userphones;
drop table userphone;        

/*drop table userphone;
drop table userphones;*/

/*alter table userphone
        drop primary key;*/
drop table flags;

create table flags (
        id int not null,
        fl1 char(5) not null,
        fl2 char(5) not null,
        fl3 char(5) not null,
        fl4 char(5) not null,
        fl5 char(5) not null,
        fl6 char(5) not null,
        fl7 char(5) not null,
        fl8 char(5) not null,
        fl9 char(5) not null,
        primary key(id)
);

insert into flags values
        (1,'true','true','true','true','true','true','true','true','true'),
        (2,'true','false','false','true','true','true','true','true','true'),
        (3,'true','false','true','false','false','true','true','true','false'),
        (4,'false','false','true', 'false','false','false','false','false','false'),
        (5,'false','false','false','false','false','false','false','false','false');
        
select id, 'fl'|| cast(((locate('true', fl1||fl2||fl3||fl4||fl5||fl6||fl7||fl8||fl9) - 1 ) / 5 + 1) as char(3)) as flag
from flags
where regexp_count(fl1||fl2||fl3||fl4||fl5||fl6||fl7||fl8||fl9, 'true') = 1 












