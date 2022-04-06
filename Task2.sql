--1--
select responsible, avg(priority) as average
from tasks
group by responsible
order by average desc
limit 3;

--2--
select concat('TASK COUNT ', count(task_num),
              ' - MONTH ', extract(MONTH from date_on), ' - CREATOR ', login) as status
from tasks,
     users
where tasks.creator = users.login
  and tasks.date_on is not null
  and extract(YEAR from date_on) = 2015
group by users.login, extract(MONTH from date_on);

--3a--
select login executor, sum(first.estimate - first.spent) "-", sum(second.spent - second.estimate) "+"
from users,
     tasks first,
     tasks second
where users.login = first.responsible
  and first.responsible = second.responsible
  and first.estimate > first.spent
  and second.spent > second.estimate
group by login;

--3b--
select login executor, sum(a.under) as "-", sum(b.over) as "+"
from users,
     (select (estimate - spent) as under, responsible
      from tasks
      where estimate > spent) as a,

     (select (spent - estimate) as over, responsible
      from tasks
      where spent > estimate) as b
where users.login = a.responsible
  and a.responsible = b.responsible
group by login;

--4--
select creator, responsible
from tasks
where creator > tasks.responsible
union
select creator, responsible
from tasks
where creator = tasks.responsible;

--5--
select login
from users
order by length(login) desc
limit 1;

--6--
drop table if exists char_tbl, varchar_tbl;
create table char_tbl
(
    str char(16)
);

create table varchar_tbl
(
    str varchar(16)
);

insert into char_tbl
values ('HELLO WORLD');
insert into varchar_tbl
values ('ПAAAA WORLD');

select sum(pg_column_size(char_tbl.str)) "char", sum(pg_column_size(varchar_tbl.str)) "varchar"
from char_tbl,
     varchar_tbl;

--7--
select responsible, max(priority)
from
     tasks

group by responsible;

--8--
select responsible, sum(estimate)
from tasks
where (estimate >= (select avg(estimate) from tasks))
group by responsible;

--9--
drop view if exists task_view;

create view task_view as
select tasks.responsible,
       count(tasks.responsible)  as amount,

       (select count(ontime.header)
        from (select header, responsible from tasks where (tasks.spent - tasks.estimate) > 0)
                 as ontime
        where ontime.responsible = tasks.responsible
        group by ontime.responsible)   as on_time,

       (select count(ontime.header)
        from (select header, responsible from tasks where (tasks.spent - tasks.estimate) <= 0)
                 as ontime
        where ontime.responsible = tasks.responsible
        group by ontime.responsible)   as late,

       (select count(opened.header)
        from (select header, responsible from tasks where tasks.status in ('Новая'))
                 as opened
        where opened.responsible = tasks.responsible
        group by opened.responsible)   as opened,

       (select count(closed.header)
        from (select header, responsible from tasks where tasks.status in ('Закрыта'))
                 as closed
        where closed.responsible = tasks.responsible
        group by closed.responsible)   as closed,

       (select sum(spend.spent)
        from (select spent, responsible from tasks)
                 as spend
        where spend.responsible = tasks.responsible
        group by spend.responsible)    as spended,

       (select avg(priority)
        from (select priority, responsible from tasks)
                 as priority
        where priority.responsible = tasks.responsible
        group by priority.responsible) as pri,

       (select avg(estimate)
        from (select estimate, responsible from tasks)
                 as priority
        where priority.responsible = tasks.responsible
        group by priority.responsible) as time_pri,

       (select max(spent)
        from (select spent, responsible from tasks)
                 as priority
        where priority.responsible = tasks.responsible
        group by priority.responsible) as max_time

from tasks
group by tasks.responsible;

select *
from task_view;

--10--
select login, header
from tasks,
     users
where tasks.responsible = users.login;

select login
from users
where login in (select responsible from tasks where priority > 80);

select login, department
from users
where login in (select responsible from tasks where users.department = tasks.description);