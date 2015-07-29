local ITEM = ERP.Item();
ITEM:SetName("Crate");
ITEM:SetDescription("Can be used to store items and extend your inventory.");
ITEM:SetModel("models/props/de_nuke/crate_extrasmall.mdl");

ITEM:SetInventorySize(3,3)
ITEM:SetInventoryCamPos(Vector(1,-1,52))
ITEM:SetInventoryLookAt(Vector(1,-1,0))

if CLIENT then

	ITEM:AddHook("Draw",function(self)
		self.Entity:DrawModel()
	end);

	ITEM:AddInteraction( "Open", ERP.ItemInteractWithServer("Open") );

elseif SERVER then

	ITEM:AddInteraction("Open",function(self,ply)
		if not IsValid(ply) or not ply:IsPlayer() or not ply:IsLoaded() then return end


	end);

end
ITEM();
