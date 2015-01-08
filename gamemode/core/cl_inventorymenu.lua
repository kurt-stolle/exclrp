-- cl_inventorymenu.lua
-- the inventory & shop;

surface.CreateFont("ObjectFont",{

	font = "akbar";
	size = 48;

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
	draw.RoundedBox(6,0,0,self:GetWide(),self:GetTall(),Color(0,0,0,200));
	draw.RoundedBox(4,2,2,self:GetWide()-4,self:GetTall()-4,Color(50,50,50,50));
	local skip = false;
	for x=0,self.gridSize.x-1 do
		for y=0,self.gridSize.y-1 do
			if not skip then
			draw.RoundedBoxEx(4,2+x*52,2+y*52,52,52,Color(255,255,255,1),(x==0 and y==0), (x==self.gridSize.x-1 and y==0),  (x==0 and y==self.gridSize.y-1), (x==self.gridSize.x-1 and y==self.gridSize.y-1));
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
	
	
	menu = ERP:CreateExclFrame("In-Game control menu",0,0,700,600,true);
	menu:Center();
	menu:MakePopup();
	
	local tabs = vgui.Create("exclTabbedPanel",menu);
	tabs:SetPos(5,25);
	tabs:SetSize(menu:GetWide()-10,menu:GetTall()-30);
	
	//INVENTORY
	local p =  tabs:AddTab("icon16/application_view_tile.png","Inventory")
	
	--GRID
	local grid = vgui.Create("exclInventoryGrid",p);
	grid:SetPos(5,115);
	grid:SetGridSize(13,8);
	
	--INFO
	local info = vgui.Create("exclPanel",p);
	info:SetPos(5,5);
	info:SetSize(grid:GetWide(),p:GetTall()-grid:GetTall()-5-5-5)
	local l = Label("Placeholder",info);
	l:SetPos(info:GetTall()+10,5);
	l:SetFont("ObjectFont");
	l:SetColor(Color(255,255,255));
	l:SizeToContents();
	
	local use = vgui.Create("esButton",info);
	use:SetPos(info:GetWide()-105,5);
	use:SetSize(100,30);
	use:SetText("Use");
	local destroy = vgui.Create("esButton",info);
	destroy:SetPos(info:GetWide()-105,37.5);
	destroy:SetSize(100,30);
	destroy:SetText("Edit");
	local destroy = vgui.Create("esButton",info);
	destroy:SetPos(info:GetWide()-105,70);
	destroy:SetSize(100,30);
	destroy:SetText("Destroy");
	destroy.Red = true;
	
	//STORE
	tabs:AddTab("icon16/add.png","Store")
	tabs:AddTab("icon16/brick_add.png","Class wholesale");
end);