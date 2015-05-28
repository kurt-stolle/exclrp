ERP.NPCs={}
setmetatable(ERP.NPCs,{
	__index=function(self,key)
		for k,v in pairs(self)do
			if string.lower(key) == string.lower(v._name) then
				return v;
			end
		end
		return nil;
	end
})

local NPC=FindMetaTable("NPC");

AccessorFunc(NPC,"_key","Key",FORCE_NUMBER);
AccessorFunc(NPC,"_name","Name",FORCE_STRING);
AccessorFunc(NPC,"_description","Description",FORCE_STRING);
AccessorFunc(NPC,"_fn","DialogConstructor");

-- The defaultDialog
local defaultDialog = function(self,context,frame)
  local lbl=vgui.Create("esLabel",context)
  lbl:SetText("Hello, "..(LocalPlayer():GetCharacter():GetFirstPrintName()).."!");
  lbl:SizeToContents()
  lbl:SetPos(10,10)
  lbl:SetFont("ESDefault")
  lbl:SetColor(ES.Color.White)
end

-- The constructor.
function ERP.NPC()
	obj={}

	setmetatable(obj,NPC);
  NPC.__index = NPC;

	obj._name = "Undefined";
	obj._description = "An unidentified object.";
  obj._fn = defaultDialog;


	return obj;
end

function NPC:__call() -- register
	self._key=(#ERP.NPCs+1);
	ERP.NPCs[self._key]=self;

	local ENT={
		Base="excl_npc_base",
		PrintName=self._name,
		Spawnable = true,
    AdminOnly = true,
    Category = "ExclRP",
    Author = "Excl"
	};

  local classname="excl_npc_"..util.CRC(self._name);

	scripted_ents.Register( ENT, classname )

	ES.DebugPrint( "Registered item entity "..classname );
end
