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

		local icon = vgui.Create("Spawnicon",info)
		icon:SetSize(120,120)
		icon:SetPos(4,4)
		icon:SetModel("models/error.mdl")

		local lName = Label("Placeholder",info);
		lName:SetPos(icon.x + icon:GetWide()+8,8);
		lName:SetFont("ERP.InventoryInfoBig");
		lName:SetColor(ES.Color.White);
		lName:SizeToContents();

		local lDescr = Label("Placeholder",info);
		lDescr:SetPos(icon.x + icon:GetWide()+8,lName:GetTall() + lName.y + 8);
		lDescr:SetFont("ESDefault");
		lDescr:SetColor(ES.Color.White);
		lDescr:SizeToContents();

		local btns = info:Add("Panel")
		btns:SetWide(100)
		btns:Dock(RIGHT);
		btns:DockPadding(4,4,4,4)

			local bDrop = btns:Add("esButton")
			bDrop:SetTall(30)
			bDrop:SetText("Drop")
			bDrop:Dock(BOTTOM)
			bDrop.DoClick = function()

			end
	--GRID
	local pnl =  vgui.Create("Panel",menu)
	pnl:Dock(FILL)
	pnl:DockMargin(10,10,10,10)

		local grid = vgui.Create("ERP.Inventory",pnl);
		grid:SetGridSize(inv:GetWidth(),inv:GetHeight());
		grid:SetPos(0,0);
		grid:Setup(inv);

		function grid:OnItemSelected(item,x,y)
			item = ERP.Items[item]

			if not item then return end

			icon:SetModel(item:GetModel())
			lName:SetText(item:GetName())
			lName:SizeToContents();
			lDescr:SetText(item:GetDescription())
			lDescr:SizeToContents()
		end

		menu.inventory = grid;

	menu:SetSize(20+grid:GetWide()+20,30+20+info:GetTall()+20+grid:GetTall()+20);
	menu:Center();
	menu:MakePopup();
end

hook.Add("ERPCharacterUpdated","ERP.InventoryUI.Update",function(char,k,v)
	if k == "inventory" and IsValid(menu) and IsValid(menu.inventory) then
		menu.inventory:Setup(v)
	end
end)
