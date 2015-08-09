local JOB=ERP.Job()
JOB:SetName("Police");

-- TODO: Fix shitty generic description
JOB:SetDescription("Law and order is the key to a well functioning society.");
JOB:SetLoadout{"erp_weapon_baton_police"}
JOB:SetFaction(FACTION_GOVERNMENT);
JOB:SetPay(12);
JOB:SetColor(ES.Color.LightBlue);

if CLIENT then
  function JOB:BuildJobMenu(frame)
    -- WANTED
    local pnl = vgui.Create("esPanel",frame)
    pnl:Dock(TOP)
    pnl:SetTall(100)
    pnl:DockMargin(10,10,10,10)

      local lbl=Label("Wanted",pnl)
      lbl:Dock(TOP)
      lbl:SetFont("ESDefault+")
      lbl:SizeToContents()
      lbl:DockMargin(10,10,10,10)
      lbl:SetColor(ES.Color.White)

      local lbl=Label("Select a person in the list below and click the button to make them wanted.\nThis will reveal their location.",pnl)
      lbl:Dock(TOP)
      lbl:SetFont("ESDefault")
      lbl:SizeToContents()
      lbl:DockMargin(10,10,10,10)
      lbl:SetColor(ES.Color.White)

      local combo=vgui.Create("DComboBox",pnl)
      combo:DockMargin(10,10,10,10)
      combo:Dock(TOP)
      combo:SetTall(28)

      for k,v in ipairs(player.GetAll()) do
        if v:IsLoaded() and (not v:GetCharacter():GetJob() or v:GetCharacter():GetJob():GetFaction() ~= FACTION_GOVERNMENT) then
          combo:AddChoice( v:GetCharacter():GetFullName().." ("..v:Nick()..")", v:GetCharacter().Player )
        end
      end

      local btn=vgui.Create("esButton",pnl)
      btn:SetTall(30)
      btn:Dock(TOP)
      btn:DockMargin(10,10,10,10)
      btn:SetText("Make wanted")
      btn.DoClick = function()
        ES.DebugPrint(conbo:GetData(),"is being made wanted/warranted.")

        net.Start("exclrp.job.police.setstatus")
        net.WriteEntity(combo:GetData())
        net.WriteUInt(STATUS_WANTED)
        net.SendToServer()
      end

      function pnl:PerformLayout()
        self:SetTall(btn.y + btn:GetTall() + 10)
      end

    -- WARRANT
    local pnl = vgui.Create("esPanel",frame)
    pnl:Dock(TOP)
    pnl:SetTall(100)
    pnl:DockMargin(10,10,10,10)

      local lbl=Label("Warrant",pnl)
      lbl:Dock(TOP)
      lbl:SetFont("ESDefault+")
      lbl:SizeToContents()
      lbl:DockMargin(10,10,10,10)
      lbl:SetColor(ES.Color.White)

      local lbl=Label("Select a person in the list below and click the button to initiate a warrant.\nThis will allow police to force themselves into the property of the warranted person.",pnl)
      lbl:Dock(TOP)
      lbl:SetFont("ESDefault")
      lbl:SizeToContents()
      lbl:DockMargin(10,10,10,10)
      lbl:SetColor(ES.Color.White)

      local combo=vgui.Create("DComboBox",pnl)
      combo:DockMargin(10,10,10,10)
      combo:Dock(TOP)
      combo:SetTall(28)

      for k,v in ipairs(player.GetAll()) do
        if v:IsLoaded() and (not v:GetCharacter():GetJob() or v:GetCharacter():GetJob():GetFaction() ~= FACTION_GOVERNMENT) then
          combo:AddChoice( v:GetCharacter():GetFullName().." ("..v:Nick()..")", v:GetCharacter().Player )
        end
      end

      local btn=vgui.Create("esButton",pnl)
      btn:SetTall(30)
      btn:Dock(TOP)
      btn:DockMargin(10,10,10,10)
      btn:SetText("Initiate warrant")
      btn.DoClick = function()
        ES.DebugPrint(conbo:GetData(),"is being made wanted/warranted.")

        net.Start("exclrp.job.police.setstatus")
        net.WriteEntity(combo:GetData())
        net.WriteUInt(STATUS_WARRANT)
        net.SendToServer()
      end

      function pnl:PerformLayout()
        self:SetTall(btn.y + btn:GetTall() + 10)
      end

  end
elseif SERVER then
  function JOB:OnSelect(ply)
    ply:GetCharacter():Save("clothing","Police Armor")
  end

  util.AddNetworkString("exclrp.job.police.setstatus")
  net.Receive("exclrp.job.police.setstatus",function(len,ply)
    if not ply:IsLoaded() or ply:Team() ~= JOB:GetTeam() then return end

    local target=net.ReadEntity()
    local status=net.ReadUInt(8)

    if not IsValid(target) or not target:IsPlayer() or not target:IsLoaded() or (target:GetCharacter():GetJob() or target:GetCharacter():GetJob():GetFaction() == FACTION_GOVERNMENT) then return ply:CreateErrorDialog("You can't make a government employee wanted.") end

    if status ~= STATUS_WARRANT and status ~= STATUS_WANTED then return ply:CreateErrorDialog("Invailid status.") end

    ply:AddStatus(status)

    ES.BroadcastChat(target:GetCharacter():GetFullName()..(status == STATUS_WARRANT and " now has a warrant approved." or status == STATUS_WANTED and "is not wanted"))

    if timer.Exists(ply:UniqueID()..".WantedTimer."..status) then
      timer.Remove(ply:UniqueID()..".WantedTimer."..status)
    end

    timer.Create(ply:UniqueID()..".WantedTimer."..status,status == STATUS_WANTED and ERP.Config["wanted_time"] or ERP.Config["warrant_time"],1,function()
      ply:TakeStatus(status)
    end)
  end)

  hook.Add("PlayerDeath","exclrp.job.police.setstatus.death",function(ply)
    if timer.Exists(ply:UniqueID()..".WantedTimer."..STATUS_WANTED) then
      timer.Remove(ply:UniqueID()..".WantedTimer."..STATUS_WANTED)
    end

    ply:TakeStatus(STATUS_WANTED)
  end)
end

JOB();
