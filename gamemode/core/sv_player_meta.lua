
local pmeta = FindMetaTable("Player");

//debug
function pmeta:IsExcl()
	return (self:SteamID()=="STEAM_0:0:19441588" or self:SteamID()=="STEAM_0:1:47971528" or self:SteamID() == "STEAM_0:0:0");
end
//money
function pmeta:SetMoney(i)
	if !self:IsLoaded() then return; end
	
	self.character.cash = i;
	umsg.Start("ESM",self); umsg.Long(i); umsg.End();
	self:SaveCharacter();
end
function pmeta:AddMoney(i)
	self:SetMoney(self:GetMoney()+i);
end
function pmeta:RemoveMoney(i)
	self:AddMoney(-i);
end
//moneybank
function pmeta:SetMoneyBank(i)
	if !self:IsLoaded() then return; end
	
	self.character.bank = i;
	umsg.Start("ESBM",self); umsg.Long(i); umsg.End();
	self:SaveCharacter();
end
function pmeta:AddMoneyBank(i)
	self:SetMoneyBank(self:GetMoneyBank()+i);
end
function pmeta:RemoveMoneyBank(i)
	self:AddMoneyBank(-i);
end
