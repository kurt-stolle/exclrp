ERP.Properties = {};

setmetatable(ERP.Properties,{
  __index=function(tbl,key)
    if not key then return nil end

    if type(key) == "number" then
      return rawget(tbl,key);
    end

    for k,v in ipairs(tbl)do
      if string.lower(v.name) == string.lower(key) then
        return v;
      end
    end

    return nil
  end
})

PROPERTY_PRIVATE=1
PROPERTY_SHARED=2

local PROPERTY = FindMetaTable("Property")
AccessorFunc(PROPERTY,"name","Name",FORCE_STRING)
AccessorFunc(PROPERTY,"description","Description",FORCE_STRING)
AccessorFunc(PROPERTY,"owner","Owner",FORCE_NUMBER)
AccessorFunc(PROPERTY,"ownerName","OwnerName",FORCE_STRING)
AccessorFunc(PROPERTY,"factions","Factions",FORCE_NUMBER)
AccessorFunc(PROPERTY,"jobs","Jobs")
AccessorFunc(PROPERTY,"members","Members")
AccessorFunc(PROPERTY,"propertyType","Type",FORCE_NUMBER)
AccessorFunc(PROPERTY,"timeExpire","TimeExpire",FORCE_NUMBER)

function ERP.Property(name,description)
  local obj={}

  setmetatable(obj,PROPERTY)
  PROPERTY.__index = PROPERTY;

  obj.name=name or "Undefined"
  obj.description=description or "Undefined"
  obj.type=PROPERTY_PRIVATE;
  obj.timeExpire=0;

  return obj
end

function PROPERTY:__call()
  table.insert(ERP.Properties,self)
end

function PROPERTY:GetPrice(timeHours)
  if not timeHours or type(timeHours) ~= "number" then Error("No time passed to GetPrice function!") return end

  timeHours = math.ceil(timeHours);

  if not self.doors then return 0 end
  local doors=#self.doors;
  if not doors or doors < 1 then return 0 end

  return math.ceil( ( 10 * ( 1 + doors / ( math.pow(1.2,doors) ) ) ) * timeHours );
end
function PROPERTY:HasOwner()
  return tobool(self.owner) or self:GetType() == PROPERTY_SHARED;
end
function PROPERTY:PlayerHasPermissions(ply)
  if not ply:IsLoaded() then return false end

  if self:GetType() == PROPERTY_SHARED then
    local job=ply:GetCharacter():GetJob();
    return job and table.HasValue(self.jobs or {},job:GetName())
  elseif self:GetType() == PROPERTY_PRIVATE then
    return self.members and table.HasValue(self.members,ply:GetCharacter():GetID())
  end
end
