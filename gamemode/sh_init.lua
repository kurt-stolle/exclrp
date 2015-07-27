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

-- Configure
include("sh_config.lua")

-- TODO: Load these variables from the .txt file.
ERP.Name = "ExclRP";
ERP.Author = "Excl";
ERP.Version = "1";

--Load files
ES.DebugPrint("Loading ExclRP version "..ERP.Version);

local path = "exclserver/"
function ERP.Include(name, folder, runtype)
	name = string.gsub(name,"exclrp/gamemode/","")
	if not runtype then
		runtype = string.Left(name, 2)
	end

	if not runtype or ( runtype ~= "sv" and runtype ~= "sh" and runtype ~= "cl" ) then ErrorNoHalt("Could not include file, no prefix!") return false end

	path = ""

	if folder then
		path = path .. folder .. "/"
	end

	path = path .. name

	if SERVER then
		if runtype == "sv" then
			ES.DebugPrint("> Loading... "..path)
			include(path)
		elseif runtype == "sh" then
			ES.DebugPrint("> Loading... "..path)
			include(path)
			AddCSLuaFile(path)
		elseif runtype == "cl" then
			AddCSLuaFile(path)
		end
	elseif CLIENT then
		if (runtype == "sh" or runtype == "cl") then
			ES.DebugPrint("> Loading... "..path)
			include(path)
		end
	end

	return true
end

function ERP.IncludeFolder(folder,runtype)
	ES.DebugPrint("Initializing "..folder)

	local exp=(string.Explode("/",folder,false))[1]

	for k,v in pairs(file.Find(folder.."/*.lua","LUA")) do
		ERP.Include(v, folder, runtype)
	end
end

ERP.IncludeFolder("exclrp/gamemode/util");
ERP.IncludeFolder("exclrp/gamemode/core");
ERP.IncludeFolder("exclrp/gamemode/vgui","cl");
ERP.IncludeFolder("exclrp/gamemode/classes","sh");
ERP.IncludeFolder("exclrp/gamemode/items","sh");
ERP.IncludeFolder("exclrp/gamemode/npcs","sh");
ERP.IncludeFolder("exclrp/gamemode/jobs","sh");
ERP.IncludeFolder("exclrp/gamemode/systems");

ES.DebugPrint("ExclRP successfully loaded!")
