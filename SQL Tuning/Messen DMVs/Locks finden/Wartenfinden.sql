--Running: Startet danmit
--Supsended: falls Werte geholt werden müssen... Supsended vom Buffer Pool
--Runnable: sind die Werte da, dann Runnable..muss nun aber auf CPU warten

use tuning
drop table dummytable;
GO
create table dummytable (id int,sp1  varchar(8000))

declare @i as int = 0
While @i < 200
begin
    begin transaction
    insert into dummytable values (1, replicate('x', 8000))

    commit transaction
    set @i=@i+1
end


create event session CollWaitstats
ON Server
Add Event sqlos.wait_info
    (where  Sqlserver.session_id=59)
    Add target package0.event_file
	  (set filename = 'c:\_backup\eventsession.xel')
GO


Alter event session Collwaitstats
ON Server
	  State=Start
    GO


---insert

declare @i as int = 0
While @i < 200
begin
    begin transaction
    insert into dummytable values (1, replicate('x', 8000))

    commit transaction
    set @i=@i+1
end

drop event session collwaitstats
ON Server
