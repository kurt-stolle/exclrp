function ENT.SetupInteractionDialog(context,frame)
  ES.DebugPrint("No interaction found")

  local lbl=vgui.Create("esLabel",context)
  lbl:SetText("Hello, "..(LocalPlayer():GetCharacter():GetFirstName()).."!");
  lbl:SizeToContents()
  lbl:SetPos(10,10)
  lbl:SetFont("ESDefault")
  lbl:SetColor(ES.Color.White)
end

net.Receive("ERP.NPC.Interact",function()
  local ent=net.ReadEntity();

  if not IsValid(ent) or not LocalPlayer():IsLoaded() then
    ES.DebugPrint("Invalid interaction")
    return;
  end

  local frame=vgui.Create("esFrame");
  frame:SetTitle("NPC Interaction");
  frame:SetSize(780,500);

  local context=vgui.Create("esPanel",frame)
  context:Dock(FILL)
  context:DockMargin(10,10,10,10)
  context:SetColor(ES.Color["#1E1E1E"])

    local didErr,strErr = pcall(function() ent.SetupInteractionDialog(context,frame) end)
    if didErr then
      ErrorNoHalt(strErr)
    end

  local npcInfo=vgui.Create("esPanel",frame)
  npcInfo:SetWide(200)
  npcInfo:Dock(LEFT)
  npcInfo:DockMargin(10,10,0,10)

    local modelContainer=vgui.Create("esPanel",npcInfo)
    modelContainer:SetTall(npcInfo:GetWide())
    modelContainer:Dock(TOP)
    modelContainer:SetColor(ES.Color["#000000AA"])

    local model=vgui.Create("Spawnicon",modelContainer)
    model:SetSize(modelContainer:GetTall()-2,modelContainer:GetTall()-2)
    model:Dock(FILL)
    model:DockMargin(1,1,1,1)
    model:SetModel(ent:GetModel())

    local name=vgui.Create("esLabel",npcInfo)
    name:SetText(ent.Name)
    name:SetFont("ESDefault+")
    name:Dock(TOP)
    name:DockMargin(10,10,10,10)
    name:SizeToContents()
    name:SetColor(ES.Color.White)

    local close=vgui.Create("esButton",npcInfo)
    close:SetTall(30)
    close:SetText("Leave")
    close.DoClick=function()
      frame:Remove()
    end
    close:Dock(BOTTOM)
    close:DockMargin(10,10,10,10)

  frame:Center()
  frame:MakePopup()
end)
