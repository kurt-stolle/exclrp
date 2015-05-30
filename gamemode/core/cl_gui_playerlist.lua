function ES.OpenUI_Playerlist()
  local frame=vgui.Create("esFrame")
  frame:SetSize(400,600)
  frame:SetTitle("Scoreboard")

  for k,v in ipairs(player.GetAll())do
    if v:IsPlayer() then
      local pnl=frame:Add("esPanel")
      pnl:SetTall(40)
      pnl:SetColor(ES.Color["#1E1E1E"])
      pnl:Dock(TOP)
      pnl:DockMargin(10,10,10,0)

      local ava = pnl:Add("AvatarImage")
      ava:Dock(LEFT)
      ava:SetSize(32,32)
      ava:DockMargin(4,4,4,4)
      ava:SetPlayer(v,34)

      local names = pnl:Add("Panel")
      names:Dock(FILL)

        local name = names:Add("esLabel")
        name:SetFont("ESDefaultBold")
        name:SetText(v:Nick())
        name:Dock(TOP)
        name:SizeToContents()
        name:DockMargin(4,6,4,4)

        local char = names:Add("esLabel")
        char:SetFont("ESDefault")
        char:SetText(v:GetCharacter():GetFullName())
        char:Dock(BOTTOM)
        char:SizeToContents()
        char:DockMargin(4,4,4,4)
    end
  end

  frame:Center()
  frame:MakePopup()
end
