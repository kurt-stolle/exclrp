local ITEM = ERP.Item();
ITEM:SetName("Crate");
ITEM:SetDescription("Stores stuff.");
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
  		draw.SimpleText("EXCL SUPPLY & CO.","ESDefaultBold",-5,-65,ES.Color.Black,1,1)
      draw.SimpleText("EXCL SUPPLY & CO.","ESDefaultBold",-5,-65,ES.Color.Black,1,1)
  	cam.End3D2D()
	end);

	ITEM:AddInteraction( "Open", ERP.ItemInteractWithServer("Open") );

elseif SERVER then

	ITEM:AddInteraction("Open",function(self,ply)
		if not IsValid(ply) or not ply:IsPlayer() or not ply:IsLoaded() then return end


	end);

end
ITEM();
