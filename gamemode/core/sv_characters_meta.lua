-- sv_characters_meta.lua
local CHARACTER = FindMetaTable("Character");

-- MONEY
function CHARACTER:SetCash(i)
	self.cash = i;

	ERP.SaveCharacter(self.Player,"cash");
end
function CHARACTER:AddCash(i)
	self:SetCash(self:GetCash()+i);
end
CHARACTER.GiveCash = CHARACTER.AddCash
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
CHARACTER.GiveBank = CHARACTER.AddBank
function CHARACTER:TakeBank(i)
	self:AddBank(-i);
end

-- JOBS
function CHARACTER:SetJob(job)
	if not job then
		return;
	end

	job=ERP.Jobs[job];

	if not job then return end

	self.Player:SetTeam(job.team);

	net.Start("ERP.Job.ChangedFX"); net.WriteEntity(self.Player); net.WriteUInt(job:GetTeam(),8); net.Broadcast();

	local col = job.color;
	col = Vector(col.a/255,col.g/255,col.b/255);

	self.Player:SetPlayerColor(col);
	self.Player:SetWeaponColor(col);

	self.job=job:GetName();
	self.joblevel=0;

	ERP.SaveCharacter(self.Player,"job");
	ERP.SaveCharacter(self.Player,"joblevel");
end

-- INVENTORY
function CHARACTER:GiveItem(item,x,y)
	if not ERP.ValidItem(item) then return ES.DebugPrint("Invalid item given to character!"); end

	local inv = self:GetInventory();

	if not inv then return ES.DebugPrint("Character has an invalid inventory.") end

	if not x and not y then
		x,y = inv:FitItem(item)
	end

	if not x or x <= 0 or not y or y <= 0 then return ES.DebugPrint("No space in inventory for item given to character!"); end

	inv:AddItem(item,x,y)

	ERP.SaveCharacter(self.Player,"inventory");
end
function CHARACTER:MoveItem(item,xOld,yOld,xNew,yNew)
	if not ERP.ValidItem(item) then return ES.DebugPrint("Invalid item given to character!"); end

	local inv = self:GetInventory();

	if not inv then return ES.DebugPrint("Character has an invalid inventory.") end

	inv:MoveItem(item,xOld,yOld,xNew,yNew)

	ERP.SaveCharacter(self.Player,"inventory");
end
