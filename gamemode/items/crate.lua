local ITEM = ERP.Item();
ITEM:SetName("Crate");
ITEM:SetDescription("Can be used to store items and extend your inventory.");
ITEM:SetModel("models/props/de_nuke/crate_extrasmall.mdl");
ITEM:DefineData("inv") -- serverside data

ITEM:SetInventorySize(3,3)
ITEM:SetInventoryCamPos(Vector(1,-1,75))
ITEM:SetInventoryLookAt(Vector(1,-1,0))

ITEM:AddHook("Initialize",function(self)
	self.Storage = ERP.Storage("crate_"..self:EntIndex(),6,6)
end)

if CLIENT then
	ITEM:AddHook("Draw",function(self)
		self.Entity:DrawModel()
	end);

	ITEM:AddInteraction( "Open", function(ent,item)
		local frame=vgui.Create("esFrame")
		frame:Center()

		local inv=vgui.Create("ERP.Inventory",frame)
		inv:SetGridSize(6,6)
	end );
elseif SERVER then

end
ITEM();
