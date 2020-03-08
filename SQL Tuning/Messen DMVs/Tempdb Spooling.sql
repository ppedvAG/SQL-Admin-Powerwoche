select 
num_of_bytes_read, num_of_bytes_written, num_of_reads, num_of_writes
from sys.dm_io_virtual_file_stats(db_id('tempdb'),1)