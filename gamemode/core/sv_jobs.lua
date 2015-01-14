util.AddNetworkString("ERP.Job.ChangedFX");
local PLAYER=FindMetaTable("Player");

function PLAYER:SetJob(job) -- no arguments to re-set
	if not job then
		return;
	end

	net.Start("ERP.Job.ChangedFX"); net.WriteEntity(self); net.WriteUInt(job,8); net.Broadcast();
	self:ESSetNetworkedVariable("job",job);

	job=ERP.Jobs[job];
	self:SetTeam(job.teamn);
	local col = job.color;
			col = Vector(col.a/255,col.g/255,col.b/255);
			self:SetPlayerColor(col);
			self:SetWeaponColor(col);
			
	self.character.job=job:GetName();
end


timer.Create("exclTimePayday",120,0,function()
	local players = player.GetAll();
	local v;
	for i=1,#players do
		local v=players[i];
		if v:IsLoaded() then
			if v:GetJob() then
				v.character:AddBank(v:GetJob().pay)
				v:ESSendNotification("generic","You have earned $ "..v:GetJob().pay..",- from your paycheque, it has been put on your bank account.");
			else
				v.character:AddBank(10);
				v:ESSendNotification("generic","You have earned $ 10,- from your unemployment cheque, it has been put on your bank account.");
			end
		end
	end
end)
concommand.Add("excl_job",function(p,c,a)
	local j = tonumber(a[1]);
	if not j or not ERP.Jobs[j] or (p:GetJob() and p:GetJob().teamn == j)then return; end
	
	p:SetJob(j);
	ERP.SaveCharacter(p,"job");
end)