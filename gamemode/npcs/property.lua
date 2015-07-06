local npc=ERP.NPC();
npc:SetName("Property salesman")
npc:SetDescription("...")

if CLIENT then
  local rows={}
  npc:SetDialogConstructor(function(self,context,npc)
    ES.DebugPrint("Opening property sales menu")

    local scrollslave=vgui.Create("Panel",context)
    scrollslave:SetPos(0,0)
    scrollslave:SetWide(context:GetWide()-15)

    for k,v in ipairs(ERP.Properties)do
      local pnl=scrollslave:Add("esPanel")
      pnl:SetTall(100)
      pnl:Dock(TOP)
      pnl:DockMargin(10,10,10,0)
      pnl.property=v;

      local name=pnl:Add("esLabel")
      name:SetText(v.name)
      name:SetFont("ESDefault+")
      name:SetColor(ES.Color.White)
      name:SizeToContents()
      name:Dock(TOP)
      name:DockMargin(10,10,10,0)

      local description=pnl:Add("esLabel")
      description:SetText(v.description)
      description:SetFont("ESDefault")
      description:SetColor(ES.Color["#EEE"])
      description:SizeToContents()
      description:Dock(TOP)
      description:DockMargin(10,4,10,0)

      local buy=pnl:Add("esButton")
      buy:SetTall(30)
      buy:Dock(BOTTOM)
      buy:SetDisabled(v:HasOwner())
      buy:SetText("Rent property ($"..v:GetPrice(1).." per hour)")
      buy:DockMargin(10,10,10,10)
      buy.DoClick=function()
        local menu = DermaMenu()
        for i=1,6 do
            menu:AddOption( i..(i==1 and " hour" or " hours"), function()
              net.Start("ERP.NPC.Property.buy")
              net.WriteString(v:GetName())
              net.WriteUInt(i,8)
              net.SendToServer()

              buy:SetDisabled(true)
            end )
        end
        menu:AddOption( "Cancel", function() end )
        menu:Open()
      end
      pnl.btn_buy = buy;

      table.insert(rows,pnl)
    end

    scrollslave:SetTall(#ERP.Properties * 110 + 10)

    local scroll=vgui.Create("esScrollbar",context)
    scroll:Dock(RIGHT)
    scroll:Setup()
  end)

  net.Receive("ERP.NPC.Property.buy",function()
    local name=net.ReadString()

    if not name then return end

    for k,v in pairs(rows)do
      if IsValid(v) and v.property and v.property:GetName() == name then
        pnl.btn_buy:SetDisabled(true)
      end
    end
  end)
elseif SERVER then
  util.AddNetworkString("ERP.NPC.Property.buy")
  net.Receive("ERP.NPC.Property.buy",function(len,ply)
    if not ply:IsLoaded() then return end

    local prop=ERP.Properties[net.ReadString()]
    local time=net.ReadUInt(8)

    if not prop or not time then return ES.DebugPrint(ply," attempted to buy an invalid property.") end

    if prop:HasOwner() then
      return ply:CreateErrorDialog("This property has already been purchased by somebody else.")
    end

    if time > 6 then
     return ply:CreateErrorDialog("You can buy a property for a maximum of 6 hours")
    end

    local price=prop:GetPrice(time)
    local char=ply:GetCharacter()

    if char:GetBank() < price then
      return ply:CreateErrorDialog("You don't have enough cash on your bank account for this purchase.")
    end

    char:TakeBank(price)
    prop:SetOwner(ply,time)

    net.Start("ERP.NPC.Property.buy")
    net.WriteString(prop:GetName())
    net.SendOmit(ply)

    ply:ESSendNotificationPopup("Success","Congratulations!\n\nYou are now the owner of "..prop:GetName().." for "..time.." hours.\n\nIf you're still around when the property nears its expiration date, then it will automatically be extended by 1 hour.")
  end);
end
npc();
