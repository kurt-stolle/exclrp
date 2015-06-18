
function ERP.OpenUI_ID(ply)
  if not ply then
    ply=LocalPlayer()
  elseif not IsValid(ply) or not ply:IsLoaded() then
    return;
  end

  local frame=vgui.Create("Panel")

  local id=vgui.Create("ERP.CharacterID",frame)
  id:Setup(ply:GetCharacter())
  id:Dock(TOP)
  id:SetTall(id.container:GetTall())

  local close=vgui.Create("esButton",frame)
  close:SetText("Close")
  close:SetTall(30)
  close:Dock(BOTTOM)
  close.DoClick = function() frame:Remove() end;

  frame:SetSize(id.container:GetWide(),id.container:GetTall()+10+close:GetTall())
  frame:Center()
  frame:MakePopup()
end
