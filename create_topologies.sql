CREATE OR REPLACE FUNCTION create_topologies (floor_id integer,tolerance double precision) 
	RETURNS integer 
AS $$
DECLARE 
	sql_drop_ftable VARCHAR(250) := 'DROP TABLE IF EXISTS routes.edges_f'||floor_id;
	sql_create_ftable VARCHAR(250):= 'CREATE TABLE routes.edges_f'||floor_id|| ' (id serial, source integer, target integer, cost double precision, reverse_cost double precision, the_geom geometry,floor_id integer)';
	sql_insert_data VARCHAR(500) := 'INSERT INTO routes.edges_f'||floor_id|| ' (source,target,cost,reverse_cost,the_geom,floor_id) SELECT NULL as source, NULL as target, NULL as cost, NULL as reverse_cost,line,floor_id FROM public.floorplan_ddpathgeom WHERE floor_id='||floor_id;
	
	sql_create_nodes VARCHAR(250):= 'SELECT pgr_nodenetwork(''routes.edges_f'||floor_id||''',' || tolerance || '  )';
	sql_create_topology VARCHAR(250):='SELECT  pgr_createTopology( ''routes.edges_f'||floor_id ||'_noded'' , '|| tolerance ||')';

BEGIN
	EXECUTE sql_drop_ftable; -- DELETE edges table for specified floor if exists
	EXECUTE sql_create_ftable; -- CREATE edges table for specified floor
	EXECUTE sql_insert_data; -- INSERT DATA into created edges table from the parent table for the required floor
	
	
	EXECUTE sql_create_nodes; -- CONVERT ALL nodes into vertices
	EXECUTE sql_create_topology; -- 
	
	RETURN 1;
END; $$ 
LANGUAGE 'plpgsql';

--select create_topologies(1,0.001);
