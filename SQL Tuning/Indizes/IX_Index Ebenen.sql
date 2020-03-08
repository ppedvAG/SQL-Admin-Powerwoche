--Indexoptimierung ist nur dann von Vorteil, wenn die Indexebenen reduziert werden
select index_id,index_type_desc,index_depth
      ,index_level,page_count,record_count
  from sys.dm_db_index_physical_stats(db_id(),object_id('T1')
                                     ,null,null,'detailed')