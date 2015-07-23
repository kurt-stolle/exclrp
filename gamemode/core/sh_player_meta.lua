-- sh_player_meta
local PLAYER = FindMetaTable("Player");

-- THIRDPERSON
function PLAYER:IsAiming()
	local wep=self:GetActiveWeapon();
	return IsValid(wep) and (wep:GetClass() == "weapon_physgun" or wep:GetClass() == "gmod_tool")
end

-- CHARACTER HELPERS
function PLAYER:IsLoaded()
	return tobool(self.character);
end

function PLAYER:GetCharacter()
	return self.character;
end

-- PLAYER STATUS
function PLAYER:GetStatus()
	return self:ESGetNetworkedVariable("erp_status",0)
end

function PLAYER:Alive()
	return self:IsLoaded() and bit.band(self:GetStatus(),STATUS_DEAD) == 0;
end
