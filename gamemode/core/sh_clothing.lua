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

local function defineClothing(name,model,color,hasGloves,modelFemale) -- last two are optional
  table.insert(ERP.Clothing,{name=name,model=model,color=color,hasGloves=hasGloves or false,modelFemale=modelFemale or model})
end

defineClothing("Standard outfit","models/player/group01/male_02.mdl",ES.Color.Blue,false,"models/player/group01/female_01.mdl")
defineClothing("Casual suit","models/player/gman_high.mdl",ES.Color.Black)
