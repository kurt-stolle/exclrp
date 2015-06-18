local STOR = FindMetaTable("Storage")

util.AddNetworkString("ERP.Storage.Sync")
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
  net.Send(list)
end

net.Receive("ERP.Storage.Sync",function(len,ply)
  if not IsValid(ply) or not ply:IsLoaded() then return end

  local stor = ERP.Storages[net.ReadString()]
  local open = net.ReadBool()

  if not stor then return ES.DebugPrint("Invalid storage") end

  if open then
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
