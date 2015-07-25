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

      local pos = self:GetPos()
      local ang = self:GetAngles()

      ang:RotateAroundAxis(ang:Up(),180)

      cam.Start3D2D(pos + ang:Up() * 23.75, ang, 0.2)
      	draw.SimpleText(ITEM:GetName(),"ESDefaultBold",-5,-65,ES.Color.Black,1,1)
        draw.SimpleText(ITEM:GetName(),"ESDefaultBold",-5,-65,ES.Color.Black,1,1)
      cam.End3D2D()
  	end);

  	ITEM:AddInteraction( "Wear", ERP.ItemInteractWithServer("Wear") );

  elseif SERVER then

  	ITEM:AddInteraction("Wear",function(self,ply)
  		if not IsValid(ply) or not ply:IsPlayer() or not ply:IsLoaded() then return end

      local old,pos,ang=ply:GetCharacter():GetClothing().name,self:GetPos(),self:GetAngles()
      -- Set clothing
      ply:GetCharacter():Save("clothing",ITEM:GetName())
      ply:SetModel(ply:GetCharacter():IsFemale() and ply:GetCharacter():GetClothing().modelFemale or ply:GetCharacter():GetClothing().model);

      self:Remove();

      -- Spawn old clothing
      ERP.Items[old]:SpawnInWorld(pos,ang)
  	end);

  end
  ITEM();
end
