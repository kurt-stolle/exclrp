function ERP.OpenUI_Help()
  ES.NotifyPopup("Help","ExclRP is currently in BETA\n\nFor more information visit community.casualbananas.com.\n\nThere is currently no documentation for ExclRP, so you will have to figure out how this gamemode works by yourself. Try holding TAB to view several menus, and speak to some NPCs to find out what there is to do around the map.")
end

hook.Add("PlayerBindPress","ERP.UI.Help.BindPress",function( ply, bind, pressed )
	if (string.find( bind, "gm_showhelp" ) or string.find( bind, "gm_showteam" ) or string.find( bind, "gm_showspare1" ) or string.find( bind, "gm_showspare2" )) and pressed then
    ERP.OpenUI_Help()
    return true
  end
end)
