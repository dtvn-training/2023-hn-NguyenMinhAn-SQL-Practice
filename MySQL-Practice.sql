
use pos_system;

# 1. DCL PRACTICE

select user();
show grants for root;

create user 'test'@'localhost' identified by "pass123";
select user, host from mysql.user;

grant all privileges on *.* to 'test'@'localhost';
show grants for test@localhost;








# 2. DDL PRACTICE     

create database pos_system;
create table products (
	id int(11) not null,
    name varchar(255),
	description varchar(255) not null,
    price double not null
);

describe products;

drop table products;

create table products (
	id int not null,
    name varchar(255) not null,
    description varchar(255) not null,
    primary key (id)
);

drop table products;

create table products (
	id int not null,
    name varchar(255), 
    code varchar(20),
    description varchar(255) not null,
    unique (code),
    primary key (id)
);

drop table products;
create table product_categories (
	id int primary key,
    name varchar(255) 
);

create table products (
	id int(11) not null primary key,
    name varchar(255) not null, 
    product_category_id int(11), 
    constraint FK_category foreign key (product_category_id) references product_categories(id)
);

# TEST VIEW
create view ProductsView as
select name, product_category_id 
from products;

select * from ProductsView;
drop view ProductsView;

alter database pos_system character set = ascii;

alter table products 
add (
	price double,
    description varchar(255)
);

alter table products 
modify description varchar(1000);

alter table products 
add index index_p_category(product_category_id);

alter table product_categories 
rename to product_categories_list;









# 3. DML

insert into products values 
(1, "Rice", 3, 40000, "Rice"),
(2, "Fried Rice", 3, 50000, "Fried Rice"),
(3, "Tea", 3, 20000, "Tea"),
(4, "Milk Tea", 3, 20000, "Milk Tea"),
(5, "Red bull", 3, 23000, "Red bull"),
(6, "Nutri", 3, 24000, "Nutri"),
(7, "Lavie", 3, 5000, "Lavie"),
(8, "C2", 3, 9000, "C2"),
(9, "Egg", 3, 1000, "Egg"),
(10, "C3", 3, 9000, "C2"),
(11, "C4", 3, 9000, "C2");

insert into product_categories values 
(1, "Drink"),
(2, "Food"),
(3, "Other");

drop table product_categories_list;

select * from products, product_categories_list;

update products set price = 35000 where id = 6;

select * from products;

select distinct product_category_id
from products;

select * from products 
order by price desc, id asc;

select * from products limit 2;

select name from products
where price in (20000, 30000);

select count(*) as count_coffee from products 
where name like "%ff%";

select product_category_id, sum(price) as total, count(product_category_id) as quantity
from products
group by product_category_id
having sum(price) < 100000
order by sum(price) asc;

select name, price from products 
where product_category_id in 
(select id from product_categories_list where name in ("Coffee", "Drink"));


select product_category_id from products union select id from product_categories_list;

select products.name, product_categories_list.name 
from products inner join product_categories_list 
on products.product_category_id = product_categories_list.id;

select products.name, product_categories_list.name 
from products right join product_categories_list 
on products.product_category_id = product_categories_list.id;







# 4. TCL

start transaction;
delete from products where id = 3;
savepoint sp1;
delete from products where id = 2;
rollback to savepoint sp1;
commit;

start transaction;
savepoint sp;
drop table products;
rollback to savepoint sp;
commit;

select * from products;










# Advanced

explain select * from products where name like "%av%";

explain analyze select * from products where name like "%ed%";

# Test Index Selectivity

select count(distinct product_category_id)/count(*) as sel1,
count(distinct left(name, 2)) / count(*) as sel2,
count(distinct left(name, 3)) / count(*) as sel3,
count(distinct left(name, 4)) / count(*) as sel4
from products;

# Test Composite Index

create index name_price on products (`name`, `price`);

explain select * from products where name = 'C2';
explain select * from products where price = 9000;
explain select * from products where name = 'C2' and price = 9000;

# Test Index Merge

create index name_idx on products (`name`);
create index price_idx on products (`price`);
explain select * from products where name = 'C2' or price = 9000;

















