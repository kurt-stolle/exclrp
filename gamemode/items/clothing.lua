for k,v in ipairs(ERP.Clothing)do
  local ITEM = ERP.Item();
  ITEM:SetName(v.name);
  ITEM:SetDescription("A set of "..v.name.." clothing.");
  ITEM:SetModel("models/Items/item_item_crate.mdl");

  ITEM:SetInventorySize(3,3)
  ITEM:SetInventoryCamPos(Vector(1,-1,42))
  ITEM:SetInventoryLookAt(Vector(1,-1,0))

  if CLIENT then

  	ITEM:AddHook("Draw",function(self)
  		self.Entity:DrawModel()
  	end);

  	ITEM:AddInteraction( "Wear", ERP.ItemInteractWithServer("Wear") );

  elseif SERVER then

  	ITEM:AddInteraction("Wear",function(self,ply)
  		if not IsValid(ply) or not ply:IsPlayer() or not ply:IsLoaded() then return end

      local old,pos,ang=ply:GetCharacter():GetClothing().name,self:GetPos(),self:GetAngles()
      -- Set clothing
      ply:GetCharacter():Save("clothing",self:GetName())

      self:Remove();

      -- Spawn old clothing
      ERP.Items[old]:SpawnInWorld(pos,ang)
  	end);

  end
  ITEM();
end
