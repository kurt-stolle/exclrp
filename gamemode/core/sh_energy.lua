ES.DefineNetworkedVariable("energy","UInt",8);

-- Command to check energy (Testing purposes only)
if CLIENT then 
	concommand.Add("testenergy", function(p)
		local energy = p:ESGetNetworkedVariable("energy")
		print( energy )
	end)
end