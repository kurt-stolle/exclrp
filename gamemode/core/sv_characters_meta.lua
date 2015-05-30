-- sv_characters_meta.lua
local CHARACTER = FindMetaTable("Character");

function CHARACTER:SetCash(i)
	self.cash = i;

	ERP.SaveCharacter(self.Player,"cash");
end
function CHARACTER:AddCash(i)
	self:SetCash(self:GetCash()+i);
end
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
function CHARACTER:TakeBank(i)
	self:AddBank(-i);
end
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
