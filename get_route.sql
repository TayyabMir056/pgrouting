-- FUNCTION: public.get_route(integer, character varying)

-- DROP FUNCTION public.get_route(integer, character varying);

--SELECT * FROM get_route(1,'12,13,14,16')

CREATE OR REPLACE FUNCTION public.get_route(
	floor_id integer,
	asset_ids character varying)
    RETURNS TABLE(seq bigint, geom geometry, gjson text) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
    
AS $BODY$
BEGIN
    RETURN QUERY 
	EXECUTE
	'select fd.seq as seq,
       fd.geo as geo,
	   st_astext(fd.geo) as gjson
from   (
  SELECT ROW_NUMBER() OVER (ORDER BY now() ASC) AS seq,
         (
           SELECT (ST_Collect(pgr_djik.geo))
           FROM   (
             SELECT e.the_geom as geo
             FROM   pgr_dijkstra(''SELECT id, source, target, 
								 st_length(the_geom) as cost 
		FROM routes.edges_f'||floor_id||'_noded'', orig, dest, false) AS r,
                    routes.edges_f'||floor_id||'_noded AS e
             WHERE r.edge = e.id
           ) AS pgr_djik
         ) AS geo
  FROM (
    select unnest(tsp_result[:array_upper(tsp_result,1)-1]) as orig,
           unnest(tsp_result[2:]) as dest
    from  (
      SELECT array_agg(node) tsp_result FROM pgr_TSP(
	  	--pgr_djikstraCostMatrix
    	''SELECT * FROM pgr_dijkstraCostMatrix(
        ''''SELECT id, source, target, st_length(the_geom) as cost 
		FROM routes.edges_f'||floor_id||'_noded'''',
        (SELECT array_agg(node_id) FROM floorplan_ddassetgeom where id IN ('||asset_ids||') and node_id is not null),
        directed := false)'',
    randomize := false) tsp_result
    ) tsp_result_array
  ) tsp_nodes_orig_dest
) fd
where fd.geo is not null;';
END;
$BODY$;

ALTER FUNCTION public.get_route(integer, character varying)
    OWNER TO postgres;
