util.AddNetworkString("ERP.Job.ChangedFX");
local PLAYER=FindMetaTable("Player");

timer.Create("exclTimePayday",120,0,function()
	local players = player.GetAll();
	local v;
	for i=1,#players do
		local v=players[i];
		if v:IsLoaded() then
			if v:GetCharacter():GetJob() then
				v:GetCharacter():AddBank(v:GetCharacter():GetJob().pay)
				v:ESSendNotification("generic","You have earned $ "..v:GetCharacter():GetJob().pay.." from your paycheque, it has been put on your bank account.");
			else
				v:GetCharacter():AddBank(10);
				v:ESSendNotification("generic","You have earned $ 10 from your unemployment cheque, it has been put on your bank account.");
			end
		end
	end
end)
concommand.Add("excl_job",function(p,c,a)
	local j = a[1] and ERP.Jobs[a[1]] or nil;
	if not j or (p:GetCharacter():GetJob() and p:GetCharacter():GetJob() == j) then
		ES.DebugPrint(p:Nick()..": "..(a[1] or "").." is not a valid job!")
		return
	end

	ES.DebugPrint(p:Nick()..": set job to "..j:GetName())

	p:GetCharacter():SetJob(j:GetName());
end)
