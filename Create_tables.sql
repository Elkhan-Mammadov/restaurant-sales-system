
--Table menu_items

create table menu_items (
item_id number primary key,
item_name varchar2(100) not null,
price number(10,2) not null);


--Table sales 

create table sales (
sale_id number primary key,
sale_date date default sysdate,
total_amount number(10,2));


--Table sales_details


create table sales_details (
sale_detail_id number primary key,
sale_id number constraint sale_id_fk references sales(sale_id),
item_id number constraint item_id_fk references menu_items(item_id),
quantity number(5) not null,
line_total number(10,2));


--Sequences 

create sequence seq_menu_items;
create sequence seq_sales;
create sequence seq_sales_details;

--Table daily_sales_summary


create table daily_sales_summary (
report_date date primary key,
total_orders  number,
total_sales  number(12,2));


--Table daily_product_sales


create table daily_product_sales (
report_date  date,
product_id  number,
product_name varchar2(100),
total_quantity  number,
total_revenue  number(12,2),
primary key (report_date, product_id));