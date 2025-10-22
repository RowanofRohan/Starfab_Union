# Starfab Union
A C# Unity editor plugin designed to interface with SCDataTools and Starfab to convert data from Star Citizen into Unity.

Warning: This tool is currently in extremely early development. Early versions are expected to be messy and potentially a little bit buggy; Make backups of your projects!

Current versions are designed for Unity 2022.3.22f1 and only support the Built-in render pipeline, as this was designed with VRChat conversion in mind. Future versions may or may not support HDRP.

This tool assumes you already have experience working with Blender, Unity, and Starfab itself. 

## Features

* Matches settings of Lights in the scene to more closely resemble their original game settings
* Automatically imports Light Cookies and assigns them
* Imports Material textures and automatically assigns their import settings
* Generates required materials for Star Citizen objects in the scene
* Button to automatically assign materials to objects in the scene based on matching names

## Installation

Regular Installation: 
1. Download the latest Unity Package from the Releases tab.
2. In Unity, drag and drop the package into your Project window.
3. Follow and accept the prompts that come up to import the package.

## Setup:

1. Navigate to the "Starfab" tab at the top, and click the "Open Importer" button. Place this window in a convenient spot.
2. This tool requires you to have already exported a Blueprint(s) from Starfab; navigate to where your blueprint file is stored, and copy it into your Unity project in a place where you will be able to easily find it later.
3. In the Importer window, drag your blueprint file into the "Source Blueprint" box.
4. Click "Load Blueprint". A message will show in the console when this is done. Large blueprints may hang for a second.
6. Import your FBX models from blender and pull them into the scene. Preferably, place all of your relevant model files under a single empty object.
7. Drag the object containing all of the models you would like the plugin to affect into the "Target Object Parent" field.
8. Navigate to the directory containing all of the files you have exported from Star Citizen; copy the path to the "Data" folder of this directory into the "Asset Source Directory" Field.

## Usage:

### Lights:

1. Once the Blueprint has been loaded, click the "Create Light List" button to extract information about Lights from the blueprint and store it in memory. 
2. If the light definitions have been extracted and the parent object is assigned, additional UI options should now appear.
3. "Fix Transforms" will attempt to fix locations of lights that imported with odd or misaligned transforms when setting lights. This button has not been thoroughly tested and may cause unexpected behavior!
4. Select the State Template you would like to use; most of the time, you will want to use Default, but you can use Auxilary, Emergency, or Cinematic instead. This will tell the importer which parameters to pull from to set color, intensity, etc.
5. Click "Set Lights from Blueprint" To attempt to automatically fix any lights under the parent object that have names matching those found in the blueprint.

**Warning:** Currently, the light list does not automatically update when you change Blueprints. If you change blueprints, you will need to recreate the light list or it will not function correctly. 

### Materials: 

1. Once the Blueprint has been loaded, click "Create Material List" to extract information about materials. **Warning:** This will take a long time! This will currently iterate through the entirety of your extracted game files to find every .mtl file, as not all material files can be find in the source blueprint. Expect this to take several minutes. However, this does not actually require refreshing when changing blueprints.
2. Once the material list has been generated, click "Generate materials"; This will check every material slot on objects under the target parent, and generate all materials with a name matching one of the extracted definitions from the game files. This will also automatically import textures that are not found to already be in the project; Textures will be imported to "Assets/Starfab_Union/Imported_Files". It is NOT recommended to extract your game files directly to this location, as the importer will no longer be able to correctly assign their import settings without overwriting them.
3. After generating materials, click "Assign generated materials..." to assign any of the generated materials to slots with matching names on objects underneath your target parent.

**Warning:** If you have Overwrite toggled on, generating materials can cause materials to be unassigned from existing objects in the scene. If this happens, find the affected objects, find their Mesh Renderer component, right click on the "Material List", and click "Revert", before then re-assigned materials to that object. 

## Recommended Blender Workflow:

1. (Optional) for extremely large blueprints (such as large ships and starports), it is recommended to separate the blender file into multiple smaller files to reduce lag and make it easier to work with the files. Save a backup iteration at this stage, as the next steps can be destructive.
2. Sort objects into sub-collections. I recommend sorting based on the type of object (group), then further into sub-sections that will become individual FBX files later. This is primarily for object culling purposes. For example, my Idris Bridge file has the heirarchy: "Collection/Idris_Bridge/Idris_Bridge_Static/Idris_Bridge_Stairs_Starboard". The groups I use are Static, Decals, Dynamic, Lights, Empties, and a separate Prefabs collection.
     * Static: Should contain all immobile geometry. This will be the primary recipient of baked lighting. Decals should go here for now, and can be separated later, if they were not already separated using the blender plugin. 
     * Decals: All static decal geometry. Will eventually contain objects that need to use Displace modifiers and will not cast shadows.
     * Dynamic: Geometry that is likely to move or otherwise animate, but isn't used frequently enough to be a prefab. (Usually only appears once or twice in an entire project). This may include things like cargo elevators, energy shields, or animated landing gear.
     * Lights: A separate collection that should contain all of your non-moving lights. Moving lights, such as those attached to a cargo elevator, should go into the Dynamic objects collection.
     * Empties: Parent "Dummy" object markers for any geometry that you do not plan to export with the rest of the file and will instead be a prefab.
     * Prefabs: Objects that will be instantiated many, many times throughout your project and will likely have scripts attached to them. This should include things like Doors and Door Control Consoles, and you may also want to include UI screens, fuseboxes, Lockers, etc. 
3. As you sort objects, all non-prefab objects should be decoupled from their parents. Use the options Parent > Clear and Keep transform to separate the meshes from their parent empties. Prefabs will be decoupled or deleted at a later step in the process.
4. Ensure that material names and light object names are kept intact! These are the main resources the importer requires to function.
5. When sorting prefabs, it is also recommended to leave the mesh object names untouched.
6. Once all objects have been sorted, make sure the UV Map on every object has the same name. Keep this name consistent across all objects in your file. I recommend simply "UVMap" or "UVMap_01". Failing this step will cause things to break. Hard.
   6a. This step may optionally be done before sorting objects into collections. If doing it this way, I recommend selecting each object, using "Select > By Group > Linked Objects", changing the UV Map name, and then hiding them until all objects have been adjusted.
   6b. Either way, this process will be exceptionally tedious. This is the longest part of the process by a significant margin, as Blender does not natively have a good way of renaming all UVMaps in a scene.
7. After objects have been sorted, save an additional backup iteration; The rest of the process is extremely destructive, and you will want to be able to return to this point!
8. Identify one object within each sub-section to use as the "origin" object for that section. In the Object Data tab, ensure the object is single-user (by clicking the button showing number of users, if there are more than one).
9. Select all meshes within each sub-collection, make sure the origin object is the primary object selected, and Join them. If Decals were included, remove (don't apply) all of the decal Displace modifiers. Double- and Triple-check that there is only one UV Map on the new object; if there is more than one, undo, find the offending object, and fix the UV map name before trying again.
10. You may now rename the object as needed. In my example above, this matched the collection name as "Idris_Bridge_Stairs_Starboard" for that particular section.
11. If decals are not already separated: Enter edit mode and make sure you are on Face selection mode with no faces selected. Navigate through the material list on the object, and hit select for each material that is either a Decal, Glow, POM, or Button; Any materials that overlay effects onto other things in the scene. Separate these by Selection, and move it into the corresponding Decal sub-collection, renamed accordingly.
12. If your decals were separated this way, now go to the modifiers tab, add a Displace modifier, and give it a strength of 0.001 with a midlevel of 0 and no vertex group. This will correct their positions again to sit slightly above other geometry.
13. On each of your objects, go to Object > Clean Up > Unused Material Slots.
14. Delete all of the dummy empties that now no longer contain objects. Your prefab objects should still be parented to their empties.
15. After deleting all unused empties, you can now clear the parents of prefab objects; remaining empties can now be placed into the "Empties" collection, to be used to re-place the prefabs later.
16. Identify every UNIQUE prefab object, and delete all but one copy. If you already have copies from other files, you can delete all of the copies in the current file. I highly recommend keeping a list where you can easily search by the 6-character ID at the start of each prefab name to see which ones you have already. Be careful, as some prefabs will share a parent mesh but have different internals. (For example, on the Idris, many of the door control panels use the same exterior geometry as the elevator buttons for the hangar cargo lifts. 

## Known issues/Planned updates:

* When closing the importer window or reloading Unity, settings and definitions are not saved and must be re-generated.
* Light definitions are not cleared when changing blueprints and must be manually re-generated.
* Overwriting materials unassigns them from objects already using them.
* Not all shaders are currently supported, and some shaders may still be feature-incomplete. Known missing shaders are the Hologram shader, Human Skin, IES, Cloth, and a variant of the Decal shader. Materials with these shaders will spit out an error in the meantime.
* Currently only supports the Built-In render pipeline; future versions will eventually include shader variants and light settings for HDRP, but this is not a priority for me personally.
* Will eventually include a button to populate Prefabs around the scene based on Empty parents. 
