local ITEM = ERP.Item();
ITEM:SetName("D4NK W33D");
ITEM:SetDescription("This weed is leet with a slight hint of dankness.");
ITEM:SetModel("models/Weed/weedplant_big_a.mdl");

ITEM:SetInventorySize(2,5)
ITEM:SetInventoryCamPos(Vector(0,60,35))
ITEM:SetInventoryLookAt(Vector(0,0,35))

if CLIENT then
	ITEM:AddHook("Draw",function(self)
		self.Entity:DrawModel()
	end);
end
ITEM();
