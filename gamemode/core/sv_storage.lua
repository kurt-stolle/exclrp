local STOR = FindMetaTable("Storage")

function STOR:PlayerCanOpen(ply)
  return true
end

function STOR:Sync(ply)
  -- Get the listeners
  local list = self.Listeners;
  if IsValid(ply) then
    list={ply}
  end

  if not list then return end

  -- Filter out all players who left or smthn
  while true do
    local switch=false;
    for k,v in pairs(list)do
      if not IsValid(v) then
        table.remove(list,k)
        switch=true
        break;
      end
    end

    if not switch then break end
  end

  -- Synchronize
  net.Start("ERP.Storage.Sync")
  net.WriteString(self:GetName())
  net.WriteString(ERP.EncodeInventory(self:GetInventory()))
  net.WriteUInt(self:GetType(),8)
  net.Send(list)
end

function STOR:PlayerTakeItem(ply,itemName,x,y)
  local item = ERP.Items[itemName]
  if not self.inventory:HasItemAt(item:GetName(),x,y) then return ES.DebugPrint(ply," tried to take invalid item from storage") end

  local xInv,yInv = ply:GetCharacter():GetInventory():FitItem(item)

  if xInv <= 0 or yInv <= 0 then return ply:CreateErrorDialog("You don't have space in your inventory for this purchase.") end

  if self:GetIsShop() then
    local price = item:GetValue()

    if ply:GetCharacter():GetCash() < price then return ply:CreateErrorDialog("You don't have enough cash to make this purchase.") end

    ply:GetCharacter():TakeCash(price)

    ply:ESSendNotificationPopup("Success","The item was purchased and added to your inventory.")
  end

  ply:GetCharacter():GiveItem(item,xInv,yInv,self.inventory:GetItemData(item,x,y))
  self.inventory:RemoveItem(item,x,y)
  self:Sync()
end

util.AddNetworkString("ERP.Storage.Take")
net.Receive("ERP.Storage.Take",function(len,ply)
  local stor = ERP.Storages[net.ReadString()]
  local item = net.ReadString()
  local x = net.ReadUInt(8)
  local y = net.ReadUInt(8)

  if not stor or not item or not x or not y then return end

  stor:PlayerTakeItem(ply,item,x,y)
end)

util.AddNetworkString("ERP.Storage.Sync")
net.Receive("ERP.Storage.Sync",function(len,ply)
  if not IsValid(ply) or not ply:IsLoaded() then return end

  local stor = ERP.Storages[net.ReadString()]
  local open = net.ReadBool()

  if not stor then return ES.DebugPrint("Invalid storage") end

  if open then
    if stor:GetType() == STORAGE_LOCKED then
      ply:CreateErrorDialog("The storage is locked.")
      return
    elseif not stor:PlayerCanOpen(ply) then
      ply:CreateErrorDialog("You are not allowed to view this storage.")
      return
    end

    if not stor.Listeners then
      stor.Listeners = {}
    end

    for k,v in pairs(stor.Listeners)do
      if v == ply then return stor:Sync(ply) end
    end

    table.insert(stor.Listeners,ply)

    stor:Sync(ply)
  elseif not open then
    if not stor.Listeners then return end

    for k,v in pairs(stor.Listeners)do
      if v == ply then
        table.remove(stor.Listeners,k)
        break;
      end
    end
  end
end)
