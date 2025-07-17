create or replace procedure pr_daily_sales_report is

v_report_date date := trunc(sysdate);
begin
  
insert into daily_sales_summary(report_date, total_orders, total_sales)
select v_report_date,
count(distinct s.sale_id),
nvl(sum(sd.line_total),0)
from sales s
left join sales_details sd on s.sale_id = sd.sale_id
where trunc(s.sale_date) = v_report_date;

  
insert into daily_product_sales(report_date, product_id, product_name, total_quantity, total_revenue)
select v_report_date,
m.item_id,
m.item_name,
nvl(sum(sd.quantity),0),
nvl(sum(sd.line_total),0)
from sales s
join sales_details sd on s.sale_id = sd.sale_id
join menu_items m on sd.item_id = m.item_id
where trunc(s.sale_date) = v_report_date
group by m.item_id, m.item_name;

commit;

end;
/