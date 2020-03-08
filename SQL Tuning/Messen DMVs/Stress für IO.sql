use PerfIO;
GO
drop table iotest;
drop table iotest2;


create table iotest (id int identity, spx char(4100) );
GO

create table iotest2 (id int identity, spx char(4100) );
GO

alter procedure stressio_wr
as
insert into iotest values ('XX')
delete select * from iotest where id %2 =0

Alter procedure stressio_wr2
as
insert into iotest2 values ('XX')



Create procedure stressio_r
as
select * from iotest where id < 10000


select round(rand(n*n) *1000,0) from tuning.dbo.GetNums(1000)