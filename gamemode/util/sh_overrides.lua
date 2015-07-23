local _returnTrue = function() return true end

local CHARACTER = {IsCharacter 	= _returnTrue, IsValid = _returnTrue};
local ITEM 		= {IsItem 		= _returnTrue, IsValid = _returnTrue};
local NPC 		= {IsNPC 		= _returnTrue, IsValid = _returnTrue};
local PROPERTY 	= {IsProperty 	= _returnTrue, IsValid = _returnTrue};
local INV 		= {IsInventory 	= _returnTrue, IsValid = _returnTrue};
local STOR 		= {IsStorage 	= _returnTrue, IsValid = _returnTrue};
local JOB 		= {IsJob 		= _returnTrue, IsValid = _returnTrue};
local GANG 		= {IsGang 		= _returnTrue, IsValid = _returnTrue};

local _findMeta = FindMetaTable;
function FindMetaTable(name)
	if name == "Character" then
		return CHARACTER;
	elseif name == "Item" then
		return ITEM;
	elseif name == "NPC" then
		return NPC;
	elseif name == "Property" then
		return PROPERTY;
	elseif name == "Inventory" then
		return INV;
	elseif name == "Storage" then
		return STOR;
	elseif name == "Job" then
		return JOB;
	elseif name == "Gang" then
		return GANG;
	end
	return _findMeta(name);
end
