-- ingamemenu

 local WHITE = Color(255,255,255);
 local BLACK = Color(0,0,0);

local menu;
usermessage.Hook("EOIERP",function()
	if menu and menu:IsValid() then
		menu:Remove();
		return;
	end


	menu = ERP:CreateExclFrame("Character",0,0,500,500,true);
	menu:Center();
	menu:MakePopup()

	local tabs = vgui.Create("esTabPanel",menu);
	tabs:Dock(FILL)
  tabs:DockMargin(8,8,8,8)
	local pnl = tabs:AddTab("Character","icon16/user.png")

    local id=vgui.Create("ERP.CharacterID",pnl)
    id:Setup(LocalPlayer():GetCharacter())
    id:Dock(FILL)
    id:SetTall(200)
	local pnl = tabs:AddTab("Jobs","icon16/world.png");
    local createJobs;
    createJobs = function()
      for k,v in pairs(ERP.Jobs)do
        if LocalPlayer():Team() == v.team then continue end

    		local jobpnl=vgui.Create("esPanel",pnl)
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
          for k,v in pairs(pnl:GetChildren())do
            for k,v in pairs(v:GetChildren())do
              if v.SetDisabled then
                v:SetDisabled(true)
              end
            end
          end

          timer.Simple(1,function()
            for k,v in pairs(pnl:GetChildren())do
              v:Remove()
            end
            createJobs()
          end)
          RunConsoleCommand("excl_job",v.name)

        end
        pick:DockMargin(10,10,10,10)

    	end
    end
    createJobs()
	tabs:AddTab("Settings","icon16/wrench.png")
end);
