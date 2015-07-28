local npc=ERP.NPC();
npc:SetName("Car dealer")
npc:SetDescription("...")

if CLIENT then
  local rows={}
  npc:SetDialogConstructor(function(self,context,npc)
    rows={}

    net.Start("exclrp.cars.get") net.SendToServer()

    local scrollslave=vgui.Create("Panel",context)
    scrollslave:SetPos(0,0)
    scrollslave:SetWide(context:GetWide()-15)

    for k,v in ipairs(ERP.Cars)do
      local pnl=scrollslave:Add("esPanel")
      pnl:SetTall(60)
      pnl:Dock(TOP)
      pnl:DockMargin(10,10,10,0)

      local img=vgui.Create("Spawnicon",pnl)
      img:Dock(LEFT)
      img:SetWide(58)
      img:DockMargin(1,1,1,1)
      img:SetModel(v.model)

      local mid=vgui.Create("Panel",pnl)
      mid:Dock(FILL)
      mid:DockMargin(10,10,10,10)

        local name=vgui.Create("DLabel",mid)
        name:Dock(TOP)
        name:SetText(v.name)
        name:SetFont("ESDefault+")
        name:SetColor(ES.Color.White)
        name:SizeToContents()

        pnl.name=v.name;

        local price=vgui.Create("DLabel",mid)
        price:Dock(BOTTOM)
        price:SetText("Costs $"..v.price)
        price:SetFont("ESDefault")
        price:SetColor(ES.Color.White)
        price:SizeToContents()

        pnl.price=price

      local buy=vgui.Create("esButton",pnl)
      buy:Dock(RIGHT)
      buy:SetWide(100)
      buy:DockMargin(10,10,10,10)
      if not LocalPlayer():GetCharacter():HasCar(v.name) then
        buy:SetText("Purchase")
        if LocalPlayer():GetCharacter():GetCash() < v.price then
          buy:SetDisabled(true)
        end
      else
        buy:SetText("Spawn")
      end

      pnl.buy = buy

      table.insert(rows,pnl)
    end

    scrollslave:SetTall(#ERP.Cars * 70 + 10)

    local scroll=vgui.Create("esScrollbar",context)
    scroll:Dock(RIGHT)
    scroll:Setup()
  end)

  hook.Add("ERPCarsUpdated","exclrp.cardealer.update",function(ply,char,cars)
    for k,v in ipairs(rows)do
      if IsValid(v) then
        if char:HasCar(v.name) then
          v.buy:SetText("Spawn")
          v.buy:SetDisabled(false)
          v.cost:SetText("You own this car.")
          v.cost:SizeToContents()
        end
      end
    end
  end)
elseif SERVER then

end
npc();
