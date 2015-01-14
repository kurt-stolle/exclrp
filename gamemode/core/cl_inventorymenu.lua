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
	
	
	menu = ERP:CreateExclFrame("Items & Inventory",0,0,12*52 + 20 + 10,620,true);
	menu:Center();
	menu:MakePopup();
	
	local tabs = vgui.Create("esTabPanel",menu);
	tabs:SetPos(5,35);
	tabs:SetSize(12*52 + 20,menu:GetTall()-40);
	
	//INVENTORY
	local pnl =  tabs:AddTab("Inventory","icon16/application_view_tile.png")
	
	--GRID
	local grid = vgui.Create("exclInventoryGrid",pnl);
	grid:SetGridSize(12,8);
	
	--INFO
	local info = vgui.Create("exclPanel",pnl);
	info:SetPos(10,10);
	info:SetSize(grid:GetWide(),pnl:GetTall()-grid:GetTall()-10-10-10)

	grid:SetPos(10,info.y + info:GetTall() + 10);

	local l = Label("Placeholder",info);
	l:SetPos(info:GetTall()+10,5);
	l:SetFont("ERP.InventoryInfoBig");
	l:SetColor(ES.Color.White);
	l:SizeToContents();
	
	local btn_tall = (info:GetTall()-5*4)/3
	local use = vgui.Create("esButton",info);
	use:SetPos(info:GetWide()-105,5);
	use:SetSize(100,btn_tall);
	use:SetText("Use");
	local edit = vgui.Create("esButton",info);
	edit:SetPos(info:GetWide()-105,btn_tall+10);
	edit:SetSize(100,btn_tall);
	edit:SetText("Edit");
	local destroy = vgui.Create("esButton",info);
	destroy:SetPos(info:GetWide()-105,(btn_tall*2)+15);
	destroy:SetSize(100,btn_tall);
	destroy:SetText("Destroy");
	destroy.Red = true;
	
	//STORE
	tabs:AddTab("Store","icon16/add.png")
	tabs:AddTab("Class wholesale","icon16/brick_add.png");
end);