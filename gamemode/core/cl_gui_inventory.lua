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

	if not LocalPlayer():IsLoaded() then return end

	local inv = LocalPlayer():GetCharacter():GetInventory()

	menu = vgui.Create("esFrame");
  menu:SetTitle("Inventory");

	if not inv then return end

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

	local pnl =  vgui.Create("Panel",menu)
	pnl:Dock(FILL)
	pnl:DockMargin(10,10,10,10)

		local grid = vgui.Create("ERP.Inventory",pnl);
		grid:SetGridSize(inv:GetWidth(),inv:GetHeight());
		grid:SetPos(0,0);
		grid:Setup(inv);

	menu:SetSize(20+grid:GetWide()+20,30+20+info:GetTall()+20+grid:GetTall()+20);
	menu:Center();
	menu:MakePopup();
end
