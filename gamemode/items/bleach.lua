local ITEM = ERP.Item();
ITEM:SetName("Bleach");
ITEM:SetDescription("Used to clean filth.");
ITEM:SetModel("models/props_junk/garbage_plasticbottle001a.mdl");

ITEM:SetInventorySize(1,1)
ITEM:SetInventoryCamPos(Vector(0,0,16))
ITEM:SetInventoryLookAt(Vector(0,0,0))

if CLIENT then

	ITEM:AddHook("Draw",function(self)
		self.Entity:DrawModel()
	end);

	ITEM:AddInteraction( "Drink", ERP.ItemInteractWithServer("Drink") );

elseif SERVER then

	ITEM:AddInteraction("Drink",function(self,ply)
		if not IsValid(ply) or not ply:IsPlayer() or not ply:IsLoaded() then return end

		ES.DebugPrint(ply:Nick().." drank bleach.");

    ply:TakeDamage( 90, ply, self )
    self:Remove();
	end);

end
ITEM();
