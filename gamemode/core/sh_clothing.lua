ERP.Clothing = {}

local function defineClothing(name,model,color,hasGloves)
  ERP.Clothing[util.CRC(name)]={name=name,model=model,color=color,hasGloves=hasGloves or false}
end

defineClothing("casual","models/player/group01/male_05.mdl",ES.Color.Blue)
defineClothing("suit","models/player/gman_high.mdl",ES.Color.Black)
