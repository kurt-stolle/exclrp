-- TABLE
ERP.Cars = {}
setmetatable(ERP.Cars,{
	__index=function(self,key)
		for k,v in ipairs(self) do
			if key and v.name == key then
				return v;
			end
		end
		return nil;
	end
})

local function defineCar(name,model,script,price)
  table.insert(ERP.Cars,{name=name,model=model,script=script,price=price})
end

defineCar("Buggy","models/buggy.mdl","scripts/vehicles/jalopy.txt",1000)

-- METAMETHODS
local CHARACTER = FindMetaTable("Character")

function CHARACTER:GetCars()
  return self._cars or {}
end
