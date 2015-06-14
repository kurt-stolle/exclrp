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

    --[[for k,v in ipairs(ERP.Jobs)do
    	local jobpnl=vgui.Create("esPanel",frame)
      jobpnl:SetTall(122);
      jobpnl:Dock(TOP)
      jobpnl:SetColor(ES.Color["#1E1E1E"])
      jobpnl:DockMargin(10,10,10,0)
      local name=jobpnl:Add("esLabel")
      name:SetColor(ES.Color.White)
      name:SetText(v.name)
      name:SetFont("ESDefault++")
      name:SizeToContents()
      name:Dock(TOP)
      name:DockMargin(10,10,10,0)
      local desc=jobpnl:Add("esLabel")
      desc:SetColor(ES.Color["#EEE"])
      desc:SetText(ES.FormatLine(v.description,"ESDefaultBold",440))
      desc:SetFont("ESDefaultBold")
      desc:SizeToContents()
      desc:Dock(TOP)
      desc:DockMargin(10,10,10,0)
      local pick=jobpnl:Add("esButton")
      pick:SetTall(30)
      pick:Dock(BOTTOM)
      pick:SetText("Accept")
      pick.DoClick=function()
        RunConsoleCommand("erp_job",v.name)
        frame:Remove()
      end
      pick:DockMargin(10,10,10,10)
    end]]
  else
    frame:SetSize(500,500);

    local lblJob=frame:Add("esLabel")
    lblJob:SetText(LocalPlayer():GetCharacter():GetJob():GetName())
    lblJob:SizeToContents()
    lblJob:Dock(TOP)
    lblJob:DockMargin(10,10,10,0)
  end

  frame:Center();
	frame:MakePopup()
end
