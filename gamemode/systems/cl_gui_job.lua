-- ingameframe

local frame;
function ERP.OpenUI_Job()
	if frame and frame:IsValid() then
		frame:Remove();
		return;
	end

  local ply=LocalPlayer()

  if not ply:IsLoaded() then return end


	frame = vgui.Create("esFrame");
  frame:SetTitle("Job");

  if not ply:GetCharacter() or not ply:GetCharacter():GetJob() then
    frame:SetSize(400,110);

    local lblJob=frame:Add("DLabel")
    lblJob:SetText("It appears that you are currently Unemployed.\nTo get a job, find an employer NPC somewhere around the map.\n\nYou can, of course, also make money in other ways.")
    lblJob:SetFont("ESDefault")
    lblJob:SetColor(ES.Color.White)
    lblJob:SizeToContents()
    lblJob:Dock(TOP)
    lblJob:DockMargin(10,10,10,0)
  else
    frame:SetSize(500,500);

    ERP.Jobs[ply:Team()]:BuildJobMenu(frame)
  end

  frame:Center();
	frame:MakePopup()
end
