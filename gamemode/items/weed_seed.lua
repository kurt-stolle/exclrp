local ITEM = ERP.Item();
ITEM:SetName("Weed Seeds");
ITEM:SetDescription("Combine wit a plant pot to grow d4nk w33d.");
ITEM:SetModel("models/props_junk/garbage_metalcan002a.mdl");

ITEM:SetInventorySize(1,1)
ITEM:SetInventoryCamPos(Vector(0,10,5))
ITEM:SetInventoryLookAt(Vector(0,0,5))

if CLIENT then
	ITEM:AddHook("Draw",function(self)
		self.Entity:DrawModel()
	end);
elseif SERVER then

end
ITEM();
