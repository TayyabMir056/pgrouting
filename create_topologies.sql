-- FUNCTION: public.create_topologies(integer, double precision)

-- DROP FUNCTION public.create_topologies(integer, double precision);

-- SELECT create_topologies(1,0.1)
-- SELECT * FROM floorplan_ddassetgeom;

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
	'DROP TABLE IF EXISTS routes.edges_f'||floor_id;
	
	sql_create_ftable VARCHAR(250):= 
	'CREATE TABLE routes.edges_f'||floor_id|| '
	(id serial, source integer, target integer, cost double precision, reverse_cost double precision, the_geom geometry,floor_id integer)';
	
	sql_insert_data VARCHAR(500) := 'INSERT INTO routes.edges_f'||floor_id|| ' 
	(source,target,cost,reverse_cost,the_geom,floor_id) 
	SELECT NULL as source, NULL as target, NULL as cost, NULL as reverse_cost,line,floor_id FROM public.floorplan_ddpathgeom 
	WHERE floor_id='||floor_id;
	
	sql_insert_assets_as_vertices VARCHAR (500):=
	'UPDATE routes.edges_f'||floor_id||' e 
	SET the_geom = st_addpoint(e.the_geom,ST_LineInterpolatePoint(e.the_geom,ST_LineLocatePoint(e.the_geom,a.location)))
	FROM floorplan_ddassetgeom a
	WHERE st_intersects(e.the_geom,st_buffer(a.location,'||tolerance||'))=true';
	
	sql_create_nodes VARCHAR(250):=
	'SELECT pgr_nodenetwork(''routes.edges_f'||floor_id||''',' || tolerance || '  )';
	
	sql_create_topology VARCHAR(250):=
	'SELECT  pgr_createTopology( ''routes.edges_f'||floor_id ||'_noded'' , '|| tolerance ||')';
	
	sql_validate_assets VARCHAR(500):='
	UPDATE floorplan_ddassetgeom set node_id = NULL WHERE floor_id='||floor_id||';
	UPDATE floorplan_ddassetgeom a SET node_id = n.id 
	FROM  routes.edges_f'||floor_id||'_noded_vertices_pgr n
	WHERE st_contains(st_buffer(a.location,'||tolerance||'),n.the_geom)=true;
	'; 

BEGIN
	EXECUTE sql_drop_ftable; -- DELETE edges table for specified floor if exists
	EXECUTE sql_create_ftable; -- CREATE edges table for specified floor
	EXECUTE sql_insert_data; -- INSERT DATA into created edges table from the parent table for the required floor
	EXECUTE sql_insert_assets_as_vertices;
	
	EXECUTE sql_create_nodes; -- CONVERT ALL vertices of edges table into nodes
	EXECUTE sql_create_topology; -- Create Topology (Take the noded table and update source and target columns, also create pgr_vertices t )
	EXECUTE sql_validate_assets; -- VALIDATES assets by assigning the nearest node id in assets table, if node_id stays null, the point must be out of threshould
	
	
	RETURN 1;
END; $BODY$;

ALTER FUNCTION public.create_topologies(integer, double precision)
    OWNER TO postgres;
