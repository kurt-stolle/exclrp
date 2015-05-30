-- cl_inventorymenu.lua
-- the inventory & shop;

surface.CreateFont("ERP.InventoryInfoBig",{
	font = "Roboto",
	weight=400,
	size = 36
})

local menu;
function ES.OpenUI_Inventory()
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

		local grid = vgui.Create("ERP.Inventory",pnl);
		grid:SetGridSize(12,8);
		grid:SetPos(0,0);

	menu:SetSize(10+grid:GetWide()+10,30+10+info:GetTall()+10+grid:GetTall()+10);
	menu:Center();
	menu:MakePopup();
end
