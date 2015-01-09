-- sh_jobs

local jobs = {}
function ERP:GetJobs()
	return jobs
end

--enum vars for faction path
JOB_CIVILLIAN = 1;
JOB_GOVERNMENT = 2;
JOB_CRIME = 3;

--function to make this easier.
local function createJob( name, description, class, pay, color)
	jobs[#jobs+1] = {teamn = #jobs+1, name = name, description = description, class = class, pay = pay, color = color};
	team.SetUp (#jobs, name, color);
	return #jobs;
end

function ERP:GetJobs(class)
	if !class then
		return jobs;
	end
	
	local t = {};
	for k,v in pairs(jobs)do
		if v.class == class then
			t[#t+1]=v;
		end
	end
	
	return t;
end

-- player meta
local pmeta = FindMetaTable("Player");
function pmeta:GetJob()
	return self.job or nil;
end

if SERVER then

	util.AddNetworkString("ERPJobChanged");

	function pmeta:SetJob(job) -- no arguments to re-set
		if not job then
			return;
		end
		self.job = jobs[job];
		self:SetTeam(jobs[job].teamn);
		local col = jobs[job].color;
				col = Vector(col.a/255,col.g/255,col.b/255);
				self:SetPlayerColor(col);
				self:SetWeaponColor(col);
				
		net.Start("ERPJobChanged"); net.WriteEntity(self); net.WriteUInt(job,8); net.Broadcast();
	end

	timer.Create("exclTimePayday",120,0,function()
		local players = player.GetAll();
		local v;
		for i=1,#players do
			local v=players[i];
			if v:IsLoaded() then
				if v:GetJob() then
					v:AddMoney(v:GetJob().pay)
					v:ESSendNotification("generic","You have earned $ "..v:GetJob().pay..",- from your paycheque, it has been put on your bank account.");
				else
					v:AddMoney(10);
					v:ESSendNotification("generic","You have earned $ 10,- from your unemployment cheque, it has been put on your bank account.");
				end
			end
		end
	end)
	concommand.Add("excl_job",function(p,c,a)
		local j = tonumber(a[1]);
		if not j or not jobs[j] or (p:GetJob() and p:GetJob().teamn == j)then return; end
		
		p:SetJob(j);
	end)

end
if CLIENT then
	net.Receive("ERPJobChanged",function()
		local p = net.ReadEntity();
		local job = net.ReadUInt(8);

		if not IsValid(p) or not job or not jobs[job] then return end

		p.job = jobs[job];

		if p == LocalPlayer() then
			ES.Notify("generic","You have been made a "..(jobs[job].name or "undefined"));
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

end
-- jobs can be added below.
-- notes:
-- when unemployed, you earn $10.
--
TEAM_SALES = createJob( "Salesman", "Your job is to sell light weaponry and general supplies to the people of the city.\nYour profits will change as the economy changes.", JOB_CIVILLIAN, 8,Color(102,255,51));
TEAM_POLICE = createJob( "Police", "Your job is to keep the city safe from illegal activity and arrest all the criminals that commit these activities. As an officer of the law you can teleport people to jail.", JOB_GOVERNMENT, 11,Color(51,204,255));
TEAM_MEDIC = createJob( "Medic", "A medic can heal people and rapidly restore their stamina.", JOB_GOVERNMENT, 12,Color(128,0,255));
TEAM_BLACKMARKET = createJob( "Black market", "Your job is to deal the more deadly weapons and gadjets.", JOB_CRIME, 5,Color(184,0,0));
TEAM_THIEF = createJob( "Thief", "A vital part of organised crime is the ability to go in and out unnoticed, a thief can gently sneak into somebody else's property and steal their things.", JOB_CRIME, 6,Color(255,61,61));
