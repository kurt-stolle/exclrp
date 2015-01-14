-- sh_ERP.Jobs
ES.DefineNetworkedVariable("job","UInt");

ERP.Jobs = {}
setmetatable(ERP.Jobs,{
	__index=function(self,key)
		for k,v in pairs(self) do
			if v:GetName() == key or v:GetTeam() == key then
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
JOB_CIVILLIAN = 1;
JOB_GOVERNMENT = 2;
JOB_CRIME = 3;

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
	obj.class=JOB_CIVILLIAN;
	obj.pay=10;
	obj.color=ES.Color.White;

	return obj;
end
function JOB.__call(self)
	self:SetTeam(#ERP.Jobs+1);

	team.SetUp(self:GetTeam(),self:GetName(),self:GetColor());

	ERP.Jobs[self:GetTeam()]=self;

	return true;
end

-- player meta
local PLAYER = FindMetaTable("Player");
function PLAYER:GetJob()
	local job=self:ESGetNetworkedVariable("job",false);
	return job and ERP.Jobs[job] or false;
end