if SERVER then
  include("sv_npc.lua");
  AddCSLuaFile();
  AddCSLuaFile("cl_npc.lua");
elseif CLIENT then
  include("cl_npc.lua")
end

ENT.Base 			= "base_nextbot";
ENT.Spawnable		= false;
ENT.Name = "Unindentified NPC";
