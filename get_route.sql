SELECT * FROM pgr_withPoints(
        'SELECT id, source, target, cost, reverse_cost FROM sample_edge_table ORDER BY id',
        'SELECT pid, edge_id, fraction, side from pointsOfInterest',
        -1, --Starting point = POI 1 (- for POI)
		3, --Ending point = Vertex 3
        details := true);
