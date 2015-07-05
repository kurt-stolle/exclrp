function ERP:PlayerInitialSpawn(p)
	-- nothing to do here
end
function ERP:PlayerCanHearPlayersVoice( listener, talker )
	return listener:GetPos():Distance( talker:GetPos() ) <= 500
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
	elseif ( hitgroup == HITGROUP_LEFTARM or hitgroup == HITGROUP_RIGHTARM or	hitgroup == HITGROUP_LEFTLEG or	hitgroup == HITGROUP_RIGHTLEG or hitgroup == HITGROUP_GEAR ) then
		dmginfo:ScaleDamage( 0.5 )
	end
end
function ERP:PlayerSpray()
	return false;
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

util.AddNetworkString("ERP.Chat.ooc")
util.AddNetworkString("ERP.Chat.say")
function ERP:PlayerSay(ply, text, team)
	if not ply:IsLoaded() then return "" end

	if string.sub(text,1,1) == ">" or team then
		net.Start("ERP.Chat.ooc")
		net.WriteEntity(ply)
		net.WriteString(string.sub(text,2,#text))
		net.WriteBool(false)
		net.Broadcast()

		return ""
	elseif string.sub(text,1,1) == "<" then
		net.Start("ERP.Chat.ooc")
		net.WriteEntity(ply)
		net.WriteString(string.sub(text,2,#text))
		net.WriteBool(true)

		local in_range = {ply}
		for k,v in ipairs(player.GetAll())do
			if v == ply or v:GetPos():Distance(ply:GetPos()) > 800 then continue end

			table.insert(in_range,v)
		end
		net.Send(in_range)

		return ""
	end

	local in_range = {ply}
	for k,v in ipairs(player.GetAll())do
		if v == ply or v:GetPos():Distance(ply:GetPos()) > 800 then continue end

		table.insert(in_range,v)
	end
	net.Start("ERP.Chat.say")
	net.WriteEntity(ply)
	net.WriteString(text)
	net.Send(in_range)

	return ""
end

-- Sandbox hooks
local function canSpawn(gm,ply)
	if ply:IsSuperAdmin() then
		return true
	end

	ply:ESSendNotificationPopup("Restricted","The item you tried to spawn is restricted to Super Administrators.\n\nYou may only spawn Props in ExclRP.")
	return false;
end
ERP.PlayerSpawnNPC = canSpawn
ERP.PlayerSpawnSENT = canSpawn
ERP.PlayerSpawnSWEP = canSpawn
ERP.PlayerSpawnVehicle = canSpawn

function ERP:PhysgunPickup( ply, ent )
	return ent.Getowner and ent:GetOwner() == ply or ply:IsSuperAdmin()
end
