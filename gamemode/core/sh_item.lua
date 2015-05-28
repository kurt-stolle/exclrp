--- item system.
ERP.Items = {};
setmetatable(ERP.Items,{
	__index=function(self,key)
		for k,v in pairs(self)do
			if string.lower(key) == string.lower(v._name) then
				return v;
			end
		end
		return nil;
	end
})

local ITEM=FindMetaTable("Item");
AccessorFunc(ITEM,"_value","Value",FORCE_NUMBER);
AccessorFunc(ITEM,"_model","Model",FORCE_STRING);
AccessorFunc(ITEM,"_name","Name",FORCE_STRING);
AccessorFunc(ITEM,"_description","Description",FORCE_STRING);
AccessorFunc(ITEM,"_key","Key",FORCE_NUMBER);

-- The constructor.
function ERP.Item()
	obj={}
	setmetatable(obj,ITEM);
	ITEM.__index = ITEM;

	obj._name = "Undefined";
	obj._description = "An unidentified object.";
	obj._hooks = {}; -- entity hooks
	obj._interactions = {}
	obj._model = "";
	obj._key = 0;

	return obj;
end

-- Use this hook to add ENT hooks.
function ITEM:AddHook(n,f)
		if type(n) ~= "string" or type(f) ~= "function" then return end

	self._hooks[n] = f;
end

function ITEM:AddInteraction(n,f)
	self._interactions[n] = f;
end

-- Use this hook to register the entity.
function ITEM:__call() -- register
	self._key=(#ERP.Items+1);
	ERP.Items[self._key]=self;

	local ENT={
		Base="excl_object",
		PrintName=self._name,
		Item=self._key,
		Spawnable = true,
		Category = "ExclRP",
		Autor = "Excl",
		AdminOnly = true
	};
	for k,v in pairs(self._hooks)do
		--some hooks must be wrapped
		if k == "Use" or k == "Initialize" then
			ENT[k]=function(entity,...)
				entity.BaseClass[k](entity,...)
				v(entity,...)
			end
		else
			ENT[k]=v;
		end
	end

	local classname="excl_object_"..util.CRC(self._name);

	scripted_ents.Register( ENT, classname )

	ES.DebugPrint( "Registered item entity "..classname );
end

-- Utility
