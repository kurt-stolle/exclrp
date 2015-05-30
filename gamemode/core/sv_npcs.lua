net.Receive("ERP.NPC.Interact",function(len,ply)
  local npc=net.ReadEntity();
  local name=net.ReadString();
  local data=net.ReadTable();

  if not IsValid(npc) or not ERP.NPCs[npc.PrintName or ""] then
    ES.DebugPrint("Invalid interaction (1).")
    return
  end

  if npc:GetPos():Distance(ply:GetPos()) > 200 then
    ES.DebugPrint("Invalid interaction (2).")
    return
  end

  local i=ERP.NPCs[npc.PrintName or ""]._interactions[name];

  if not i then
    ES.DebugPrint("Invalid interaction (3).")
    return
  end

  i(ply,unpack(data))
end)
