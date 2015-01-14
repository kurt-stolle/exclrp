--[[ I used InitialEnergySpawn and EnergySpawn, incase we wanted death penalties however this won't be happening so I just commented out the code.

function InitialEnergySpawn(p)
	if p:IsLoaded() then
		p:ESSetNetworkedVariable("energy", 100)
	end
end
hook.Add("PlayerInitialSpawn", "InitialEnergySpawn", function(p))

]]--


--[[ Not sure if the "p:IsLoaded()" in necessary however I though I'd use it anyway. ]]--
function EnerySpawn(p)
	if p:IsLoaded() then
		p:ESSetNetworkedVariable("energy", 100)
		p.IsLosingEnergy = true
	end
end
hook.Add("PlayerSpawn", "ERP.EnergySpawn", function(p))


function EnergyTick()
	timer.Create("ERP.LoseEnergy", 1 , 0 , function() 
		if p.IsLosingEnergy then
			local energy = p:ESGetNetworkedVariable("energy")
			p:ESSetNetworkedVariable("energy", energy - 1) 
		end 
	end)		 	
end