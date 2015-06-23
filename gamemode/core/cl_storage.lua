local STOR = FindMetaTable("Storage")

local cbck={}
function STOR:Open(callback)
  -- Start synchronizing
  net.Start("ERP.Storage.Sync")
  net.WriteString(self:GetName())
  net.WriteBool(true)
  net.SendToServer()

  -- Allow callbacks
  if callback then
    if not cbck[self:GetName()] then
      cbck[self:GetName()]={};
    end

    table.insert(cbck[self:GetName()],callback)
  end
end
function STOR:Close()
  -- Stop synchronizing
  net.Start("ERP.Storage.Sync")
  net.WriteString(self:GetName())
  net.WriteBool(false)
  net.SendToServer()
end

function STOR:TakeItem(item,x,y)
  net.Start("ERP.Storage.Take")
  net.WriteString(self:GetName())
  net.WriteString(item:GetName())
  net.WriteUInt(x,8)
  net.WriteUInt(y,8)
  net.SendToServer()
end

net.Receive("ERP.Storage.Sync",function()
  -- Receive inventory synchronization msg.
  local stor=ERP.Storages[net.ReadString()];

  if not stor then return end

  local inv=net.ReadString()

  if not inv then return end

  -- Decode inventory
  stor.inventory = ERP.DecodeInventory(inv);
  stor:SetType(net.ReadUInt(8) or stor:GetType())

  -- Call hook *see readme
  hook.Call("ERPStorageUpdated",ERP,stor)

  -- Check whether we should run a callback
  if cbck[stor:GetName()] then
    for k,v in pairs(cbck[stor:GetName()])do
      if cbck[stor:GetName()] then
        cbck[stor:GetName()](stor)
        cbck[stor:GetName()]=nil;
      end
    end
  end
  -- Debug
  ES.DebugPrint("Storage updated: ",stor:GetName())
end)
