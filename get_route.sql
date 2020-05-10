-- FUNCTION: public.get_route(integer, character varying)

-- DROP FUNCTION public.get_route(integer, character varying);

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
	
      	st_lineSubstring(st_lineMerge(st_collectionExtract(fd.geo,2)),
			 CASE  WHEN get_fraction_from_asset(-1*orig,st_lineMerge(st_collectionExtract(fd.geo,2))) <get_fraction_from_asset(-1*dest,st_lineMerge(st_collectionExtract(fd.geo,2)))
			 THEN  get_fraction_from_asset(-1*orig,st_lineMerge(st_collectionExtract(fd.geo,2)))
			 ELSE get_fraction_from_asset(-1*dest,st_lineMerge(st_collectionExtract(fd.geo,2))) END,
			  CASE  WHEN get_fraction_from_asset(-1*orig,st_lineMerge(st_collectionExtract(fd.geo,2))) >get_fraction_from_asset(-1*dest,st_lineMerge(st_collectionExtract(fd.geo,2)))
			 THEN  get_fraction_from_asset(-1*orig,st_lineMerge(st_collectionExtract(fd.geo,2)))
			 ELSE get_fraction_from_asset(-1*dest,st_lineMerge(st_collectionExtract(fd.geo,2))) END) as geo,
	   ST_AsGeoJSON(fd.geo)
	   
	  from   (
  SELECT ROW_NUMBER() OVER (ORDER BY now() ASC) AS seq,
         (
           SELECT (ST_Collect(pgr_djik.geo))
           FROM   (
             SELECT e.the_geom as geo
             FROM   pgr_withPoints(
				 ''SELECT id, source, target, st_length(the_geom) as cost 
		FROM routes.edges_f'||floor_id||'_noded'',
				 ''SELECT id as pid, edge_id, fraction from floorplan_ddassetgeom'',
				 orig, dest, false) AS r,
                    routes.edges_f'||floor_id||'_noded AS e
             		WHERE r.edge = e.id
			   		
           ) AS pgr_djik
         ) AS geo, orig,dest
  FROM (
    select unnest(tsp_result[:array_upper(tsp_result,1)-1]) as orig,
           unnest(tsp_result[2:]) as dest
    from  (
      SELECT array_agg(node) tsp_result FROM pgr_TSP(
	  	--pgr_djikstraCostMatrix
    	''SELECT * FROM pgr_withPointsCostMatrix(
        ''''SELECT id, source, target, st_length(the_geom) as cost 
		FROM routes.edges_f'||floor_id||'_noded'''',
		''''SELECT id as pid, edge_id, fraction from floorplan_ddassetgeom'''',
        ARRAY['||asset_ids||'],
        directed := false)'',
    randomize := true) tsp_result
    ) tsp_result_array
  ) tsp_nodes_orig_dest
) fd
where fd.geo is not null;';
END;
$BODY$;

ALTER FUNCTION public.get_route(integer, character varying)
    OWNER TO postgres;

