local PLAYER = FindMetaTable("Player");

function PLAYER:UnLoad()
	-- This function unloads the player
	-- meaning they can select a new character.

	hook.Call("ERPCharacterUnloaded",GAMEMODE,self,self.character)

	self.character=nil;

	self:SetStatus(0)

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

function PLAYER:CreateErrorDialog(txt)
	self:ESSendNotificationPopup("Error",txt)

	return -1
end

function PLAYER:SetStatus(int)
	self:ESSetNetworkedVariable("erp_status",int)
end
