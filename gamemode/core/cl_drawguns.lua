-- drawguns
-- draws weapons on the players

local clientModels = {}
local function CheckWeaponTable(class)
	if clientModels[class] then 
		return clientModels[class] 
	end
	local wclass = weapons.Get(class);
	if not wclass or not wclass.WorldModel then return false end;
	timer.Simple(0,function()
		local wclass = weapons.Get(class);
		if not wclass or not wclass.WorldModel then return false end;

		clientModels[class] = ClientsideModel(wclass.WorldModel,RENDERGROUP_OPAQUE);
		clientModels[class]:SetNoDraw(true);
	end);
	return false;
end

hook.Add("PostPlayerDraw","JBDrawWeaponsOnPlayer",function(p)
	local weps = p:GetWeapons();
		
	for k, v in pairs(weps)do		
		local mdl = CheckWeaponTable(v:GetClass());
		
		if IsValid(mdl) and p:GetActiveWeapon() and p:GetActiveWeapon():IsValid() and p:GetActiveWeapon():GetClass() ~= v:GetClass() then
			if string.find(mdl:GetModel(),"pist") then
				
				local boneindex = p:LookupBone("ValveBiped.Bip01_R_Thigh")
				if boneindex then
					local pos, ang = p:GetBonePosition(boneindex)

					ang:RotateAroundAxis(ang:Forward(),90)
					mdl:SetRenderOrigin(pos+(ang:Right()*4.5)+(ang:Up()*-1.5));
					mdl:SetRenderAngles(ang);
					mdl:DrawModel();
				end
			elseif string.find(mdl:GetModel(),"shot") or string.find(mdl:GetModel(),"rif") or string.find(mdl:GetModel(),"smg") or string.find(mdl:GetModel(),"snip") then
				local boneindex = p:LookupBone("ValveBiped.Bip01_Spine2")
				if boneindex then
					local pos, ang = p:GetBonePosition(boneindex)

					ang:RotateAroundAxis(ang:Forward(),0)
					mdl:SetRenderOrigin(pos+(ang:Right()*4)+(ang:Forward()*-5));
					ang:RotateAroundAxis(ang:Right(),-15)
					mdl:SetRenderAngles(ang);
					mdl:DrawModel();
				end
			elseif string.find(mdl:GetModel(),"rocket_launcher") then
				local boneindex = p:LookupBone("ValveBiped.Bip01_Spine2")
				if boneindex then
					local pos, ang = p:GetBonePosition(boneindex)

					ang:RotateAroundAxis(ang:Forward(),0)
					mdl:SetRenderOrigin(pos+(ang:Right()*3)+(ang:Forward()*17)+(ang:Up()*10));
					ang:RotateAroundAxis(ang:Right(),180+15)
					mdl:SetRenderAngles(ang);
					mdl:DrawModel();
				end
			/*elseif string.find(mdl:GetModel(),"baton") then
				local boneindex = p:LookupBone("ValveBiped.Bip01_L_Thigh")
				if boneindex then
					local pos, ang = p:GetBonePosition(boneindex)

					ang:RotateAroundAxis(ang:Forward(),90)
					ang:RotateAroundAxis(ang:Right(),-56)
					mdl:SetRenderOrigin(pos+(ang:Right()*-4.2)+(ang:Up()*2));
					mdl:SetRenderAngles(ang);
					mdl:DrawModel();
				end*/
			end
		end	
	end
end)
