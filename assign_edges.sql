-- Function to validate the asset points and assign the nearest line id to it within the given tolerance

CREATE OR REPLACE FUNCTION assign_edges ( tolerance double precision) 
	RETURNS integer 
AS $$
DECLARE 
	sql_insert VARCHAR(250); 
    	rec record;
BEGIN
	-- Create a temporary table to add all the newly created topologies in a single table  
	DROP TABLE if exists routes.tmp_edges_combined;
	CREATE  TABLE routes.tmp_edges_combined(
		id integer,
		geom geometry,
		floor_id integer
	);
	--Loop through All the tables in the routes schema for noded table 
	FOR rec IN(
		SELECT table_name,replace(replace(table_name,'edges_f',''),'_noded','') AS floor_id 
		FROM information_schema.tables 
		WHERE table_schema = 'routes'
		and table_name like '%_noded'
		)
 
	LOOP
	--Insert all the noded tables data with their floor id in the temporary table
        sql_insert := 'INSERT INTO routes.tmp_edges_combined (id,geom,floor_id) SELECT id,the_geom,'||rec.floor_id || ' AS floorid from routes.' || rec.table_name;
		EXECUTE sql_insert;
	END LOOP;
	
	--Empty all the edge ids if exist before
	UPDATE floorplan_ddassetgeom SET edge_id =NULL; 
	
	
	-- From the newly created temp table, get the edge_id by joining the assets such that they are in same floor and the line lies in a buffer of each asset as per given tolerance.
	UPDATE floorplan_ddassetgeom f  
	SET edge_id = 
		e.id FROM routes.tmp_edges_combined e
		WHERE st_intersects(e.geom,st_buffer(f.location,0.1))=true
		AND e.floor_id=f.floor_id;
	RETURN 1;
END; $$ 
LANGUAGE 'plpgsql';


--SELECT assign_edges(0.001); -- To execute
