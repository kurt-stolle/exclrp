local npc=ERP.NPC();
npc:SetName("Property salesman")
npc:SetDescription("Hello!\n\nI can sell you a number of properties around "..game.GetMap()..".\nJust click on one of the panels below to buy the property.")
npc:SetDialogConstructor(function(self,context,frame)
  ES.DebugPrint("Opening property sales menu")

  for k,v in ipairs(ERP.Properties)do
    local pnl=context:Add("esPanel")
    pnl:SetTall(100)
    pnl:Dock(TOP)
    pnl:DockMargin(10,10,10,0)

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
    buy:SetDisabled(true)
    buy:SetText("Buy property")
    buy:DockMargin(10,10,10,10)
  end
end)
npc();
