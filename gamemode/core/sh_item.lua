--- item system.
ERP.Items = {};
setmetatable(ERP.Items,{
	__index=function(self,key)
		for k,v in ipairs(self)do
			if key == v:GetName() then
				return v;
			end
		end
		return nil;
	end
})

function ERP.ValidItem(item)
	return item and type(item) == "table" and item.IsItem;
end

local ITEM=FindMetaTable("Item");
AccessorFunc(ITEM,"_value","Value",FORCE_NUMBER);
AccessorFunc(ITEM,"_model","Model",FORCE_STRING);
AccessorFunc(ITEM,"_name","Name",FORCE_STRING);
AccessorFunc(ITEM,"_description","Description",FORCE_STRING);
AccessorFunc(ITEM,"_key","Key",FORCE_NUMBER);
AccessorFunc(ITEM,"_invWidth","InventoryWidth",FORCE_NUMBER);
AccessorFunc(ITEM,"_invHeight","InventoryHeight",FORCE_NUMBER);
AccessorFunc(ITEM,"_invCamPos","InventoryCamPos");
AccessorFunc(ITEM,"_invLookAt","InventoryLookAt");
AccessorFunc(ITEM,"_weapon","Weapon",FORCE_STRING);

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
	obj._invWidth = 1;
	obj._invHeight = 1;
	obj._invCamPos = Vector(0,0,30)
	obj._invLookAt = Vector(0,0,0)
	obj._value = 100
	obj._weapon = nil;
	obj._data=  {}

	-- Only for initialization
	obj._dataTypes={}

	return obj;
end

-- Persistent data
function ITEM:DefineData(key,default,dttyp)
	self._data[key]=default

	if dttyp and dttyp ~= "None" and dttyp ~= "Table" then
		self._dataTypes[key]=dttyp
	end
end
function ITEM:GetData(key)
	return self._data[key]
end

-- Use this hook to add ENT hooks.
function ITEM:AddHook(n,f)
		if type(n) ~= "string" or type(f) ~= "function" then return end

	self._hooks[n] = f;
end

function ITEM:AddInteraction(n,f)
	self._interactions[n] = f;
end

function ITEM:GetInventorySize()
	return self._invWidth,self._invHeight;
end

function ITEM:SetInventorySize(w,h)
	self:SetInventoryWidth(w)
	self:SetInventoryHeight(h)
end

-- Use this hook to register the entity.
function ITEM:__call() -- register
	self._key=(#ERP.Items+1);
	ERP.Items[self._key]=self;

	local ENT={
		Base="erp_object",
		PrintName=self._name,
		Spawnable = true,
		Category = "ExclRP",
		ItemID = self._key;
		Item = self;
		Autor = "Excl",
		AdminOnly = true,
		SetupDataTables = function(ent)
			local countTypes={}
			local dttyp;

			for k,v in pairs(self._data)do
				if not self._dataTypes[k] then continue end

				dttyp=self._dataTypes[k];
				if not countTypes[dttyp] then
					countTypes[dttyp] = 0
				end

				ent:NetworkVar( dttyp, countTypes[dttyp], k )

				countTypes[dttyp]=countTypes[dttyp]+1;
			end
		end
	};
	for k,v in pairs(self._hooks)do
		--some hooks must be wrapped
		if k == "Use" or k == "Initialize" or k == "SetupDataTables" then
			ENT[k]=function(entity,...)
				entity.BaseClass[k](entity,...)
				v(entity,...)
			end
		else
			ENT[k]=v;
		end
	end

	local classname="erp_object_"..util.CRC(self._name);

	scripted_ents.Register( ENT, classname )

	ES.DebugPrint( "Registered item entity "..classname );

	self.SetName = nil;
	self.SetDescription = nil;
	self.AddHook = nil;
	self.AddInteraction = nil;
	self.SetInventorySize= nil;
	self.SetValue = nil;
	self.SetModel = nil;
end

-- Utility
