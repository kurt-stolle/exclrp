-- BASE HOOKS
function ERP:PlayerInitialSpawn(p)
	player_manager.SetPlayerClass( p, "player_erp_default" )
end
function ERP:PlayerCanHearPlayersVoice( listener, talker )
	return listener:GetPos():Distance( talker:GetPos() ) <= 500
end
function ERP:PlayerSpawn(p)
	player_manager.SetPlayerClass( p, "player_erp_default" )

	if p:IsLoaded() then
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
		p:SetPos( ERP.Config["mainmenu_view_origin"] )

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

-- PLAYER DEATH
function ERP:PlayerDeath(ply)
	if not ply:IsLoaded() then return end

	-- Variables
	local char=ply:GetCharacter()

	-- Add a death timer, so that they can't respawn or log on for x seconds
	if bit.band(ply:GetStatus(),STATUS_ARRESTED) > 0 then
		-- Fair death times
		char:Save("deathTime",char.arrestTime)
		char:Save("arrestTime",0)
	else
		-- Full death time
		char:Save("deathTime",os.time())
	end

	-- If wanted, then notify everyone
	if bit.band(ply:GetStatus(),STATUS_WANTED) > 0 then
		ES.BroadcastChat(ES.Color.Red,"Wanted person "..char:GetFullName().." has died.")
	end

	-- Set all status flags to Dead
	ply:SetStatus(STATUS_DEAD)
end

function ERP:PlayerDeathThink(ply)
	if ply:IsLoaded() and bit.band(ply:GetStatus(),STATUS_DEAD) > 0 then
		local char=ply:GetCharacter()
		if char.deathTime + ERP.Config["death_time"] < os.time() then
			ply:SetStatus(STATUS_NONE)
		end

		return
	end

	ply:Spawn()
end

-- SANDBOX HOOKS
local function canSpawn(gm,ply)
	if ply:IsSuperAdmin() then
		ply:ESChatPrint("You spawned a SA+ only item!")
		return true
	end

	ply:ESSendNotificationPopup("Restricted","The item you tried to spawn is restricted to Super Administrators.\n\nYou may only spawn Props in ExclRP.")
	return false;
end
ERP.PlayerGiveSWEP = canSpawn
ERP.PlayerSpawnNPC = canSpawn
ERP.PlayerSpawnSENT = canSpawn
ERP.PlayerSpawnSWEP = canSpawn
ERP.PlayerSpawnVehicle = canSpawn

function ERP:PhysgunPickup( ply, ent )
	return ent.Getowner and ent:GetOwner() == ply or ply:IsSuperAdmin()
end

-- THE ENERGY SYSTEM
local energyRate = 4;
hook.Add("Think","ERP.ThinkEnergy",function()
	for _,ply in ipairs(player.GetAll())do -- We need to check the energy consumption of ALL PLAYERS
		if not ply:IsLoaded() then continue end

		local energy=ply:GetEnergy();
		if ply:GetVelocity():Length() > ply:GetWalkSpeed()+10 and ply:KeyDown(IN_SPEED) and ply:IsOnGround() then -- Only lose energy while running
			ply:SetEnergy(math.Clamp(energy - (FrameTime()*energyRate*2),0,100))  -- Set the new NWVar to the old NWVar minus 1.
    else
      ply:SetEnergy(math.Clamp(energy + (FrameTime()*energyRate),0,100))
		end

    if energy < 100 then
			if energy >= 20 then
				ply:SprintEnable();
      elseif energy < 1 then
        ply:SprintDisable();
			end
		end
	end
end)
