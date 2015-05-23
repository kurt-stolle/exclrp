function ERP.ItemInteractWithServer(interaction)
  return (function(ent,ply)
    if not (IsValid(ent) and IsValid(ply) and ent:GetClass() == "excl_object") then return end

  	net.Start("ERP.InteractItem")
    net.WriteEntity(ent)
    net.WriteString(interaction)
    net.SendToServer()
  end)
end
