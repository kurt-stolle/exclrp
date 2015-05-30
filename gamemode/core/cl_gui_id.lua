
function ERP.OpenUI_ID(ply)
  if not ply then
    ply=LocalPlayer()
  elseif not IsValid(ply) or not ply:IsLoaded() then
    return;
  end

  local frame=vgui.Create("esFrame")
  frame:SetSize(20+180+180*(2/3),230)
  frame:Center()
  frame:SetTitle("Identification")

  local id=vgui.Create("ERP.CharacterID",frame)
  id:Setup(ply:GetCharacter())
  id:Dock(FILL)

  frame:MakePopup()
end
