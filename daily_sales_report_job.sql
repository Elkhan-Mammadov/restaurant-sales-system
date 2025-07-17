begin
dbms_scheduler.create_job (
job_name  =>'daily_sales_report_job',
job_type  =>'stored_procedure',
job_action =>'pr_daily_sales_report',
start_date =>trunc(sysdate) + 23/24 + 59/(24*60),
repeat_interval =>'FREQ=DAILY; BYHOUR=23; BYMINUTE=59; BYSECOND=0',
enabled   =>TRUE );
end;
/