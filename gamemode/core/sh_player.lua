-- BASE HOOKS
function ERP:PlayerNoClip( ply )
  return ply:IsSuperAdmin()
end

-- SANDBOX HOOKS
function ERP:CanTool(ply,tr,tool)
  if IsValid(tr.Entity) and tr.Entity.GetOwner then
    return tr.Entity:GetOwner() == ply or ply:IsSuperAdmin()
  end

  return true
end

function ERP:CanProperty(ply,prop,ent)
  return ply:IsSuperAdmin();
end

-- NETWORKED
ES.DefineNetworkedVariable("erp_clothing","UInt",32)
ES.DefineNetworkedVariable("erp_model","UInt",4)
ES.DefineNetworkedVariable("erp_status","UInt",4)
