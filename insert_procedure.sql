--(Menu_items cədvəlinin insert ləri )
--Menu_items inserts


insert into menu_items (item_id, item_name, price) values (seq_menu_items.nextval, 'Çay', 0.80);
insert into menu_items (item_id, item_name, price) values (seq_menu_items.nextval, 'Kofe', 1.50);
insert into menu_items (item_id, item_name, price) values (seq_menu_items.nextval, 'Ayran', 1.20);
insert into menu_items (item_id, item_name, price) values (seq_menu_items.nextval, 'Kola', 1.00);
insert into menu_items (item_id, item_name, price) values (seq_menu_items.nextval, 'Limonad', 1.10);
insert into menu_items (item_id, item_name, price) values (seq_menu_items.nextval, 'Su', 0.50);
insert into menu_items (item_id, item_name, price) values (seq_menu_items.nextval, 'Pizza', 8.00);
insert into menu_items (item_id, item_name, price) values (seq_menu_items.nextval, 'Burger', 5.00);
insert into menu_items (item_id, item_name, price) values (seq_menu_items.nextval, 'Döner', 2.00);
insert into menu_items (item_id, item_name, price) values (seq_menu_items.nextval, 'Lahmacun', 2.50);
insert into menu_items (item_id, item_name, price) values (seq_menu_items.nextval, 'Donut', 2.50);
insert into menu_items (item_id, item_name, price) values (seq_menu_items.nextval, 'Keks', 2.00);
insert into menu_items (item_id, item_name, price) values (seq_menu_items.nextval, 'Tort', 4.00);
insert into menu_items (item_id, item_name, price) values (seq_menu_items.nextval, 'Sandviç', 3.00);



--Sifarişlərin adı və sayi üçun  nested table 
--Nested table for name and number of orders 

create or replace type item_name_ntt as table of varchar2(100);
create or replace type item_number_ntt as table of number;



--Sifarişin daxil edilməsi proseduru
--Procedure for insert orders


create or replace procedure insert_sale(
p_item_names  item_name_ntt,
p_quantities  item_number_ntt
) 
is
v_item_id  menu_items.item_id%type;
v_price  menu_items.price%type;
v_total  number := 0;
v_sale_id  sales.sale_id%type;

begin
 
if p_item_names.count <> p_quantities.count then
raise_application_error(-20001, 'Məhsul sayı ilə sifariş sayı uyğun deyil.');
end if;

v_sale_id := seq_sales.nextval;

insert into sales(sale_id, sale_date, total_amount)
values (v_sale_id, sysdate, 0);

for i in 1 .. p_item_names.count loop
select item_id, price into v_item_id, v_price
from menu_items
where lower(item_name) = lower(p_item_names(i));

insert into sales_details(
sale_detail_id,sale_id,item_id,quantity,line_total) 
values 
(seq_sales_details.nextval,v_sale_id,v_item_id,
p_quantities(i),p_quantities(i) * v_price );


v_total := v_total + (p_quantities(i) * v_price);

end loop;

update sales set total_amount = v_total where sale_id = v_sale_id;

end;
/



