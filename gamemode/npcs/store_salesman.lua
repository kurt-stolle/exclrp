local npc=ERP.NPC();
npc:SetName("Wholesale seller")
npc:SetModel("models/Humans/Group02/male_08.mdl")
npc:SetDescription("An odd looking gentleman.")


local _stor=ERP.Storage("SalesmanGlobal",12,8)
_stor:SetType(STORAGE_OPEN)
_stor:SetIsShop(true)
_stor()


if CLIENT then

  local pnlInventory;
  npc:SetDialogConstructor(function(self,context,npc)
    ES.DebugPrint("Opening salesman _store menu")

    local ply=LocalPlayer()

    if not ply:IsLoaded() then return end

    if not ply:GetCharacter():GetJob() or ply:GetCharacter():GetJob():GetName() ~= "Salesman" then
      local lbl = Label("I have been given strict orders to only sell my stock to Salesmen.\n\nYou should talk to me boss if you're interested in becoming a salesman.",context)
      lbl:SetFont("ESDefault")
      lbl:SetColor(ES.Color.White)
      lbl:SizeToContents()
      lbl:SetPos(15,15)
      return
    end

    _stor:Open()

    context:DockPadding(0,0,0,0)

    --Information panel
  	local info = vgui.Create("esPanel",context);
  	info:Dock(TOP)
  	info:SetTall(128)
  	info:DockMargin(10,10,10,0)

  		local dummy = vgui.Create("Panel",info)
  		dummy:Dock(FILL)
  		function dummy:Paint(w,h)
  			draw.SimpleText("The item you select will appear here","ESDefault++",w/2,h/2,ES.Color["#FFFFFFAA"],1,1)
  		end
  		dummy.IsDummy = true;

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
  		lDescr:SetPos(icon.x + icon:GetWide()+8,lName:GetTall() + lName.y + 2);
  		lDescr:SetFont("ESDefault");
  		lDescr:SetColor(ES.Color.White);
  		lDescr:SizeToContents();

  		local btns = info:Add("Panel")
  		btns:SetWide(100)
  		btns:Dock(RIGHT);
  		btns:DockPadding(4,4,4,4)

  			local bDrop = btns:Add("esButton")
  			bDrop:SetTall(30)
  			bDrop:SetText("Buy for $X")
  			bDrop:Dock(BOTTOM)

  		for k,v in ipairs(info:GetChildren())do
  			v:SetVisible(v.IsDummy and true or false)
  		end

  	-- Grid
  	local pnl =  vgui.Create("Panel",context)
  	pnl:Dock(FILL)
  	pnl:DockMargin(10,10,10,10)


      local inv=vgui.Create("ERP.Inventory",pnl)
      inv:SetGridSize(12,8)

      function inv:OnItemSelected(item,x,y)
  			item = ERP.Items[item]

  			if not item then return end

  			icon:SetModel(item:GetModel())
  			lName:SetText(item:GetName())
  			lName:SizeToContents();
  			lDescr:SetText(item:GetDescription())
  			lDescr:SizeToContents()

  			bDrop.DoClick = function()
  				_stor:TakeItem(item,x,y)
  			end
        bDrop:SetText("Buy for $"..item:GetValue())

  			for k,v in ipairs(info:GetChildren())do
  				v:SetVisible(not v.IsDummy and true or false)
  			end
  		end

      pnlInventory=inv;

    -- Resize the parent to fit.
    function context:PerformLayout()
      if self:GetWide() < (10+inv:GetWide()+10) then
        local defo=(10+inv:GetWide()+10) - self:GetWide()
        self:GetParent():SetWide(self:GetParent():GetWide() + defo)
      end

      if self:GetTall() < (10+info:GetTall()+10+inv:GetTall()+10) then
        local defo=(10+info:GetTall()+10+inv:GetTall()+10) - self:GetTall()
        self:GetParent():SetTall(self:GetParent():GetTall() + defo)
      end

      self:GetParent():Center()
    end
  end)

  hook.Add("ERPStorageUpdated","ERP.NPC.Salesman_storage.Update",function(stor)
    if stor:GetName() == "SalesmanGlobal" then
      if IsValid(pnlInventory) then
        pnlInventory:Setup(stor:GetInventory())
      else
        stor:Close();
      end
    end
  end);
elseif SERVER then
  function _stor:PlayerCanOpen(ply)
    return ply:IsLoaded() and ply:GetCharacter():GetJob() and ply:GetCharacter():GetJob():GetName() == "Salesman";
  end

  timer.Create("ERP.NPC.SalesmanShop.AddItem",60,0,function()
    local rndItem=ERP.Items[table.Random{"Money Printer","First Aid Kit","Bleach","Crate","Casual suit"}]

    if not rndItem then return ES.DebugPrint("Invalid item added to SalesMan Shop") end

    local inv = _stor:GetInventory()

    if not inv then return ES.DebugPrint("Salesman Shop inventory is invalid") end

    local x,y=inv:FitItem(rndItem)

    if x >= 1 and y >= 1 then
      inv:AddItem(rndItem,x,y)
      _stor:Sync()

      ES.DebugPrint("Added new item to Salesman Shop: ",rndItem:GetName())
    end
  end)
end
npc();
