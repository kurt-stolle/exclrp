local CHARACTER={};
local ITEM={};

local _findMeta = FindMetaTable;
function FindMetaTable(name)
	if name == "Character" then
		return CHARACTER;
	elseif name == "Item" then
		return ITEM;
	end
	return _findMeta(name);
end