net.Receive("ERP.Job.ChangedFX",function()
	local p = net.ReadEntity();
	local job = net.ReadUInt(8);

	if not IsValid(p) or not job or not ERP.Jobs[job] then return end

	p.job = ERP.Jobs[job];

	if p == LocalPlayer() then
		ES.Notify("generic","You have been made a "..(ERP.Jobs[job].name or "undefined"));
	end
	if !p.emitter then
		p.emitter = ParticleEmitter( p:GetPos() )
	end
	for i=0,10 do
		local part = p.emitter:Add("particle/smokesprites_000" .. math.random(1, 9), p:GetPos()+Vector(0,0,60-i*3))
		part:SetStartSize(20)
		part:SetEndSize(30)
		part:SetStartAlpha(255)
		part:SetEndAlpha(0)
		part:SetDieTime(2)
		part:SetRoll(math.random(0, 360))
		part:SetRollDelta(0)
		local r=math.random(0,50);
		part:SetColor(r,r,r)
		part:SetLighting(false)
		part:SetGravity(Vector(0, 0, 1));
		part:SetVelocity(Vector(math.random(-10,10),math.random(-15,10),-20))
	end
end)

local JOB=FindMetaTable("Job")
function JOB:SetJobMenuFunction(fn)
	self.fnJobMenu = fn;
end
function JOB:GetJobMenuFunction()
	return self.fnJobMenu;
end
