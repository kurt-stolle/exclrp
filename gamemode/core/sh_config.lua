-- Locals
local map = string.lower(string.Trim(game.GetMap()));

-- Configuration table
ERP.Config = {};

-- Shared configuration values
ERP.Config.MainMenu = {}
ERP.Config.MainMenu.ViewOrigin = Vector(0,0,0);
ERP.Config.MainMenu.ViewAngles = Angle(0,0,0);

-- Map dependant configuration. These values should always override some default value!
if map == "rp_evocity_v4b1" then
  ERP.Config.MainMenu.ViewOrigin = Vector(-6128.452637,-6261.104980,341.719208);
  ERP.Config.MainMenu.ViewAngles = Angle(18.599918,-68.060287,0);
end
