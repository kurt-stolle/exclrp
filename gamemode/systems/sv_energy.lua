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
