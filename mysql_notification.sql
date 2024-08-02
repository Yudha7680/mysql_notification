show databases;

use mysql_notification;

show tables;

# User

create table user(
id varchar(100) not null,
name varchar(100) not null,
primary key (id)
) engine = innodb;

show tables;

insert into user(id, name) values ('yudha', 'Yudha Andika');
insert into user(id, name) values ('purwara', 'Yudha Purwara');

select * from user;

# Notification

create table notification(
id int not null auto_increment,
title varchar(255) not null,
detail text not null,
create_at timestamp not null,
user_id varchar(100),
primary key (id)
) engine = innodb;

show tables;

alter table notification
add constraint fk_notification_user
foreign key (user_id) references user (id);

desc notification;

insert into notification(title, detail, create_at, user_id)
values ('Contoh Pesanan', 'Detail Pesanan', current_timestamp(), 'yudha');

insert into notification(title, detail, create_at, user_id)
values ('Contoh Promo', 'Detail Promo', current_timestamp(), null);

insert into notification(title, detail, create_at, user_id)
values ('Contoh Pembayaran', 'Detail Pembayaran', current_timestamp(), 'purwara');

select * from notification;

select * from notification
where (user_id = 'yudha' or user_id is null)
order by create_at desc;

select * from notification
where (user_id = 'purwara' or user_id is null)
order by create_at desc;

# Category

create table category(
id varchar(100) not null,
name varchar(100) not null,
primary key (id)
) engine = innodb;

show tables;

alter table notification
add column category_id varchar(100);

desc notification;

alter table notification
add constraint fk_notification_category
foreign key (category_id) references category(id);

desc notification;

select * from notification;

insert into category(id, name) values ('INFO', 'Info');
insert into category(id, name) values ('PROMO', 'Promo');

select * from category;

update notification
set category_id = 'INFO'
where id = 1;

update notification
set category_id = 'PROMO'
where id = 2;

update notification
set category_id = 'INFO'
where id = 3;

select * from notification;

select * from notification
where (user_id = 'yudha' or user_id is null)
order by create_at desc;

select * from notification n
JOIN category c ON (n.category_id = c.id)
where (n.user_id = 'purwara' or n.user_id is null)
order by n.create_at desc;

# Notification Read
create table notification_read(
id int not null auto_increment,
is_read boolean not null,
notification_id int not null,
user_id varchar(100) not null,
primary key (id)
) engine = innodb;

show tables;

alter table notification_read
add constraint fk_notification_read_notification
foreign key (notification_id) references notification (id);

alter table notification_read
add constraint fk_notification_read_user
foreign key (user_id) references user (id);

desc notification_read;

select * from notification;

insert into notification_read(is_read, notification_id, user_id)
values (true, 2, 'yudha');

insert into notification_read(is_read, notification_id, user_id)
values (true, 2, 'purwara');

select * from notification_read;

select *
from notification n
JOIN category c ON (n.category_id = c.id)
left join notification_read nr on (nr.notification_id = n.id)
where (n.user_id = 'yudha' or n.user_id is null)
and (nr.user_id = 'yudha' or nr.user_id is null)
order by n.create_at desc;

insert into notification(title, detail, category_id, user_id, create_at)
values ('Contoh Pesanan Lagi', 'Detail Pesanan Lagi', 'INFO', 'yudha', current_timestamp());
insert into notification(title, detail, category_id, user_id, create_at)
values ('Contoh Promo Lagi', 'Detail Promo Lagi', 'PROMO', null, current_timestamp());

#Counter

select count(*)
from notification n
JOIN category c ON (n.category_id = c.id)
left join notification_read nr on (nr.notification_id = n.id)
where (n.user_id = 'yudha' or n.user_id is null)
and (nr.user_id is null)
order by n.create_at desc;

insert into notification_read(is_read, notification_id, user_id)
values (true, 4, 'yudha');

insert into notification_read(is_read, notification_id, user_id)
values (true, 5, 'yudha');

insert into notification_read(is_read, notification_id, user_id)
values (true, 1, 'yudha');

