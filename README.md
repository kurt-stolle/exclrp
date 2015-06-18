# ExclRP - Garry's Mod RolePlay gamemode set in the 2000s

ExclServer
-----

ExclRP ("ERP") depends on ExclServer2 ("ES2") and will not run if there is no valid installation of ExclServer2 or above on the server!

Classes
-----

These are all classes implemented by ExclRP
Every class has a seperate metatable, use FindMetaTable(classname) to return it.
Format: **Classname** `Constructor` Description

- **Storage** `ERP.Storage([String name],[Number w],[Number h])` Synchronized inventory system
- **Character** `ERP.Character()` A player's character
- **Inventory** `ERP.Inventory([Number w],[Number h])` Holds items
- **Item** `ERP.Item()` All ExclRP objects that can be saved in the inventory, *can only be constructed during GameMode initialization!*
- **NPC** `ERP.NPC()` Non-Player characters, *can only be constructed during GameMode initialization!*
- **Job** `ERP.Job()` Character jobs, *can only be constructed during GameMode initialization!*

Check the class specific file for an explanation on how to use it.


Hooks
------

These are all custom hooks implemented by ExclRP
Format: Name ( ARGUMENTS: TYPE name , ... )

- ERPCharacterUpdated ( CHARACTER char, * key, * value )
- ERPStorageUpdated ( STORAGE stor )


about
------

ExclRP is a RolePlay gamemode first started in 2012 for the Casual Bananas Community (CBC).
This version of ExclRP is a continuation of the 2012 ExclRP, but with some heavy modifications in the core files, as well as having new features added.

ExclRP was created by Kurt "Excl" Stolle (kurt@casualbananas.com).
