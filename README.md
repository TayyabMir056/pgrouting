**Requirements**

 - Create a new schema "routes" in the existing db
	 - All the topologies will be handled in this schema
	
 - Add a new column "edge_id" integer in existing floorplan_ddassetgeom
	 -  This column will be used in validation and to in assign which asset belongs to which line/path/edge

**Instructions**
Create the functions from the provided files

 - Create_topologies (floor_id, tolerence)
	 - To create/update topology of a specific floor 
 - Update_all_topologies(tolerence)
	 - to create/update topologies of all the floors
 - Assign_edges (tolerence)
	 - to validate if assets are correctly drawn
	 - and to assign each asset its nearest edge, that will later be used in calculating routes.

**Note: Before Calulating the routes, Make sure the topologies are created by calling the above functions in the mentioned order**
