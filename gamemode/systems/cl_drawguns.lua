local clientModels={}

hook.Add("PrePlayerDraw","exclrp.draw.weapons",function(p)
	for k, v in ipairs(p:GetWeapons())do
		if v.WorldModel and v.WorldModel ~= "" and not clientModels[v:GetClass()] and v:GetClass() ~= "gmod_tool" and v:GetClass() ~= "gmod_camera" then

			local cMdl = ClientsideModel(v.WorldModel,RENDERGROUP_OPAQUE)

			if IsValid(cMdl) then
				cMdl:SetNoDraw(true)
				clientModels[v:GetClass()] = cMdl;
			else
				print("ERROR!",weapons.GetStored(v:GetClass()).WorldModel,v:GetClass())
			end
		end
	end
end)

hook.Add("PostPlayerDraw","exclrp.draw.weapons",function(p)
	local blend=render.GetBlend()
	render.SetBlend(1)

	local ent,mdl;
	for k, v in ipairs(p:GetWeapons())do
		if not clientModels or not v.GetClass then continue end

		ent = clientModels[v:GetClass()]

		if IsValid(ent) and p:GetActiveWeapon() and p:GetActiveWeapon():IsValid() and p:GetActiveWeapon():GetClass() ~= v:GetClass() then
			mdl=string.lower(ent:GetModel())

			ent:SetPos(p:GetPos())
			ent:SetAngles(p:GetAngles())

			if string.find(mdl,"pist",1,true) or string.find(mdl,"357",1,true) then
				local boneindex = p:LookupBone("ValveBiped.Bip01_R_Thigh")
				if boneindex then
					local pos, ang = p:GetBonePosition(boneindex)

					ang:RotateAroundAxis(ang:Forward(),90)
					ent:SetRenderOrigin(pos+(ang:Right()*4.5)+(ang:Up()*-3));
					ent:SetRenderAngles(ang)
					ent:DrawModel();
				end
			elseif string.find(mdl,"shotgun",1,true) then -- HL2
				local boneindex = p:LookupBone("ValveBiped.Bip01_Spine2")
				if boneindex then
					local pos, ang = p:GetBonePosition(boneindex)

					ang:RotateAroundAxis(ang:Forward(),0)
					ent:SetRenderOrigin(pos+(ang:Right()*4)+(ang:Forward()*3)+(ang:Up()*0));
					ang:RotateAroundAxis(ang:Right(),180+-30)
					ent:SetRenderAngles(ang);
					ent:DrawModel();
				end
				elseif string.find(mdl,"smg1",1,true) then -- HL2
					local boneindex = p:LookupBone("ValveBiped.Bip01_Spine2")
					if boneindex then
						local pos, ang = p:GetBonePosition(boneindex)

						ang:RotateAroundAxis(ang:Forward(),0)
						ent:SetRenderOrigin(pos+(ang:Right()*4)+(ang:Forward()*5)+(ang:Up()*-3));
						ang:RotateAroundAxis(ang:Right(),-30)
						ent:SetRenderAngles(ang);
						ent:DrawModel();
					end
			elseif string.find(mdl,"snip",1,true) or string.find(mdl,"rif",1,true) or string.find(mdl,"shot",1,true) or string.find(mdl,"smg",1,true) then -- CS:S
				local boneindex = p:LookupBone("ValveBiped.Bip01_Spine2")
				if boneindex then
					local pos, ang = p:GetBonePosition(boneindex)

					ang:RotateAroundAxis(ang:Forward(),0)
					ent:SetRenderOrigin(pos+(ang:Right()*4)+(ang:Forward()*5)+(ang:Up()*-5));
					ang:RotateAroundAxis(ang:Right(),25)
					ent:SetRenderAngles(ang);
					ent:DrawModel();
				end
			elseif string.find(mdl,"baton") then
				local boneindex = p:LookupBone("ValveBiped.Bip01_L_Thigh")
				if boneindex then
					local pos, ang = p:GetBonePosition(boneindex)

					ang:RotateAroundAxis(ang:Forward(),90)
					ang:RotateAroundAxis(ang:Right(),150)
					ent:SetRenderOrigin(pos+(ang:Right()*-4)+(ang:Up()*-1)+(ang:Forward()*-5));
					ent:SetRenderAngles(ang);
					ent:DrawModel();
				end
			end
		end
	end

	render.SetBlend(blend)
end)
