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

defineClothing("Standard Outfit","models/player/group01/male_02.mdl",ES.Color.Blue,false,"models/player/group01/female_01.mdl")
defineClothing("Casual Suit","models/player/breen.mdl",ES.Color.Black)
defineClothing("Police Armor","models/player/police.mdl",ES.Color.Blue,true,"models/player/police_fem.mdl")
defineClothing("Standard Armor","models/player/group03/male_02.mdl",ES.Color.Green,true,"models/player/group03/female_01.mdl")
defineClothing("Medic Armor","models/player/group03m/male_02.mdl",ES.Color.Red,true,"models/player/group03m/female_01.mdl")
