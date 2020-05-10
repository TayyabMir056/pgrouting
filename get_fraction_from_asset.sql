-- FUNCTION: public.get_fraction_from_asset(bigint, geometry)

-- DROP FUNCTION public.get_fraction_from_asset(bigint, geometry);

CREATE OR REPLACE FUNCTION public.get_fraction_from_asset(
	point_id bigint,
	geom geometry)
    RETURNS double precision
    LANGUAGE 'sql'

    COST 100
    VOLATILE 
    
AS $BODY$

SELECT st_lineLocatePoint(geom,p.location) FROM floorplan_ddassetgeom p
WHERE p.id=point_id

$BODY$;

ALTER FUNCTION public.get_fraction_from_asset(bigint, geometry)
    OWNER TO postgres;
