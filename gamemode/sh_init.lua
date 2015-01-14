-- Only load ExclRP when ExclServer is installed. The gamemode will not function correctly when ExclServer is not installed.
if not ES then
	Error("ExclServer not installed, aborting gamemode startup.");
end

-- Derive from Sandbox.
DeriveGamemode("sandbox")

-- I prefer using ERP instead of GM or GAMEMODE.
ERP = {}
setmetatable(ERP,{
	__index = function(tbl,key)
		return rawget(GM or GAMEMODE,key);
	end,
	__newindex = function(tbl,key,value)
		return rawset(GM or GAMEMODE,key,value);
	end
})

-- TODO: Load these variables from the .txt file.
ERP.Name = "ExclRP";
ERP.Author = "Excl";
ERP.Version = "1";

--Load files
ES.DebugPrint("Loading ExclRP version "..ERP.Version);

ES.IncludeFolder("exclrp/gamemode/util");
ES.IncludeFolder("exclrp/gamemode/core");
ES.IncludeFolder("exclrp/gamemode/items","sh");
