local CHARACTER = FindMetaTable("Character");

net.Receive("ERP.Character.Load",function()
	local ply=net.ReadEntity()

	if not IsValid(ply) then return end

	ply.character = net.ReadTable();
	setmetatable(ply.character,CHARACTER);
	CHARACTER.__index = CHARACTER;

	ply.character.Player=LocalPlayer();

	-- Is the menu open? Let's close it.
	if ply == LocalPlayer() and IsValid(ERP.MainMenu) then
		ERP.MainMenu:Remove();
		ERP.MainMenu = nil;
	end

	ES.DebugPrint("Received new character. "..ply:Nick());
end);

net.Receive("ERP.Character.Update",function()
	local ply=net.ReadEntity()

	if not IsValid(ply) or not ply.character then return end

	local updates=net.ReadTable();

	if not updates then return end

	for k,v in pairs(updates)do
		ply.character[k]=v;
	end

	ES.DebugPrint("Received updates about character. Values updated locally."..ply:Nick());
end);
