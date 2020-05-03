**Pre-Reqs**

 - Create a new schema "routes" in the existing db
	 - All the topologies will be handled in this schema
	
 - Add a new column "node_id" integer in existing floorplan_ddassetgeom
	 -  This column will be used in validation and to assign nearest node to the asset 

**Instructions**
Create the functions from the provided files, and run them in the provided order.

 - Create_topologies (floor_id, tolerence)
 	 - Validates assets and assign them nearest nodes if within tolerence
	 - Create multuple topology tables in the routes schema for required floor	 
	 - Create/update topology of a specific floor 
	 
 - Update_all_topologies(tolerence)
	 - to create/update topologies of all the floors
	 
	
 - get_route(floor_id,asset ids to visit)
 	-asset ids are to be provided as comma separated string
	- Returns seq of routes to follow as geometry as well as geojson

**Note: Before Calulating the routes, Make sure the topologies are created/updated **
