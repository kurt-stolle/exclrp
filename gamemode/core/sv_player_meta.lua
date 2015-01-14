local PLAYER = FindMetaTable("Player");

function PLAYER:UnLoad()
	-- This function unloads the player
	-- meaning they can select a new character.

	self.character=nil;
	ERP.OpenMainMenu(self);
end