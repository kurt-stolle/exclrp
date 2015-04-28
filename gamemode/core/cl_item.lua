function ERP.ItemInteractWithServer(ent,ply)
  if not (IsValid(ent) and IsValid(ply) and ent:GetClass() == "excl_object") then return end

	net.Start("ERP.InteractItem")
  net.WriteEntity(ent)
  net.WriteEntity(ply)
  net.SendToServer()
end
