-- a storage is basically a networked inventory. Like a salesman or a dead corpse or a chest.

ERP.Storages = {}
setmetatable(ERP.Storages,{
	__index=function(self,key)
		for k,v in ipairs(self) do
			if key and string.lower(v:GetName()) == string.lower(key) then
				return v;
			end
		end
		return nil;
	end
})

local STOR= FindMetaTable("Storage");
AccessorFunc(STOR,"name","Name",FORCE_STRING)
AccessorFunc(STOR,"key","Key",FORCE_NUMBER)
function ERP.Storage(name,w,h)
  local obj={};
	setmetatable(obj,STOR);
  STOR.__index=STOR;

  obj.name = name or "";
  obj.inventory = ERP.Inventory(w or nil,h or nil)

	return obj;
end
function STOR:__call()
  local key=#ERP.Storages + 1;
  self:SetKey(key)

  ERP.Storages[key] = self;

  self.SetName = nil;
  self.SetKey = nil;

  ES.DebugPrint("Storage registered: "..self:GetName());

	return self
end
function STOR:GetInventory()
  return self.inventory;
end
