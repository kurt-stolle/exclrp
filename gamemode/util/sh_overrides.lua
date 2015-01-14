local CHARACTER={};

local _findMeta = FindMetaTable;
function FindMetaTable(name)
	if name == "Character" then
		return CHARACTER;
	end
	return _findMeta(name);
end