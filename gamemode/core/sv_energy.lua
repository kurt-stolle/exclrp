-- removed all those comments that used to be up here.

hook.Add("PlayerSpawn", "ERP.EnergySpawn", function(ply)
	if ply.character then -- Same as IsLoaded, I prefer this nowadays.
		ply:ESSetNetworkedVariable("energy",100); -- We spawn with 100% energy
	end
end)

local loseEnergyRate;
timer.Create("ERP.EnergyTick", 1, 0 , function() 
	for _,ply in ipairs(player.GetAll())do -- We need to check the energy consumption of ALL PLAYERS
		if ply:GetVelocity():Length() > ply:GetWalkSpeed() and ply:KeyDown(IN_SPEED) then -- Only lose energy while running



			ply:ESSetNetworkedVariable("energy", math.Clamp(ply:ESGetNetworkedVariable("energy",100) - 1,0,100))  -- Set the new NWVar to the old NWVar minus 1.

			print("New energy value: "..tostring(ply:ESGetNetworkedVariable("energy",100)));
		end
	end
end)		 	