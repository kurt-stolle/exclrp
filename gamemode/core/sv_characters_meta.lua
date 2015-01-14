-- sv_characters_meta.lua
local CHARACTER = FindMetaTable("Character");

function CHARACTER:SetCash(i)
	self.cash = i;

	ERP.SaveCharacter(self.Player,"cash");
end
function CHARACTER:AddCash(i)
	self:SetCash(self:GetCash()+i);
end
function CHARACTER:TakeCash(i)
	self:AddCash(-i);
end

function CHARACTER:SetBank(i)
	self.bank = i;

	ERP.SaveCharacter(self.Player,"bank");
end
function CHARACTER:AddBank(i)
	self:SetBank(self:GetBank()+i);
end
function CHARACTER:TakeBank(i)
	self:AddBank(-i);
end
