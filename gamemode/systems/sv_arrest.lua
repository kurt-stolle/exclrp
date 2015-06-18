local CHARACTER=FindMetaTable("Character")

function CHARACTER:Arrest()
  if bit.band(self.Player:GetStatus(),STATUS_ARRESTED) then return end

  self.Player:SetStatus( bit.bor(self.Player:GetStatus(),STATUS_ARRESTED) )
  self.Player:Freeze(true)
  self.Player.character.arrested = CurTime() + 30;

  self.Player:ESSendNotification("You have been arrested.")
  self.Player:ESSendNotification("You will be transferred to jail in 30 seconds.")

  ERP.SaveCharacter(self.Player,"arrested");

  timer.Simple(30,function()
    if IsValid(self) and IsValid(self.Player) and self.Player.character == self then
      self.Player:Freeze(false)
      local random = table.Random(ents.FindByClass("erp_jail_spawn"))
      if not IsValid(random) then return end

      self.Player:SetPos(random:GetPos())
    end
  end)
end
