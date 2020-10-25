-- store information about players and clubs+leagues they have ever played, this db created for education purpose
drop table player;

create table player(
        id int not null primary key,
        name varchar(100),
        second_name varchar(100),
        age smallint,
        weight smallint,
        height decimal(5,2),
        nationality varchar(100)
);

drop table club;

create table club(
        id int not null primary key,
        name varchar(100),
        league varchar(100)
);

drop table player_club;

create table player_club(
        player_id int not null,
        club_id int not null,
        primary key(player_id, club_id),
        foreign key (club_id) references club(id) on delete cascade,
        foreign key (player_id) references player(id) on delete cascade
        
);

-- as have noticed created automaticlly 
/*drop index i_p_id;

create unique index i_p_id
on player(id);*/

--drop index i_p_name;

create index i_p_name           -- for query like: select* from player where name="name" and second_name = "s_n";
        on player(name, second_name);

--drop index i_c_name;

create index i_c_name
        on club(name);

-- convert height from ft to cm
drop trigger height_convert;

create trigger height_convert
        AFTER 
        insert on player
        REFERENCING NEW AS nrow
        FOR EACH ROW
        when (nrow.height <= 10)
         update player
         set player.height = ceil(nrow.height * 30.48) -- do not like the fact that we need to use 'where' condition and cannot just 
                                                       -- refer to variable nrow, like: nrow = ceil(nrow.height * 30.48)
                                                       -- also i have some problems with construction begin end;
         where player.id = nrow.id; 
        

insert into player
values(1, 'cristiano', 'ronaldo', 37, 78, 6.5, 'Portuguese'),
       (2, 'toni', 'cross',34, 65, 185, 'German'),
       (3, 'marko', 'assensio', 23, 63, 6.2, 'Spanish'),
       (4, 'paulo', 'dibala', 24, 60, 179, 'Italian'),
       (5, 'david', 'silva', 24, 63, 185, 'Portuguese');

insert into club
values(1,'juventus','A-league'),
       (2, 'real madrid','la-league');
        
insert into player_club
values(1,2),
       (2,2),
       (3,2),
       (4,1),
       (1,1);

drop view player_club_league;  -- view for most extracted information

create view player_club_league(name, club, league) as 
        select p.name, c.name, c.league
        from player as p
                        inner join player_club as p_c 
                        on p.id = p_c.player_id
                        inner join club as c
                        on p_c.club_id = c.id;
                        
select *
from player_club_league;

select name,                               --example of using view
       count(club) as amount_of_clubs, 
       count(league) as amount_of_leagues
from player_club_league
group by name;

select club, league, count(*)
from player_club_league
group by rollup(club,league);

select club, league, count(*)
from player_club_league
group by cube(club,league);

select club, league, count(*)
from player_club_league
group by
grouping sets(club,league);

--examples of using olap

select *, 
        rank() over (order by weight desc) as weight_rank, 
        dense_rank() over(order by height desc) as height_rank,
        row_number() over(order by age) as age_number
from player;

select name, second_name, height, row_number() over(partition by nationality order by height) as height_number
from player;

