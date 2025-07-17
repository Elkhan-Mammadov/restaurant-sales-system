create or replace directory sales_dir as 'Your path';
grant read, write on directory sales_dir to user_name;



create or replace procedure pk_weekly_sales_report is
v_start_date  date;
v_end_date  date;
v_file  utl_file.file_type;
v_file_name varchar2(100);
v_directory_name constant varchar2(30) := 'sales_dir';
v_total_orders number;
v_total_sales  number;

begin
 
v_start_date := trunc(sysdate, 'iw');
v_end_date := v_start_date + 6;

  
v_file_name := 'weekly_sales_report_' || to_char(v_start_date, 'yyyy-mm-dd') || '_' || to_char(v_end_date, 'yyyy-mm-dd') || '.txt';


v_file := utl_file.fopen(v_directory_name, v_file_name, 'w');

  
select count(*), sum(nvl(total_amount, 0))
into v_total_orders, v_total_sales
from daily_sales_summary
where report_date between v_start_date and v_end_date;


utl_file.put_line(v_file, '----- WEEKLY SALES REPORT----');
utl_file.put_line(v_file, 'Date Range: ' || to_char(v_start_date, 'yyyy-mm-dd') || ' to ' || to_char(v_end_date, 'yyyy-mm-dd'));
utl_file.put_line(v_file, '-------------------------------------------');
utl_file.put_line(v_file, 'Total Orders: ' || v_total_orders);
utl_file.put_line(v_file, 'Total Sales: ' || to_char(v_total_sales, '999,999,990.00'));
utl_file.put_line(v_file, '------------------------------------------- ');


utl_file.put_line(v_file, '-----Product Sales This Week------');
utl_file.put_line(v_file, rpad('Product Name', 30) || rpad('Quantity', 12) || 'Sales Amount');
utl_file.put_line(v_file, '-----------------------------------------------------------------');

for rec in (
select product_name,
sum(total_quantity) as total_qty,
sum(total_revenue) as total_amount
from daily_product_sales
where report_date between v_start_date and v_end_date
group by product_name
order by product_name) loop

utl_file.put_line(v_file,
rpad(rec.product_name, 30) ||
rpad(rec.total_qty, 12) ||
to_char(rec.total_amount, '999,999,990.00'));

end loop;

utl_file.put_line(v_file,' ');
utl_file.put_line(v_file,' ');
utl_file.put_line(v_file,' ');
utl_file.put_line(v_file,'------------------------------------------------------------ ');
utl_file.fclose(v_file);

dbms_output.put_line('report created at ' || systimestamp);


exception
when others then
if utl_file.is_open(v_file) then
utl_file.fclose(v_file);
end if;
dbms_output.put_line('Error: ' || sqlerrm);
end;
/


