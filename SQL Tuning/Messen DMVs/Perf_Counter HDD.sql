--Perfocounter HDD
Avg. Disk sec/Read
Avg. Disk sec/Write
--These give the time in milliseconds it takes to complete an IO. 
--If these numbers are consistently higher (or have regular higher spikes) than the norm (which should be between 5ms and 12ms), 

SELECT object_name, counter_name, instance_name, cntr_value, cntr_type
FROM sys.dm_os_performance_counters where counter_name like 'AVG%Disk%' and object_name like 'physical%';

select * from sys.sysperfinfo