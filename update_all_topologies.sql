CREATE OR REPLACE FUNCTION update_all_topologies (tolerence double precision) 
	RETURNS integer 
AS $$
DECLARE 
    _floor_id integer;
BEGIN
	FOR _floor_id IN(
		SELECT DISTINCT floor_id FROM floorplan_ddpathgeom )  
	LOOP
        PERFORM create_topologies(_floor_id,tolerence);
        
	END LOOP;
	RETURN 1;
END; $$ 
LANGUAGE 'plpgsql';


--SELECT update_all_topologies (0.01);
