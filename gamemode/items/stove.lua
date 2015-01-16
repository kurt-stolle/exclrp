local ITEM = ERP.Item();
ITEM:SetName("Stove")
ITEM:SetDescription("Used to cook things")	
ITEM:SetModel("models/props_interiors/stove02.mdl")
ITEM.Ingredients = {}
ITEM.Recipes = {}

stove = {};

function ERP.addIngredient(ing)
	if (!stove.Ingredients[ing]) then
		stove.Ingredients[ing] = { amount = 0 } 
	end
end

function ERP.addRecipe(rec, ing)
	if (!stove.Recipes[rec]) then
		stove.Recipes[rec] = ing
	end
end

ERP.addIngredient("Flour")
ERP.addRecipe("Bread", { ["Flour"] = 1 })

if CLIENT then
	ITEM.AddHook("Draw", function(self)
		self.Entity:DrawModel()
	end);

	else if SERVER then
		ITEM.AddHook("Initialize", function(self)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		local physObj = self:GetPhysicsObject()
		physObj:Wake()
		physObj:SetMass(10)
		self.Damage = 100
		end);
	end
end

ITEM();
