function ERP.ItemInteractWithServer(interaction)
  return (function(ent,ply)
    if not IsValid(ent) or not IsValid(ply) or not ply:IsLoaded() or not ent.GetItem then
      ES.DebugPrint("Invalid interaction! ", not IsValid(ent)," ", not IsValid(ply))
      return
    end

    ES.DebugPrint("Interacting with server for action ",interaction)

    net.Start("ERP.InteractItem")
      net.WriteEntity(ent)
      net.WriteString(interaction)
    net.SendToServer()
  end)
end
