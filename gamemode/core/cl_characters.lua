local CHARACTER = FindMetaTable("Character");

net.Receive("ERP.Character.Load",function()
	local ply=net.ReadEntity()

	if not IsValid(ply) then return end

	ply.character = net.ReadTable();
	ply.character.inventory = ERP.DecodeInventory(ply.character.inventory)

	setmetatable(ply.character,CHARACTER);
	CHARACTER.__index = CHARACTER;

	ply.character.Player=ply;

	-- Is the menu open? Let's close it.
	if ply == LocalPlayer() and IsValid(ERP.MainMenu) then
		ERP.MainMenu:Remove();
		ERP.MainMenu = nil;
	end

	ES.DebugPrint("Received new character. "..ply:Nick());

	hook.Call("ERPCharacterLoaded",ERP,ply:GetCharacter())
end);
net.Receive("ERP.character.UnLoad",function()
	local ply=net.ReadEntity()

	if not IsValid(ply) then return end

	ply.character=nil;
end);
net.Receive("ERP.Character.Update",function()
	local ply=net.ReadEntity()

	if not IsValid(ply) or not ply.character then return end

	local updates=net.ReadTable();

	if not updates then return end

	for k,v in pairs(updates)do
		if k == "inventory" then
			v = ERP.DecodeInventory(v);
		end
		ply.character[k]=v;

		hook.Call("ERPCharacterUpdated",ERP,ply:GetCharacter(),k,v)
	end

	ES.DebugPrint("Received updates about character. Values updated locally."..ply:Nick());
end);
