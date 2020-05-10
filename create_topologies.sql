-- FUNCTION: public.create_topologies(integer, double precision)

-- DROP FUNCTION public.create_topologies(integer, double precision);

CREATE OR REPLACE FUNCTION public.create_topologies(
	floor_id integer,
	tolerance double precision)
    RETURNS integer
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    
AS $BODY$
DECLARE 
	sql_drop_ftable VARCHAR(250) := 
	'DROP TABLE IF EXISTS routes.edges_f'||floor_id||';
	DROP TABLE IF EXISTS routes.edges_f'||floor_id||'_noded;
	DROP TABLE IF EXISTS routes.edges_f'||floor_id||'_noded_vertices_pgr;';
	
	sql_create_ftable VARCHAR(250):= 
	'CREATE TABLE routes.edges_f'||floor_id|| '
	(id serial, source integer, target integer, cost double precision, reverse_cost double precision, the_geom geometry,floor_id integer)';
	
	sql_insert_data VARCHAR(500) := 'INSERT INTO routes.edges_f'||floor_id|| ' 
	(source,target,cost,reverse_cost,the_geom,floor_id) 
	SELECT NULL as source, NULL as target, NULL as cost, NULL as reverse_cost,line,floor_id FROM public.floorplan_ddpathgeom 
	WHERE floor_id='||floor_id;
	

	
	sql_create_nodes VARCHAR(250):=
	'SELECT pgr_nodenetwork(''routes.edges_f'||floor_id||''',' || tolerance || '  )';
	
	sql_create_topology VARCHAR(250):=
	'SELECT  pgr_createTopology( ''routes.edges_f'||floor_id ||'_noded'' , '|| tolerance ||')';

BEGIN
	EXECUTE sql_drop_ftable; -- DELETE edges table for specified floor if exists
	EXECUTE sql_create_ftable; -- CREATE edges table for specified floor
	EXECUTE sql_insert_data; -- INSERT DATA into created edges table from the parent table for the required floor
	
	EXECUTE sql_create_nodes; -- CONVERT ALL vertices of edges table into nodes
	EXECUTE sql_create_topology; -- Create Topology (Take the noded table and update source and target columns, also create pgr_vertices t )
	
	
	
	RETURN 1;
END; $BODY$;

ALTER FUNCTION public.create_topologies(integer, double precision)
    OWNER TO postgres;
