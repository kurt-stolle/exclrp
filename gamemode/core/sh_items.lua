--- item system.
ERP.Items = {};

local meta = {}
AccessorFunc(meta,"value","Value",FORCE_NUMBER);
AccessorFunc(meta,"model","Model",FORCE_STRING);
AccessorFunc(meta,"id","ID",FORCE_STRING);
AccessorFunc(meta,"name","Name",FORCE_STRING);
AccessorFunc(meta,"description","Description",FORCE_STRING);
function ERP:Item()
	obj={}
	setmetatable(obj,meta);
	meta.__index = meta;
	
	obj.name = "Undefined";
	obj.description = "An unidentified object.";
	obj.hooks = {}; -- entity hooks and onUse and onDrop
	obj.value = 100;
	obj.model = "";
	obj.id = "";

	return obj;
end

function meta:SetInfo(name,desc)
	self.name = name or "Undefined";
	self.description = desc or "An unidentified object.";
end
function meta:AddHook(n,f)
	self.hooks[n] = f;
end
function meta:__call(name) -- register
	ERP.Items[name] = self;
	self.id = name;
end


if SERVER then
	function meta:SpawnInWorld(pos,ang,owner)
		local e = ents.Create("excl_object");
		e:SetPos(pos);
		e:SetAngles(ang);
		e:SetModel(self.model);
		if IsValid(owner) then
			e:SetOwner(owner);
		end
		for k,v in pairs(self.hooks)do
			if k != "onUse" and k != "onDrop" and k != "Initialize" then
				e[k]=v;
			end
		end
		e:Spawn();
		e:SetItem(self);
	end
	concommand.Add("excl_admin_spawnitem",function(p,c,a)
		if not IsValid(p) or not p:IsSuperAdmin() then return end

		local name = table.concat(a," ");
		if ERP.Items[name] then
			ERP.Items[tonumber(util.CRC(string.lower(table.concat(a," "))))]:SpawnInWorld(p:GetEyeTrace().HitPos,p:GetAngles(),p);
		end
	end)
end




