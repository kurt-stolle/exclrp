local CHARACTER=FindMetaTable("Character");

-- Accessors
AccessorFunc(CHARACTER,"firstname","FirstName",FORCE_STRING);
AccessorFunc(CHARACTER,"lastname","LastName",FORCE_STRING);
AccessorFunc(CHARACTER,"cash","Cash",FORCE_NUMBER);
AccessorFunc(CHARACTER,"bank","Bank",FORCE_NUMBER);
AccessorFunc(CHARACTER,"id","ID",FORCE_NUMBER);

-- Male or female
function CHARACTER:IsMale()
	return not self:IsFemale()
end
function CHARACTER:IsFemale()
	return tobool(string.find(string.lower(self.model),"female",1,true))
end

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
function CHARACTER:GetClothing()
	return (ERP.Clothing[self.clothing or 1] or ERP.Clothing[1]);
end

function CHARACTER:GetModel()
	return self.model
end
