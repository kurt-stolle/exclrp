-- ExclRP Stove
-- Leaving comments which I'll remove once committed so you understand why I did things

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Stove"
ENT.Author = "Turb"
ENT.Category = "ExclRP Entities"
ENT.Spawnable = true

ENT.Ingredients = {}
ENT.Recipes = {}

local stove = ENT;

 --[[ Purpose: Make the code look nicer! Enables me to make a configuartion file where I can set up recipes and ingredients easily! ]]--
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

