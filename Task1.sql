DROP TABLE IF EXISTS Users, Tasks, Projects cascade;

create table Users
(
    name       varchar(32) not null,
    login      varchar(32),
    email      varchar(32),
    department varchar(32) check (department in
                                  ('Производство', 'Поддержка пользователей', 'Бухгалтерия', 'Администрация')),
    primary key (login)
);

create table Projects
(
    name        varchar(32),
    description text,
    date_on     date NOT NULL,
    date_off    date,
    primary key (name)
);

create table Tasks
(
    project     varchar(32),
    header      varchar(32)                                                                      not null,
    task_num    integer,
    priority    integer                                                                          not null,
    description text,
    status      varchar(16) check (status in ('Новая', 'Переоткрыта', 'Закрыта', 'Выполняется')) not null,
    estimate    integer,
    spent       integer,
    date_on     date,
    creator     varchar(32),
    responsible varchar(32),
    foreign key (project) references Projects (name),
    foreign key (creator) references Users (login),
    foreign key (responsible) references Users (login)
);
insert into Users(name, login, email, department)
values ('Касаткин Артем', 'a.kasatkin', 'a.kasatkin@ya.ru', 'Администрация'),
       ('Петрова София', 's.petrova', 's.petrova@ya.ru', 'Бухгалтерия'),
       ('Дроздов Федр', 'f.drozdov', 'f.drozdov@ya.ru', 'Администрация'),
       ('Иванова Василина', 'v.ivanova', 'v.ivanova@ya.ru', 'Бухгалтерия'),
       ('Беркут Алексей', 'a.berkut', 'a.berkut@ya.ru', 'Поддержка пользователей'),
       ('Белова Вера', 'v.belova', 'v.belova@ya.ru', 'Производство'),
       ('Макенрой Алексей', 'a.makenroy', 'a.makenroy@ya.ru', 'Производство');

insert into Projects(name, date_on, date_off)
values ('РТК', '31/01/2016', NULL),
       ('СС.Контент', '23/02/2015', '31/12/2016'),
       ('Демо-Сибирь', '11/05/2015', '31/01/2015'),
       ('МВД-Онлайн', '22/05/2015', '31/01/2016'),
       ('Поддержка', '07/06/2016', NULL);

insert into Tasks(project, header, task_num, priority, status, creator, responsible, date_on, estimate, spent)
values ('Поддержка', 'Task1', 1, 12, 'Новая', 's.petrova', 'a.berkut', null, 10, 15),
       ('Демо-Сибирь', 'Task2', 8,  228, 'Новая', 's.petrova', 's.petrova', '2/3/2015', 52, 22),
       ('РТК', 'Task3', 7,  1337, 'Новая', 'a.makenroy', 's.petrova', null, 12, 12),
       ('Демо-Сибирь', 'Task4', 6 , 10, 'Новая', 'v.ivanova', 'a.makenroy', null, 1, 100),
       ('МВД-Онлайн', 'Task5', 5,  61, 'Закрыта', 'a.berkut', 's.petrova', null, 12, 22),
       ('Поддержка', 'Task6', 3,  127, 'Новая', 's.petrova', 'a.makenroy', '1/2/2015', 12, 12),
       ('РТК', 'Task7', 4, 19,  'Новая', 'a.makenroy', 'v.belova', null, 22, 35),
       ('Демо-Сибирь', 'Task8', 2,  1, 'Новая', 's.petrova', 'a.makenroy', null, 94, 12),
       ('МВД-Онлайн', 'Task9', 10,  1, 'Новая', 'v.ivanova', 'a.kasatkin', '1/1/2016', 88, 24),
       ('Демо-Сибирь', 'Task10', 8,  11, 'Новая', 'a.kasatkin', 'a.makenroy', null, 99, 2),
       ('РТК', 'Task11', 9,  22, 'Новая', 'v.ivanova', 'a.berkut', null, NULL, NULL),
       ('Демо-Сибирь', 'Task12', 12,  3, 'Закрыта', 'a.makenroy', 'f.drozdov', null, 66, 32),
       ('СС.Контент', 'Task13', 13,  1, 'Новая', 'a.makenroy', 'a.kasatkin', '1/2/2016', 99, 2),
       ('СС.Контент', 'Task14', 14,  20, 'Новая', 'a.makenroy', 'a.kasatkin', '1/3/2016', 22, 3),
       ('СС.Контент', 'Task15', 16,  20, 'Новая', 'a.makenroy', NULL, '4/5/2015', null, null);

--3a---
select *
from Tasks;

--3b--
select name, department
from Users;

--3c--
select login, email
from Users;

--3d--
select header
from Tasks
where (priority > 50);

--3e--
select distinct responsible
from Tasks
where responsible is not null;

--3f--
select creator
from Tasks
union
select responsible
from Tasks;

--3k--
select header
from Tasks
where (creator != 's.petrova')
  AND (responsible IN ('v.ivanova', 'a.makenroy', 'a.berkut'));

--4--
select header
from Tasks
where (responsible like '%kasatkin%')
  and (date_on in ('1/1/2016', '1/2/2016', '1/3/2016'));

--5--
select t.header, d.department
from Tasks t,
     Users d
where t.responsible like '%petrov%'
  and t.creator = d.login
  and d.department in ('Администрация', 'Бухгалтерия', 'Производство');

--6--
select *
from Tasks
where responsible is null;

update Tasks
set responsible = 's.petrova'
where responsible is null;

--7--
drop table if exists tasks2;

create table tasks2 as
select *
from Tasks;

--8a--
select *
from Users
where (name not like '%а_%а');

--8b--
select *
from Users
where (login like 'a%' and login like '%r%');