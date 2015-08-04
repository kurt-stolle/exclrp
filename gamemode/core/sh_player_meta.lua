-- sh_player_meta
local PLAYER = FindMetaTable("Player");

-- THIRDPERSON
function PLAYER:IsAiming()
	local wep=self:GetActiveWeapon();

	return IsValid(wep) and ( (wep.GetStatus and wep:GetStatus() == WEAPON_STATUS_AIM) or wep:GetClass() == "weapon_physgun" or wep:GetClass() == "gmod_tool" )
end

-- CHARACTER HELPERS
function PLAYER:IsLoaded()
	return tobool(self.character);
end

function PLAYER:GetCharacter()
	return self.character;
end

-- PLAYER STATUS
STATUS_NONE = 0
STATUS_ARRESTED = 1
STATUS_DEAD = 2
STATUS_WANTED = 4
STATUS_WARRANT = 8
function PLAYER:GetStatus()
	return self:ESGetNetworkedVariable("erp_status",0)
end

function PLAYER:HasStatus(status)
	return bit.band(self:GetStatus(),status) > 0
end

function PLAYER:Alive()
	return self:IsLoaded() and not self:HasStatus(STATUS_DEAD);
end
