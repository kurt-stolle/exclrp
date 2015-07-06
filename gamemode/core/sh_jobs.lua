-- sh_ERP.Jobs
ERP.Jobs = FindMetaTable("Job")
setmetatable(ERP.Jobs,{
	__index=function(self,key)
		for k,v in ipairs(self) do
			if key and string.lower(v:GetName()) == string.lower(key) or v:GetTeam() == key then
				return v;
			end
		end
		return nil;
	end
})
function ERP:GetJobs()
	return ERP.Jobs
end

--enum vars for faction path
FACTION_CIVILLIAN = 1;
FACTION_GOVERNMENT = 2;
FACTION_CRIME = 4;

--function to make this easier.
local JOB=FindMetaTable("Job")
AccessorFunc(JOB,"team","Team",FORCE_NUMBER);
AccessorFunc(JOB,"name","Name",FORCE_STRING);
AccessorFunc(JOB,"description","Description",FORCE_STRING);
AccessorFunc(JOB,"faction","Faction",FORCE_NUMBER);
AccessorFunc(JOB,"pay","Pay",FORCE_NUMBER);
AccessorFunc(JOB,"color","Color");

function ERP.Job(name,description,faction,pay,color)
	local obj={};
	setmetatable(obj,JOB);
	JOB.__index=JOB;

	obj.team=-1;
	obj.name=name or  "Unknown";
	obj.description=description or "No description given.";
	obj.faction=faction or FACTION_CIVILLIAN;
	obj.pay=pay or 10;
	obj.color=color or ES.Color.White;

	if CLIENT then
		obj.fnJobMenu = function(frame) end
	end

	obj.loadout={};

	return obj;
end
function JOB:GetLoadout()
	return self.loadout or {};
end
function JOB:SetLoadout(tab)
	self.loadout = tab
end
JOB.Team = JOB.GetTeam
function JOB.__call(self)
	self:SetTeam(#ERP.Jobs+1);

	team.SetUp(self:GetTeam(),self:GetName(),self:GetColor());

	ERP.Jobs[self:GetTeam()]=self;

	self.SetTeam = nil;
	self.SetName = nil;
	self.SetDescription = nil;
	self.SetFaction = nil;
	self.SetPay = nil;
	self.SetColor = nil;

	return self;
end

-- setup the defaul tteam
team.SetUp(TEAM_UNASSIGNED,"Unemployed",ES.Color["#0A0"]);
