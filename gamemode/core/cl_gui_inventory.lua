-- cl_inventorymenu.lua
-- the inventory & shop;

surface.CreateFont("ERP.InventoryInfoBig",{

	font = "Roboto";
	weight=400;
	size = 36;

})
local BLACK = Color(0,0,0);
local WHITE = Color(255,255,255);
local PNL = {}
function PNL:Init()
	self.grid = {{}}
end
function PNL:SetGridSize(x,y)
	self.gridSize = Vector(x,y,0);
	self:SetSize(x*52 + 4,y*52 + 4);
end
function PNL:Paint()
	draw.RoundedBox(0,0,0,self:GetWide(),self:GetTall(),Color(255,255,255,5));
	draw.RoundedBox(0,1,1,self:GetWide()-2,self:GetTall()-2,ES.Color["#111"]);
	local skip = false;
	for x=0,self.gridSize.x-1 do
		for y=0,self.gridSize.y-1 do
			if not skip then
			draw.RoundedBox(0,2+x*52,2+y*52,52,52,ES.Color["#222"]);
			end
			skip = not skip;
		end
		skip = not skip;
	end
end
vgui.Register("exclInventoryGrid",PNL,"EditablePanel")

local menu;
usermessage.Hook("EOINVM",function()
	if menu and menu:IsValid() then
		menu:Remove();
		return;
	end

	menu = vgui.Create("esFrame");
  menu:SetTitle("Inventory");

	--INFO
	local info = vgui.Create("esPanel",menu);
	info:Dock(TOP)
	info:SetTall(128)
	info:DockMargin(10,10,10,0)

	local spawnicon = vgui.Create("Spawnicon",info)
	spawnicon:Dock(LEFT)
	spawnicon:SetWide(128)
	spawnicon:SetModel("models/error.mdl")

	local l = Label("Placeholder",info);
	l:SetPos(spawnicon:GetWide()+16,8);
	l:SetFont("ERP.InventoryInfoBig");
	l:SetColor(ES.Color.White);
	l:SizeToContents();

	local pnl =  vgui.Create("esPanel",menu)
	pnl:Dock(FILL)
	pnl:DockMargin(10,10,10,10)

		local grid = vgui.Create("exclInventoryGrid",pnl);
		grid:SetGridSize(12,8);
		grid:SetPos(0,0);

	menu:SetSize(10+grid:GetWide()+10,30+10+info:GetTall()+10+grid:GetTall()+10);
	menu:Center();
	menu:MakePopup();
end);
