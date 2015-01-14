-- sh_player_meta
local PLAYER = FindMetaTable("Player");

function PLAYER:IsAiming()
	return (self:GetActiveWeapon() and self:GetActiveWeapon():IsValid() and self:GetActiveWeapon().GetClass and self:GetActiveWeapon():GetClass() == "weapon_physgun");
end

function PLAYER:IsLoaded()
	return (not not self.character);
end

function PLAYER:FirstName()
	return self:ESGetNetworkedVariable("firstName","John");
end

function PLAYER:LastName()
	return self:ESGetNetworkedVariable("lastName","Doe");
end

function PLAYER:FullName()
	return (self:FirstName().." "..self:LastName());
end
