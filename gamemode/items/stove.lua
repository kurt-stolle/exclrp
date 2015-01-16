local recipies = {};

local function defineRecipe(item_out,item_in,...)
	local recipe={};

	recipe.output=item_out;
	recipe.ingredients = {item_in, ...};

	table.insert(recipies,recipe);
end

defineRecipe("Bread","Flour","Flour","Water","Love");
defineRecipe("Nigger","Sand","Sand","Sand");
defineRecipe("Cake","Butter","Butter","Flour","Milk","Egg","Egg");

local ITEM = ERP.Item();
ITEM:SetName("Stove")
ITEM:SetDescription("Used to cook various recipies from base ingredients.");	
ITEM:SetModel("models/props_c17/furnitureStove001a.mdl")
if CLIENT then
	-- Draw the model of the entity.
	ITEM:AddHook("Draw", function(self)
		self:DrawModel()
	end);

	-- Open a menu for cooking once this message is received on the client.
	local frame;
	net.Receive("ES.Stove.OpenCooking",function()
		if IsValid(frame) then
			frame:Remove()
		end

		frame=vgui.Create("ESFrame");
		frame:SetTitle("Cooking");
		frame:SetSize(400,200);
		frame:Center();

		-- buttons and stuff here
		for k,v in pairs(recipies)do
			local label=vgui.Create("DLabel",frame);
			label:SetFont("ESDefault");
			label:SetColor(ES.Color.White);
			label:SetText(table.concat(v.ingredients," + ").." = "..v.output);
			label:SizeToContents();
			label:SetPos(10,40+(k-1)*(label:GetTall()+5));
		end

		frame:MakePopup();
	end);

elseif SERVER then
	util.AddNetworkString("ERP.Stove.OpenCooking");

	-- Set use type to simple, meaning no continuous use, but only once per +use call.
	ITEM:AddHook("Initialize",function(self)
		self:SetUseType(SIMPLE_USE);
	end);

	-- Send a message to the client that uses the entity, to open a cooking menu.
	ITEM:AddHook("Use",function(self,ply)
		if IsValid(ply) and ply:IsPlayer() and ply.character then
			net.Start("ERP.Stove.OpenCooking");
			net.Send(ply);
		else
			ES.DebugPrint("Stove use request received. Not valid.");
		end
	end);
end

ITEM();
