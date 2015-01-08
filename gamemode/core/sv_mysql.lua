-- sv_mysql
hook.Add("ESDBDefineTables","ERPDefineDTTbls",function()
	ES.DBDefineTable("erp_characters_",false,"steamid text(20), firstname text(20), lastname text(20), playtime int(25), job text(20), cash int(20), bank int(20), model text(100), jobbans text(6), stats varchar(255), inventory varchar(255)")
	ES.DBDefineTable("erp_property_"..ES.DBEscape(game.GetMap()),false,"name text(20), description text(255), factionRestriction text(10), doors varchar(255)");
end)
