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
AccessorFunc(STOR,"_name","Name",FORCE_STRING)
AccessorFunc(STOR,"_key","Key",FORCE_NUMBER)
function ERP.Storage(name,w,h)
  local obj={};
	setmetatable(obj,STOR);
  STOR.__index=STOR;

  obj._name = name or "";
  obj._inventory = ERP.Inventory(w or nil,h or nil)

	return obj;
end
function STOR:__call()
  local key=#ERP.Storages + 1;
  self:SetKey(key)

  ERP.Storages[key] = self;

  self.SetName = nil;
  self.SetKey = nil;

  ES.DebugPrint("Storage registered: "..self:GetName());
end
function STOR:GetInventory()
  return self._inventory;
end
