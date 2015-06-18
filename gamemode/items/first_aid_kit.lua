local ITEM = ERP.Item();
ITEM:SetName("First Aid Kit");
ITEM:SetDescription("Regenterates the user's health fully.");
ITEM:SetModel("models/Items/HealthKit.mdl");

ITEM:SetInventorySize(2,2)
ITEM:SetInventoryCamPos(Vector(5,0,15))
ITEM:SetInventoryLookAt(Vector(5,0,0))

if CLIENT then

	ITEM:AddHook("Draw",function(self)
		self.Entity:DrawModel()
	end);

	ITEM:AddInteraction( "Use", ERP.ItemInteractWithServer("Use") );

elseif SERVER then

	ITEM:AddInteraction("Use",function(self,ply)
		if not IsValid(ply) or not ply:IsPlayer() or not ply:IsLoaded() then return end

		ES.DebugPrint("Regenerating "..ply:Nick().." to full health.");

    ply:SetHealth(100)

    self:Remove()
	end);

end
ITEM();
