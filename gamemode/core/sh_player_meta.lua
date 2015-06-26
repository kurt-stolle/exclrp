-- sh_player_meta
local PLAYER = FindMetaTable("Player");

function PLAYER:IsAiming()
	local wep=self:GetActiveWeapon();
	return IsValid(wep) and (wep:GetClass() == "weapon_physgun" or wep:GetClass() == "gmod_tool")
end

function PLAYER:IsLoaded()
	return tobool(self.character);
end

function PLAYER:GetCharacter()
	return self.character;
end

ES.DefineNetworkedVariable("erp_status","UInt",4)
function PLAYER:GetStatus()
	return self:ESGetNetworkedVariable("erp_status",0)
end
