-- sh_characters
local allowedModels = {
"models/player/Group01/Female_01.mdl",
"models/player/Group01/Female_02.mdl",
"models/player/Group01/Female_03.mdl",
"models/player/Group01/Female_06.mdl",
"models/player/Group01/Female_04.mdl",
"models/player/Group01/female_05.mdl",

"models/player/Group01/male_01.mdl",
"models/player/Group01/male_02.mdl",
"models/player/Group01/male_03.mdl",
"models/player/Group01/male_04.mdl",
"models/player/Group01/male_05.mdl",
"models/player/Group01/male_06.mdl",
"models/player/Group01/male_07.mdl",
"models/player/Group01/male_08.mdl",
"models/player/Group01/male_09.mdl",
}
function ERP.GetAllowedCharacterModels()
	return allowedModels;
end

-- Meta table for characters
local CHARACTER=FindMetaTable("Character");

-- Meta functions
AccessorFunc(CHARACTER,"firstname","FirstName",FORCE_STRING);
AccessorFunc(CHARACTER,"lastname","LastName",FORCE_STRING);
AccessorFunc(CHARACTER,"cash","Cash",FORCE_NUMBER);
AccessorFunc(CHARACTER,"bank","Bank",FORCE_NUMBER);
AccessorFunc(CHARACTER,"id","ID",FORCE_NUMBER);
