-- sh_player_meta
local PLAYER = FindMetaTable("Player");

function PLAYER:IsAiming()
	return (self:GetActiveWeapon() and self:GetActiveWeapon():IsValid() and self:GetActiveWeapon().GetClass and self:GetActiveWeapon():GetClass() == "weapon_physgun");
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
