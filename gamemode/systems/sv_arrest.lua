local CHARACTER=FindMetaTable("Character")

hook.Add("PostPlayerDeath","ERP.ArrestDeath",function(ply)
  if ply:IsLoaded() and bit.band(ply:GetStatus(),STATUS_ARRESTED) > 0 then
    ply:SetStatus(0)
    ply:UnLoad();
  end
end)

function CHARACTER:Arrest()
  if bit.band(self.Player:GetStatus(),STATUS_ARRESTED) > 0 then return ES.DebugPrint(self.Player," is already arrested") end

  ES.DebugPrint(self.Player," is being arrested!")

  self.Player:SetStatus( self.Player:GetStatus() + STATUS_ARRESTED )
  self.Player:Freeze(true)
  self.arrested = os.time() + 20;

  self.Player:ESSendNotificationPopup("Arrested","You have been arrested!\n\nYou have been sentenced to "..math.ceil(ERP.arrestTime/60).." minutes in jail.\n\nYou will be automatically transferred to jail in 20 seconds. You will remain there until your jail time is over or until a Police officer unarrests you.")

  ERP.SaveCharacter(self.Player,"arrested");

  timer.Simple(20,function()
    if self and IsValid(self.Player) and self.Player:GetCharacter() == self and bit.band(self.Player:GetStatus(),STATUS_ARRESTED) > 0 then
      self.Player:Freeze(false)

      local random = table.Random(ents.FindByClass("erp_jail_spawn"))
      if not IsValid(random) then return ES.DebugPrint("No JailSpawn areas found!") end

      self.Player:SetPos(random:GetPos())

      timer.Create("ERP."..self:GetFullName()..".ArrestTimer",ERP.arrestTime,1,function()
        if self and IsValid(self.Player) and self.Player:GetCharacter() == self and bit.band(self.Player:GetStatus(),STATUS_ARRESTED) > 0 then
            self:UnArrest()
        end
      end)
    end
  end)
end

function CHARACTER:UnArrest()
  if bit.band(self.Player:GetStatus(),STATUS_ARRESTED) == 0 then return end

  ES.DebugPrint(self.Player," was unarrested!")

  if timer.Exists("ERP."..self:GetFullName()..".ArrestTimer") then
    timer.Remove("ERP."..self:GetFullName()..".ArrestTimer")
  end

  self.Player:SetStatus(self.Player:GetStatus() - STATUS_ARRESTED)

  self.arrested = 0;

  self.Player:ESSendNotificationPopup("Unarrested","You have been released from custody.")

  ERP.SaveCharacter(self.Player,"arrested");
end
