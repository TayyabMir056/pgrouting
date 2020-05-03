-- FUNCTION: public.get_route(integer, character varying)

-- DROP FUNCTION public.get_route(integer, character varying);

CREATE OR REPLACE FUNCTION public.get_route(
	floor_id integer,
	asset_ids character varying)
    RETURNS TABLE(seq bigint, geom geometry) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
    
AS $BODY$
BEGIN
    RETURN QUERY 
	EXECUTE
	'select fd.seq as seq,
       fd.geo as geo
from   (
  SELECT ROW_NUMBER() OVER (ORDER BY now() ASC) AS seq,
         (
           SELECT (ST_Collect(foo.geo))
           FROM   (
             SELECT e.the_geom as geo
             FROM   pgr_dijkstra(''SELECT id, source, target, 
								 st_length(the_geom)*random() as cost 
		FROM routes.edges_f1_noded'', orig, dest, false) AS r,
                    routes.edges_f1_noded AS e
             WHERE r.edge = e.id
           ) AS foo
         ) AS geo
  FROM (
    select unnest(myarray[:array_upper(myarray,1)-1]) as orig,
           unnest(myarray[2:]) as dest
    from  (
      SELECT array_agg(node) myarray FROM pgr_TSP(
    	''SELECT * FROM pgr_dijkstraCostMatrix(
        ''''SELECT id, source, target, st_length(the_geom)*random() as cost 
		FROM routes.edges_f1_noded'''',
        (SELECT array_agg(e.source) FROM floorplan_ddassetgeom a,routes.edges_f'||floor_id ||'_noded e where a.edge_id=e.id and a.id IN ('||asset_ids||')),
        directed := false)'',
    randomize := false) myarray
    ) b
  ) c
) fd
where fd.geo is not null;';
END;
$BODY$;

ALTER FUNCTION public.get_route(integer, character varying)
    OWNER TO postgres;
