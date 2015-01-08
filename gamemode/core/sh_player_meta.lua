-- sh_player_meta
local pmeta = FindMetaTable("Player");
function pmeta:IsWearingTag()
	if not self:Nick() then return false end
	
	return tobool(string.find(self:Nick(),"%[CBC%]"));
end

//aim

function pmeta:IsAiming()
	return (self:GetActiveWeapon() and self:GetActiveWeapon():IsValid() and self:GetActiveWeapon().GetClass and self:GetActiveWeapon():GetClass() == "weapon_physgun");
end

function pmeta:IsLoaded()
	return (not not self.character);
end
function pmeta:GetRPName()
	local t = string.Explode(self:GetNWString("name","John|Doe"),"|");
	return t[1],t[2];
end
function pmeta:GetRPNameFull()
	local t = string.Explode("|",self:GetNWString("name","John|Doe"));
	return ((t[1]).." "..(t[2]));
end


function pmeta:GetMoney()
	if not self:IsLoaded() then return 0; end
	
	return self.character.cash or 0;
end

function pmeta:GetMoneyBank()
	if not self:IsLoaded() then return 0; end
	
	return self.character.bank or 0;
end