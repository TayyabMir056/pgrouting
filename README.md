**Pre-Reqs**

 - Create a new schema "routes" in the existing db
	 - All the topologies will be handled in this schema
	
 - Add a new columns "edge_id" integer, "fraction" double prec  in existing floorplan_ddassetgeom
	 -  These columns will be used in validation and to assign nearest node to the asset 

**Instructions**
Create the functions from the provided files, and run them in the provided order.


 - Create_topologies (floor_id, tolerence)
 	 - Validates assets and assign them nearest nodes if within tolerence
	 - Create multuple topology tables in the routes schema for required floor	 
	 - Create/update topology of a specific floor 
	 
 - Validate_assets (floor_id, tolerence)
 	-updates the edge_id and fraction columns
	-validates if all assets are in the tolerence
	 
 - Update_all_topologies(tolerence)
	 - to create/update topologies of all the floors
	 
	
 - get_route(floor_id,asset ids to visit)
 	-asset ids are to be provided as comma separated string
	- Returns seq of routes to follow as geometry as well as geojson

**Note: Before Calulating the routes, Make sure the topologies are created/updated **
