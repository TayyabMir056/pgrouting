DROP TABLE sample_edge_table;

CREATE TABLE sample_edge_table (
    id serial,
    dir character varying,
    source integer,
    target integer,
    cost double precision,
    reverse_cost double precision,
    x1 double precision,
    y1 double precision,
    x2 double precision,
    y2 double precision,
    the_geom geometry,
	floor_id integer);


INSERT INTO sample_edge_table (cost,reverse_cost,x1,y1,x2,y2,floor_id) VALUES ( 1, 1,  2,0,   2,1,1);
INSERT INTO sample_edge_table (cost,reverse_cost,x1,y1,x2,y2,floor_id) VALUES (1, 1,  2,1,   3,1,1);
INSERT INTO sample_edge_table (cost,reverse_cost,x1,y1,x2,y2,floor_id) VALUES (1, 1,  3,1,   4,1,1);
INSERT INTO sample_edge_table (cost,reverse_cost,x1,y1,x2,y2,floor_id) VALUES ( 1, 1,  2,1,   2,2,1);
INSERT INTO sample_edge_table (cost,reverse_cost,x1,y1,x2,y2,floor_id) VALUES ( 1,1,  3,1,   3,2,1);
INSERT INTO sample_edge_table (cost,reverse_cost,x1,y1,x2,y2,floor_id) VALUES ( 1, 1,  0,2,   1,2,1);
INSERT INTO sample_edge_table (cost,reverse_cost,x1,y1,x2,y2,floor_id) VALUES ( 1, 1,  1,2,   2,2,1);
INSERT INTO sample_edge_table (cost,reverse_cost,x1,y1,x2,y2,floor_id) VALUES ( 1, 1,  2,2,   3,2,1);
INSERT INTO sample_edge_table (cost,reverse_cost,x1,y1,x2,y2,floor_id) VALUES ( 1, 1,  3,2,   4,2,1);
INSERT INTO sample_edge_table (cost,reverse_cost,x1,y1,x2,y2,floor_id) VALUES ( 1, 1,  2,2,   2,3,1);
INSERT INTO sample_edge_table (cost,reverse_cost,x1,y1,x2,y2,floor_id) VALUES ( 1,1,  3,2,   3,3,1);
INSERT INTO sample_edge_table (cost,reverse_cost,x1,y1,x2,y2,floor_id) VALUES ( 1,1,  2,3,   3,3,1);
INSERT INTO sample_edge_table (cost,reverse_cost,x1,y1,x2,y2,floor_id) VALUES ( 1,1,  3,3,   4,3,1);
INSERT INTO sample_edge_table (cost,reverse_cost,x1,y1,x2,y2,floor_id) VALUES ( 1, 1,  2,3,   2,4,1);
INSERT INTO sample_edge_table (cost,reverse_cost,x1,y1,x2,y2,floor_id) VALUES ( 1, 1,  4,2,   4,3,1);
INSERT INTO sample_edge_table (cost,reverse_cost,x1,y1,x2,y2,floor_id) VALUES ( 1, 1,  4,1,   4,2,1);
INSERT INTO sample_edge_table (cost,reverse_cost,x1,y1,x2,y2,floor_id) VALUES ( 1, 1,  0.5,3.5,  1.999999999999,3.5,1);
INSERT INTO sample_edge_table (cost,reverse_cost,x1,y1,x2,y2,floor_id) VALUES ( 1, 1,  3.5,2.3,  3.5,4,1);

INSERT INTO sample_edge_table (cost,reverse_cost,x1,y1,x2,y2,floor_id) VALUES ( 1, 1,  3,1,   3,2,2);
INSERT INTO sample_edge_table (cost,reverse_cost,x1,y1,x2,y2,floor_id) VALUES (1, 1,  3,2,   4,2,2);
INSERT INTO sample_edge_table (cost,reverse_cost,x1,y1,x2,y2,floor_id) VALUES (1, 1,  4,2,   5,2,2);
INSERT INTO sample_edge_table (cost,reverse_cost,x1,y1,x2,y2,floor_id) VALUES ( 1, 1,  3,2,   3,3,2);
INSERT INTO sample_edge_table (cost,reverse_cost,x1,y1,x2,y2,floor_id) VALUES ( 1,1,  4,2,   4,3,2);
INSERT INTO sample_edge_table (cost,reverse_cost,x1,y1,x2,y2,floor_id) VALUES ( 1, 1,  1,3,   2,3,2);
INSERT INTO sample_edge_table (cost,reverse_cost,x1,y1,x2,y2,floor_id) VALUES ( 1, 1,  2,3,   3,3,2);
INSERT INTO sample_edge_table (cost,reverse_cost,x1,y1,x2,y2,floor_id) VALUES ( 1, 1,  3,3,   4,3,2);
INSERT INTO sample_edge_table (cost,reverse_cost,x1,y1,x2,y2,floor_id) VALUES ( 1, 1,  4,3,   5,3,2);
INSERT INTO sample_edge_table (cost,reverse_cost,x1,y1,x2,y2,floor_id) VALUES ( 1, 1,  3,3,   3,4,2);
INSERT INTO sample_edge_table (cost,reverse_cost,x1,y1,x2,y2,floor_id) VALUES ( 1,1,  4,3,   4,4,2);
INSERT INTO sample_edge_table (cost,reverse_cost,x1,y1,x2,y2,floor_id) VALUES ( 1,1,  3,4,   4,4,2);
INSERT INTO sample_edge_table (cost,reverse_cost,x1,y1,x2,y2,floor_id) VALUES ( 1,1,  4,4,   5,4,2);
INSERT INTO sample_edge_table (cost,reverse_cost,x1,y1,x2,y2,floor_id) VALUES ( 1, 1,  3,4,   3,5,2);
INSERT INTO sample_edge_table (cost,reverse_cost,x1,y1,x2,y2,floor_id) VALUES ( 1, 1,  5,3,   5,4,2);
INSERT INTO sample_edge_table (cost,reverse_cost,x1,y1,x2,y2,floor_id) VALUES ( 1, 1,  5,2,   5,3,2);
INSERT INTO sample_edge_table (cost,reverse_cost,x1,y1,x2,y2,floor_id) VALUES ( 1, 1,  1.5,4.5,  2.999999999999,4.5,2);
INSERT INTO sample_edge_table (cost,reverse_cost,x1,y1,x2,y2,floor_id) VALUES ( 1, 1,  4.5,3.3,  4.5,5,2);


UPDATE sample_edge_table SET the_geom = st_makeline(st_point(x1,y1),st_point(x2,y2)),
                      dir = CASE WHEN (cost>0 and reverse_cost>0) THEN 'B'   -- both ways
                                 WHEN (cost>0 and reverse_cost<0) THEN 'FT'  -- direction of the LINESSTRING
                                 WHEN (cost<0 and reverse_cost>0) THEN 'TF'  -- reverse direction of the LINESTRING
                                 ELSE '' END;                                -- unknown
								 

DROP TABLE pointsOfInterest;
CREATE TABLE pointsOfInterest(
    pid BIGSERIAL,
    x FLOAT,
    y FLOAT,
    edge_id BIGINT,
    side CHAR,
    fraction FLOAT,
    the_geom geometry,
    newPoint geometry,
	floor_id integer
);

INSERT INTO pointsOfInterest (x, y, edge_id, side, fraction,floor_id) VALUES
(1.8, 0.4,   1, 'l', 0.4,1),
(4.2, 2.4,  15, 'r', 0.4,1),
(2.6, 3.2,  12, 'l', 0.6,1),
(0.3, 1.8,   6, 'r', 0.3,1),
(2.9, 1.8,   5, 'l', 0.8,1),
(2.2, 1.7,   4, 'b', 0.7,1),

(2.8, 1.4,   1, 'l', 0.4,2),
(5.2, 3.4,  15, 'r', 0.4,2),
(3.6, 4.2,  12, 'l', 0.6,2),
(1.3, 2.8,   6, 'r', 0.3,2),
(3.9, 2.8,   5, 'l', 0.8,2),
(3.2, 2.7,   4, 'b', 0.7,2);

UPDATE pointsOfInterest SET the_geom = st_makePoint(x,y);
UPDATE pointsOfInterest
    SET newPoint = ST_LineInterpolatePoint(e.the_geom, fraction)
    FROM sample_edge_table AS e WHERE edge_id = id AND pointsOfInterest.floor_id=e.floor_id;
