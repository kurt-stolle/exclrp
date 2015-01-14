-- removed all those comments that used to be up here.

hook.Add("PlayerSpawn", "ERP.EnergySpawn", function(ply)
	if ply.character then -- Same as IsLoaded, I prefer this nowadays.
		ply:ESSetNetworkedVariable("energy",100); -- We spawn with 100% energy
	end
end)

local energyRate = 4;
hook.Add("Think","ERP.ThinkEnergy",function()
	for _,ply in ipairs(player.GetAll())do -- We need to check the energy consumption of ALL PLAYERS
		if not ply.character then return end

		local energy=ply:ESGetNetworkedVariable("energy",100);
		if ply:GetVelocity():Length() > ply:GetWalkSpeed() and ply:KeyDown(IN_SPEED) then -- Only lose energy while running
			if energy > 0 then
				ply:ESSetNetworkedVariable("energy", math.Clamp(energy - (FrameTime()*energyRate*2),0,100))  -- Set the new NWVar to the old NWVar minus 1.
			else
				ply:SprintDisable();
			end
		elseif energy < 100 then
			ply:ESSetNetworkedVariable("energy", math.Clamp(energy + (FrameTime()*energyRate),0,100))
			if energy >= 20 then
				ply:SprintEnable();
			end
		end
	end
end)		 	