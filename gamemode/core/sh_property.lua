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

local PROPERTY = FindMetaTable("Property")
AccessorFunc(PROPERTY,"name","Name",FORCE_STRING)
AccessorFunc(PROPERTY,"description","Description",FORCE_STRING)
AccessorFunc(PROPERTY,"owner","Owner",FORCE_NUMBER)
function PROPERTY:GetPrice(timeHours)
  if not timeHours or type(timeHours) ~= "number" then Error("No time passed to GetPrice function!") return end

  timeHours = math.ceil(timeHours);

  if not self.doors then return 0 end
  local doors=#self.doors;
  if not doors or doors < 1 then return 0 end

  return math.ceil( ( 10 * ( 1 + doors / ( math.pow(1.2,doors) ) ) ) * timeHours );
end
function PROPERTY:HasOwner()
  return not (not self.owner);
end
function PROPERTY:PlayerHasPermissions(ply)
  if not ply:IsLoaded() then return false end

  if ply:GetCharacter():GetJob() and table.HasValue(self.jobs or {},ply:GetCharacter():GetJob():GetName()) then
    return true
  end

  return self.owner and self.owner == ply:GetCharacter():GetID()
end
