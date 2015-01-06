--Loading the initialisation files.
include "sh_init.lua";

AddCSLuaFile "cl_init.lua";
AddCSLuaFile "sh_init.lua";
--[[
if timer.IsTimer("HostnameThink") then
	timer.Remove "HostnameThink";
end--]]
