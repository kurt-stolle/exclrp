include("shared.lua")
AddCSLuaFile("cl_init.lua")

function ENT:Initialize()
	self._bItemLoaded=false;
end