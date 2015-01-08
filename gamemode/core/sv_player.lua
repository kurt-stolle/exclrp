

function ERP:PlayerSpawn(p)
	if p:IsLoaded() then
		p:UnSpectate();
		p:SetModel(p.character.model);
		p:AddEffects(EF_NOSHADOW)	
		if p:GetJob() then
			local col = p:GetJob().color;
			col = Vector(col.a/255,col.g/255,col.b/255);
			p:SetPlayerColor(col);
			p:SetWeaponColor(col);
		else
			local col = Vector(180/255,180/255,180/255);
			p:SetPlayerColor(col);
			col = Vector(0/255,180/255,255/255);
			p:SetWeaponColor(col);
		end
		
		p:Give("weapon_physgun");
		p:Give("gmod_tool");
		
		p:SynchProperty()
		
		ERP:SetPlayerSpeed( p, 150, 270 )
	else
		p:OpenMainMenu()
	end
end
hook.Add( "PlayerDeath", "exclHandleClothingRagdolls", function(pVictim,i,pAttack)

	if(IsValid(pVictim.ModelEntity)) then
		pVictim.ModelEntity:SetParent( pVictim:GetRagdollEntity() )
		if(IsValid(pVictim.ClothesEntity)) then
		pVictim.ClothesEntity:SetParent( pVictim:GetRagdollEntity() )
	end
	end
	
end )
function ERP:CanPlayerSuicide()
	return false
end
function ERP:ScalePlayerDamage( p, hitgroup, dmginfo )
	if ( hitgroup == HITGROUP_HEAD ) then 
		dmginfo:ScaleDamage( 5 )
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
