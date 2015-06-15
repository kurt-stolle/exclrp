-- sh_ERP.Jobs
ES.DefineNetworkedVariable("job","UInt");

ERP.Jobs = {}
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
local JOB={};
AccessorFunc(JOB,"team","Team",FORCE_NUMBER);
AccessorFunc(JOB,"name","Name",FORCE_STRING);
AccessorFunc(JOB,"description","Description",FORCE_STRING);
AccessorFunc(JOB,"class","Class",FORCE_NUMBER);
AccessorFunc(JOB,"pay","Pay",FORCE_NUMBER);
AccessorFunc(JOB,"color","Color");

function ERP.Job()
	local obj={};
	setmetatable(obj,JOB);
	JOB.__index=JOB;

	obj.team=-1;
	obj.name="Unknown";
	obj.description="No description given.";
	obj.class=FACTION_CIVILLIAN;
	obj.pay=10;
	obj.color=ES.Color.White;

	return obj;
end
JOB.Team = JOB.GetTeam
function JOB.__call(self)
	self:SetTeam(#ERP.Jobs+1);

	team.SetUp(self:GetTeam(),self:GetName(),self:GetColor());

	ERP.Jobs[self:GetTeam()]=self;

	self.SetTeam = nil;
	self.SetName = nil;
	self.SetDescription = nil;
	self.SetClass = nil;
	self.SetPay = nil;
	self.SetColor = nil;

	return true;
end

-- setup the defaul tteam
team.SetUp(TEAM_UNASSIGNED,"Unemployed",ES.Color["#AAA"]);
