local CHARACTER=FindMetaTable("Character");

-- Accessors
AccessorFunc(CHARACTER,"firstname","FirstName",FORCE_STRING);
AccessorFunc(CHARACTER,"lastname","LastName",FORCE_STRING);
AccessorFunc(CHARACTER,"cash","Cash",FORCE_NUMBER);
AccessorFunc(CHARACTER,"bank","Bank",FORCE_NUMBER);
AccessorFunc(CHARACTER,"id","ID",FORCE_NUMBER);

-- Names
function CHARACTER:GetFullName()
	return (self:GetFirstName() or "").." "..(self:GetLastName() or "");
end

function CHARACTER:GetJob()
	return ERP.Jobs[self.Player:Team()] or false;
end

function CHARACTER:CanAfford(amt)
	return amt and self:GetCash() >= tonumber(amt) or false;
end

function CHARACTER:GetInventory()
	return self.inventory
end

function CHARACTER:GetIDCardNumber()
	return util.CRC("ERP_"..self:GetFullName().."_"..self:GetID())
end

-- GANG
function CHARACTER:GetGang()
	return self.gang and ERP.Gangs[self.gang] or nil;
end

-- PLAYER CLOTHING
local clothing_default=util.CRC("casual")
function CHARACTER:GetClothing()
	return ERP.Clothing[self.Player:ESGetNetworkedVariable("erp_clothing",clothing_default)];
end

function CHARACTER:GetModel()
	return ERP.PlayerModels[self.Player:ESGetNetworkedVariable("erp_model",1)]
end
