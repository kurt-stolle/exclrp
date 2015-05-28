local CHARACTER={IsCharacter = function() return true end};
local ITEM={IsItem = function() return true end};
local NPC={IsNPC = function() return true end};
local PROPERTY={IsProperty = function() return true end};

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
	end
	return _findMeta(name);
end
