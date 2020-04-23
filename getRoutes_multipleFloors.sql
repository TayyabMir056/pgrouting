CREATE OR REPLACE FUNCTION get_routes () 
	RETURNS TABLE (
		floor_id integer
) AS $$
DECLARE 
    _floor_id integer;
BEGIN
	FOR _floor_id IN(
		SELECT DISTINCT S.floor_id FROM sample_edge_table S)  
	LOOP
        floor_id := _floor_id;
        RETURN NEXT;
	END LOOP;
END; $$ 
LANGUAGE 'plpgsql';