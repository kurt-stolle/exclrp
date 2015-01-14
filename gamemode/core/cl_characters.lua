local CHARACTER = FindMetaTable("Character");

net.Receive("ERP.Character.Load",function()

	LocalPlayer().character = net.ReadTable();
	setmetatable(LocalPlayer().character,CHARACTER);
	CHARACTER.__index = CHARACTER;

	LocalPlayer().character.Player=LocalPlayer();
	
	-- Is the menu open? Let's close it.
	if IsValid(ERP.MainMenu) then
		ERP.MainMenu:Remove();
		ERP.MainMenu = nil;
	end

	ES.DebugPrint("Received new character. Setting new character to active.");
end);

net.Receive("ERP.Character.Update",function()
	local updates=net.ReadTable();

	if not updates then return end

	for k,v in pairs(updates)do
		LocalPlayer().character[k]=v;
	end

	ES.DebugPrint("Received updates about active characters. Values updated locally.");
end);
