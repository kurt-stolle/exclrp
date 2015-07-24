ERP.Clothing = {}
setmetatable(ERP.Clothing,{
	__index=function(self,key)
		for k,v in ipairs(self) do
			if key and v.name == key then
				return v;
			end
		end
		return nil;
	end
})

local function defineClothing(name,model,color,hasGloves)
  table.insert(ERP.Clothing,{name=name,model=model,color=color,hasGloves=hasGloves or false})
end

defineClothing("casual","models/player/group01/male_01.mdl",ES.Color.Blue)
defineClothing("suit","models/player/gman_high.mdl",ES.Color.Black)
