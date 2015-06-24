function ERP:PlayerInitialSpawn(p)
	-- nothing to do here
end
function ERP:PlayerSpawn(p)
	if p:IsLoaded() then
		player_manager.SetPlayerClass( p, "player_erp_default" )

		p:UnSpectate()
		p:SetupHands()

		player_manager.OnPlayerSpawn( p )
		player_manager.RunClass( p, "Spawn" )
		player_manager.RunClass( p, "Loadout" )
		player_manager.RunClass( p, "SetModel" )
	else
		p:SetTeam( TEAM_SPECTATOR )
		p:StripWeapons()
		p:Spectate( OBS_MODE_FIXED )
		p:SpectateEntity(NULL)
		p:SetPos( ERP.Config.MainMenu.ViewOrigin )

		ERP.OpenMainMenu(p)
	end
end
function ERP:CanPlayerSuicide()
	return false
end
function ERP:ScalePlayerDamage( p, hitgroup, dmginfo )
	if ( hitgroup == HITGROUP_HEAD ) then
		dmginfo:ScaleDamage( 3 )
	elseif ( hitgroup == HITGROUP_LEFTARM ||
		hitgroup == HITGROUP_RIGHTARM ||
		hitgroup == HITGROUP_LEFTLEG ||
		hitgroup == HITGROUP_RIGHTLEG ||
		hitgroup == HITGROUP_GEAR ) then

		dmginfo:ScaleDamage( 0.5 )
	end
end
function ERP:PlayerSpray()
	return true;
end
function ERP:GetFallDamage( ply, speed )
	return (speed/10);
end
function ERP:ShowHelp(p)
	return false;
end
function ERP:ShowTeam(p)
	return false;
end
function ERP:ShowSpare1(p)
	umsg.Start("EOINVM",p); umsg.End();
	return false;
end
function ERP:ShowSpare2(p)
	umsg.Start("EOIERP",p); umsg.End();
	return false;
end
function ERP:PlayerSwitchFlashlight()
    return false;
end
