--- item system.
ERP.Items = {};
local meta = {}
function ERP:Item()
	obj={}
	setmetatable(obj,meta);
	meta.__index = meta;
	
	obj.id = tostring(#ERP.Items+1);
	obj.name = "Undefined";
	obj.description = "An unidentified object.\nProbrably a bug.";
	obj.hooks = {}; -- entity hooks and onUse and onDrop
	obj.value = 100;
	obj.model = "";
	obj.registration = 0;

	return obj;
end

function meta:SetInfo(id,name,desc)
	self.id = id or self.id;
	self.name = name or "Undefined";
	self.description = desc or "An unidentified object.\nProbrably a bug.";
end
function meta:SetValue(v)
	self.value=tonumber(v);
end
function meta:AddHook(n,f)
	self.hooks[n] = f;
end
function meta:SetModel(m)
	self.model = m or "";
end
function meta:__call() -- register
	local id = tonumber(util.CRC(string.lower(self.name)));
	ERP.Items[id] = self;
	self.registration = id;
end


if SERVER then
	function meta:SpawnInWorld(pos,ang,owner)
		local e = ents.Create("excl_object");
		e:SetPos(pos);
		e:SetAngles(ang);
		e:SetModel(self.model);
		if IsValid(owner) then
			e.dt.owner = owner;
		end
		for k,v in pairs(self.hooks)do
			if k != "onUse" and k != "onDrop" and k != "Initialize" then
				e[k]=v;
			end
		end
		e:Spawn();
		e:SetItem(self.registration)
	end
	concommand.Add("excl_cheat_spawnitem",function(p,c,a)
		if p and p:IsSuperAdmin() and a[1] and ERP.Items[tonumber(util.CRC(string.lower(table.concat(a," "))))] then
			ERP.Items[tonumber(util.CRC(string.lower(table.concat(a," "))))]:SpawnInWorld(p:GetEyeTrace().HitPos,p:GetAngles(),p);
		else
			p:ChatPrint("Invalid item specified or invalid rank.")
		end
	end)
end




