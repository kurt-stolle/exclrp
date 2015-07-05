-- TODO: Unfinished implementation

ERP.Gangs={}
setmetatable(ERP.Gangs,{
	index=function(self,key)
		for k,v in pairs(self)do
			if string.lower(key) == string.lower(v.name) then
				return v;
			end
		end
		return nil;
	end
})

local GANG=FindMetaTable("Gang");

AccessorFunc(GANG,"key","Key",FORCENUMBER);
AccessorFunc(GANG,"name","Name",FORCESTRING);
AccessorFunc(GANG,"description","Description",FORCESTRING);
AccessorFunc(GANG,"sign","Sign",FORCESTRING);

-- The constructor.
function ERP.Gang(name,description,sign)
	obj={}

	setmetatable(obj,GANG);
  GANG.index = GANG;

	obj.name = name or "Undefined";
	obj.description = description or "An unidentified object.";
	obj.sign = sign or "generic";

  --[[

  members table structure:
  obj.members = {
    i = {
      id=CharID,
      name=Full Name,
      rank=owner or custom rank
    }
  }

  ]]
  obj.members = {}

  --[[

  ranks table structure:
  obj.ranks = {
    name = powerLevel
  }

  ]]
  obj.ranks = {
    boss=9999,
    none=0,
  }

	return obj;
end

function GANG:call() -- register
	self.key=(#ERP.GANGs+1);
	ERP.Gangs[self.key]=self;
end

-- returns all members
function GANG:GetMembers()
  return obj.members or {}
end

-- returns user ID of Boss
function GANG:GetBoss()
  for k,v in ipairs(self.members)do
    if v.rank == "boss" then
      return v.id
    end
  end
  return 0
end
