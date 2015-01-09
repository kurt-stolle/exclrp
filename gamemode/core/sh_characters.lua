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
function ERP:GetAllowedCharacterModels()
	return allowedModels;
end

if SERVER then
	local pmeta = FindMetaTable("Player");
	function pmeta:CreateCharacter(fname,lname,model)
		if not fname or not lname or not model or not table.HasValue(allowedModels,model) then return end
	
		ES.DBQuery("SELECT id FROM es_erp_characters_ WHERE steamid = '"..self:SteamID().."' ;",function(c)
			if #c >= 3 then 
				return;
			end
			ES.DBQuery(Format("INSERT INTO es_erp_characters_ SET firstname = '%s', lastname = '%s', steamid = '%s', model = '%s', cash = 10 , bank = 500", ES.DBEscape(fname), ES.DBEscape(lname), self:SteamID(),ES.DBEscape(model)),function()
				print ("Character created: "..fname.." "..lname);
				self:OpenMainMenu()
			end)
		end)
	end
	concommand.Add("excl_createcharacter",function(p,c,a)
		if p:IsLoaded() or not a[1] or not a[2] or not a[3] or not table.HasValue(allowedModels,a[3]) then return end

		ES.DebugPrint(a[1].." | "..a[2].." | "..a[3]);
		p:CreateCharacter(tostring(a[1]),tostring(a[2]),tostring(a[3]))
	end)
	util.AddNetworkString("ERPSynchCharacter")
	function pmeta:SynchCharacter()
		if not self.character then return end
		
		net.Start("ERPSynchCharacter")
		net.WriteTable(self.character);
		net.Send(self);
	end
	function pmeta:LoadCharacter(id)
		ES.DBQuery("SELECT * FROM es_erp_characters_ WHERE steamid = '"..self:SteamID().."' AND id = "..tonumber(id)..";",function(c)
			if c and c[1] then
				self.character = c[1];
				self.character.inventory = 
				self:SetNWString("name",self.character.firstname.."|"..self.character.lastname);
				self:SynchCharacter()
				self:Spawn();
			end
		end)
	end
	concommand.Add("excl_selectcharacter",function(p,c,a)
		if p:IsLoaded() then return end
		p:LoadCharacter(tonumber(a[1]));
	end)
	function pmeta:SaveCharacter(nosynch)
		if not self:IsLoaded() then return end		
		ES.DBQuery(Format("UPDATE es_erp_characters_ SET cash = '%s', job = '%s', inventory = '%s';",self.character.cash,self:Team() or 0, ERP:EncodeInventory(self.character.inventory) or ""),function() end)
		
		if !nosynch then
			self:SynchCharacter()
		end
	end
	util.AddNetworkString("ERPOpenMainMenu")
	function pmeta:OpenMainMenu()
		ES.DBQuery("SELECT * FROM es_erp_characters_ WHERE steamid = '"..self:SteamID().."';",function(c)
			net.Start("ERPOpenMainMenu");
			net.WriteTable(c or {});
			net.Send(self);
		end)
	end
end

if CLIENT then
	net.Receive("ERPSynchCharacter",function()
		LocalPlayer().character = net.ReadTable();
		if ERP.MainMenu and ERP.MainMenu:IsValid() then
			ERP.MainMenu:Remove();
			ERP.MainMenu = nil;
			gui.EnableScreenClicker(false);
		end
	end);
end