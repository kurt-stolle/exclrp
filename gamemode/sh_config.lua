AddCSLuaFile()

-- Locals
local map = string.lower(string.Trim(game.GetMap()));

-- Configuration table
ERP.Config = {};

-- Configuration values
ERP.Config["mainmenu_view_origin"] = Vector(0,0,0);
ERP.Config["mainmenu_view_angles"] = Angle(0,0,0);
ERP.Config["arrest_time"] = 60*5
ERP.Config["death_time"] = 60*10

-- Map dependant configuration. These values should always override some default value!
if map == "rp_evocity_v4b1" then
  ERP.Config["mainmenu_view_origin"] = Vector(-6128.452637,-6261.104980,341.719208);
  ERP.Config["mainmenu_view_angles"] = Angle(18.599918,-68.060287,0);
end
