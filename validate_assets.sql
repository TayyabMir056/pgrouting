-- FUNCTION: public.validate_assets(integer, double precision)

-- DROP FUNCTION public.validate_assets(integer, double precision);

CREATE OR REPLACE FUNCTION public.validate_assets(
	floor_id integer,
	tolerance double precision)
    RETURNS integer
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    
AS $BODY$
DECLARE 
	sql_set_null VARCHAR (350);
	sql_update_edge_id VARCHAR(350);
	sql_update_fraction VARCHAR (350);
BEGIN
	
	sql_set_null:=
	'UPDATE floorplan_ddassetgeom SET edge_id =NULL, fraction = NULL WHERE floor_id=  '||floor_id; 
	
	sql_update_edge_id:=
	'UPDATE floorplan_ddassetgeom f
	SET edge_id = (SELECT e.id 
		FROM routes.edges_f'||floor_id||'_noded e
		WHERE st_intersects(e.the_geom,st_buffer(f.location,'||tolerance||'))=true
		AND f.floor_id='||floor_id||'
		ORDER BY  st_distance(e.the_geom,f.location) limit 1 )';
	
	sql_update_fraction:=
	'UPDATE floorplan_ddassetgeom f
		SET fraction=  ST_LineLocatePoint(e.the_geom,f.location) 
		FROM  routes.edges_f'||floor_id||'_noded e
		WHERE f.edge_id=e.id
		AND f.floor_id='||floor_id
		;
		
	EXECUTE sql_set_null;
	EXECUTE sql_update_edge_id;
	EXECUTE sql_update_fraction;
	
	
	
	RETURN 1;
END; $BODY$;

ALTER FUNCTION public.validate_assets(integer, double precision)
    OWNER TO postgres;
