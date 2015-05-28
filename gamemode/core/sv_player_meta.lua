local PLAYER = FindMetaTable("Player");

function PLAYER:UnLoad()
	-- This function unloads the player
	-- meaning they can select a new character.

	self.character=nil;

	self:KillSilent()
	self:Spawn()
end

function PLAYER:SprintEnable()
	if not self._cachedSprintSpeed then return end

	self:SetRunSpeed(self._cachedSprintSpeed);
end

function PLAYER:SprintDisable()
	if self:GetRunSpeed() ~= self:GetWalkSpeed() then
		self._cachedSprintSpeed = self:GetRunSpeed();
		self:SetRunSpeed(self:GetWalkSpeed());
	end
end
