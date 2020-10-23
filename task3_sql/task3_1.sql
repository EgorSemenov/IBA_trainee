---------- 
-- 1
---------- 
/*
изначальна€ иде€ была следующа€: отсортировать по успеваемости, разделить последовательность на три множества(A-самые сильные,B-средние,C-слабые),
перебрать все возможные варианты выбора из каждого множества одного студента в одну из трех групп. “ем самым свести перебор с —39*—63*—33 = 1680 вариантов
до (—13*—12)^3 = 216 вариантов. ѕеребор пока что не получилось реализовать, реализовал выбор одного из таких 216 вариантов.

primary idea was: sort by score, divide the sequence into three sets(A-the strongest,B-the average, C-the weakest), iterate through all possible options
to peak one student from each set and put it to one of three groups. Thus, reduce the search from C 39*C 63*C 33 = 1680 options
to (C13*C12)^3 = 216 options. The search has not yet been implemented, so I have implemented the choice of one of these 216 options.
*/
drop table students;
create table students (id int, score int, groupid int);

insert into students values
(1, 7, 1),
(2, 9, 1),
(3, 8, 1),
(4, 5, 2),
(5, 3, 2),
(6, 4, 2),
(7, 9, 3),
(8, 4, 3),
(9, 6, 3);

alter table students
        add new_group int null;
                       
update students
        set new_group = 1 where id in(
                select id
                from (
                       select id,
                              row_number() over
                              (order by score desc) as rn
                       from students
                       order by score desc
                      )
                where (rn % 3 = 1 and rn/3 = 0)
                       or (rn % 3 = 0 and rn / 3 = 2)
                       or rn / 3 = 3);
update students                
        set new_group = 2 where id in(
                select id
                from (select id,
                             row_number() over
                             (order by score desc)  as rn
                      from students
                      order by score desc
                      )
                where (rn % 3 = 2 and rn/3 = 0)
                       or (rn % 3 = 2 and rn / 3 = 1)
                       or (rn % 3 = 1 and rn / 3 = 2));
update students                
        set new_group = 3 where id in(
                select id
                from (select id,
                             row_number() over
                             (order by score desc)  as rn
                      from students
                      order by score desc
                      )
                where (rn % 3 = 0 and rn/3 = 1)
                       or (rn % 3 = 1 and rn / 3 = 1)
                       or (rn % 3 = 2 and rn / 3 = 2));

alter table students
        drop column groupid;

alter table students 
        rename column new_group to groupid;

select *
from students
order by score desc;

select groupid, avg(score)
from students
group by groupid;
----------
-- 2
----------    
DROP TABLE racers;
CREATE TABLE
    racers
    (
        name VARCHAR(32),
        team VARCHAR(32),
        timetofirst INT
    );
    
insert into racers values
('Hamilton', 'Mersedes', 0),
('Vettel', 'Ferrari', 1),
('Raikonnen', 'Ferrari', 2),
('Bottas', 'Mersedes', 89),
('Ocon', 'Force', 90),
('Sainz', 'Renault', 91),
('Perez', 'Force', 123),
('Massa', 'Williams', 124),
('Kvyat', 'Toro Rosso', 125),
('Stroll', 'Williams', 127),
('Vandoorne', 'McLaren Honda', 131),
('Hartley', 'Toro Rosso', 138),
('Grosjean', 'Haas', 161),
('Ericsson', 'Sauber', 162);

CREATE TABLE
    racers_temp
    (
        id int GENERATED ALWAYS AS IDENTITY
              PRIMARY KEY NOT NULL,
        name VARCHAR(32),
        team VARCHAR(32),
        timetofirst INT
    );
    
insert into racers_temp(name, team, timetofirst)
        (select * from racers);

drop table racers;

rename racers_temp to racers;

select * from racers;

select id,
       name,
       team,
       timetofirst
from  racers
where id between 
           (select id
                   from(
                        select id, 
                               lead(timetofirst, 4, 0) over(order by id)  -  timetofirst as sum_gap
                        from racers) as rs
             where id + 4 <= (select count(*) from racers)
             order by sum_gap
             fetch first 1 rows only) 
             and
             (select id
                   from(
                        select id, 
                              lead(timetofirst, 4, 0) over(order by id)  -  timetofirst as sum_gap
                        from racers) as rs
             where id + 4 <= (select count(*) from racers)
             order by sum_gap
             fetch first 1 rows only) + 4

/*
-- это решение дл€ аналогичной задачи, только при условии что задано timetoprevious(ниже оно высчитываетс€ из timetofirst)
-- this is a solution for a similar problem, but if timetoprevious is set instead of timetofirst(it is calculated from timetofirst below)

alter table racers
        add column gap int null;

-- можно ли написать такой merge через update?
-- can we write the same merge through update?
        
MERGE INTO racers r
   USING (select name,
                 (racers.timetofirst - lag(racers.timetofirst, 1, 0)
                  over (order by racers.timetofirst)) as gap
          from racers) AS rs
   ON (r.name = rs.name)
   WHEN MATCHED THEN UPDATE SET r.gap = rs.gap;       

select * from racers;

select id,
       name,
       team,
       timetofirst
from  racers
where id between 
           (select id
                   from(
                        select id, 
                               lead(gap, 1, 0) over(order by id) +
                               lead(gap, 2, 0) over(order by id) +
                               lead(gap, 3, 0) over(order by id) +
                                lead(gap, 4, 0) over(order by id) as sum_gap
                        from racers) as rs
             where id + 4 <= (select count(*) from racers)
             order by sum_gap
             fetch first 1 rows only) 
             and
             (select id
                   from(
                        select id, 
                               lead(gap, 1, 0) over(order by id) +
                               lead(gap, 2, 0) over(order by id) +
                               lead(gap, 3, 0) over(order by id) +
                                lead(gap, 4, 0) over(order by id) as sum_gap
                        from racers) as rs
             where id + 4 <= (select count(*) from racers)
             order by sum_gap
             fetch first 1 rows only) + 4
;
*/ 

/*
-- извлечение групп students
select id,
         lag(id)
         over(order by score desc) as id2, 
         lead(id)
         over(order by score desc) as id3
from (
        select id, groupid, score
        from students
        order by score desc
        FETCH FIRST 3 ROWS ONLY)
limit 1, 1;

select id, groupid
from students
order by score desc
Limit 3, 3;

select id, groupid
from students
order by score desc
Limit 6, 3;
*/
;                          