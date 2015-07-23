-- HUD
local nodrawWeps = {"CHudDeathNotice", "CHudHealth", "CHudBattery", "CHudAmmo", "CHudSecondaryAmmo", "CHudDamageIndicator"}
function ERP:HUDShouldDraw(name)
	if table.HasValue(nodrawWeps, name) then
		return false;
	end
	return true;
end

surface.CreateFont ("ERP.HudNormal", {
	size = 18,
	weight = 400,
	antialias = true,
	font = "Roboto"
})
surface.CreateFont ("ERP.HudNormal.Shadow", {
	size = 18,
	weight = 400,
	antialias = true,
	font = "Roboto",
	blursize=2
})

surface.CreateFont("ERP.HudWasted", {
	size=120,
	weight=800,
	antialias=true,
	font="Roboto"
})
surface.CreateFont("ERP.HudWasted.Shadow", {
	size=120,
	weight=800,
	antialias=true,
	font="Roboto",
	blursize=4
})

local ply;
local function convertMoneyString()
	local str=""
	local count=-1
	local cash=tostring(ply:GetCharacter():GetCash())
	local array= string.Explode("",cash);
	for i=string.len(cash),1,-1 do
		if count == 2 then
			str = ","..str;
		end
		str=array[i]..str;

		count = (count+1)%3;
	end

	return "$"..str;
end

local smoothHealth=0;
local smoothEnergy=0;

local animationSpeed=3;

local color_background=ES.Color["#1E1E1E"]

local color_health=ES.Color.Red;
local color_energy=ES.Color.Amber;

local box_wide=200;
local box_tall=32;

local mat_money=Material( "icon16/money.png" );
local mat_name=Material( "icon16/user.png" );
local mat_health=Material( "icon16/heart.png" );
local mat_energy=Material( "icon16/lightning.png" );

local box_margin=12; -- px between boxes
local icon_margin=(box_tall/2)-8;
local function drawHUDBox(x,y,icon,text,color,inner_mul)
	render.PushFilterMag(TEXFILTER.ANISOTROPIC);
	render.PushFilterMin(TEXFILTER.ANISOTROPIC);

	draw.RoundedBox(2,x,y,box_wide,box_tall,ES.Color.Black);
	draw.RoundedBox(2,x+1,y+1,box_wide-2,box_tall-2,color_background);

	if color and (not inner_mul or inner_mul > 0) then
		draw.RoundedBox(2,x+1,y+box_tall-3,(box_wide-2) * (inner_mul or 1),2,color);
	end

	render.PopFilterMag();
	render.PopFilterMin();

	if icon then
		surface.SetDrawColor(ES.Color.White);
		surface.SetMaterial(icon);
		surface.DrawTexturedRect(x+icon_margin,y+icon_margin,16,16);
	end

	if text then
		draw.SimpleText(text,"ERP.HudNormal.Shadow",x+box_tall,y+box_tall/2,ES.Color.Black,0,1);
		draw.SimpleText(text,"ERP.HudNormal",x+box_tall + 1,y+box_tall/2 + 1,ES.Color.Black,0,1);
		draw.SimpleText(text,"ERP.HudNormal",x+box_tall,y+box_tall/2,ES.Color.White,0,1);
	end

end

local screen_width,screen_height,mat;

local context_tall = (box_margin*3 + box_tall*2);
local context_wide = (box_margin*3 + box_wide*2);

local shift_hidden=context_tall;

local w,h,x,y;

local mat,matTranslation,matAngle,matScale = nil,Vector(0,0,0),Angle(0,0,0),Vector(0,0,0);

local deathScale= 0

function ERP:HUDPaint()
	ply=LocalPlayer()

	w,h=ScrW(),ScrH()

	if not ply:IsLoaded() then return end

	--hook.Call("PrePaintMainHUD");

	if not ply:Alive() then
		-- DEATH VIEW

		deathScale=Lerp(FrameTime()*5,deathScale,1)

		x,y=w/2,h/2
		x,y=(deathScale-1)*-x,(deathScale-1)*-y

		mat=Matrix()
		mat:SetAngles( matAngle )
		matTranslation.x = x
		matTranslation.y = y
		mat:SetTranslation( matTranslation )
		matScale.x = deathScale
		matScale.y = deathScale
		mat:Scale( matScale )

		x,y=w/2,h/2

		cam.PushModelMatrix( mat )

		for i=0,2,1 do
			draw.SimpleText("WASTED","ERP.HudWasted.Shadow",x,y,ES.Color.Black,1,1)
		end
		draw.SimpleText("WASTED","ERP.HudWasted",x+3,y+3,ES.Color.Black,1,1)
		draw.SimpleText("WASTED","ERP.HudWasted",x,y,ES.Color.Red,1,1)

		cam.PopModelMatrix( mat )

		-- SHIFT MAIN HUD
		shift_hidden=Lerp(FrameTime()*animationSpeed,shift_hidden,context_tall);
	else
		-- SHIFT MAIN HUD
		deathScale=0
		shift_hidden=Lerp(FrameTime()*animationSpeed,shift_hidden,0);
	end

	-- SAVE SOME FRAMES
	if shift_hidden >= context_tall-1 then return end

	-- SAVE THESE
	screen_width	= ScrW();
	screen_height	= ScrH();

	mat = Matrix();
  mat:SetAngles( matAngle )
	matTranslation.x = 0
	matTranslation.y = screen_height - context_tall + shift_hidden
	mat:SetTranslation( matTranslation )
	matScale.x = 1
	matScale.y = 1
	mat:Scale( matScale )

	cam.PushModelMatrix( mat )

	-- WALLET
	drawHUDBox(box_margin*2+box_wide,box_margin,mat_money,convertMoneyString());

	-- CHARACTER NAME
	drawHUDBox(box_margin*2+box_wide,box_margin*2+box_tall,mat_name,ply.character:GetFullName());

	-- HEALTH
	smoothHealth = Lerp(FrameTime() * animationSpeed, smoothHealth, ply:Health());
	drawHUDBox(box_margin,box_margin,mat_health,math.Round(smoothHealth).."% Health",color_health,smoothHealth/100);

	-- ENERGY
	smoothEnergy = Lerp(FrameTime() * animationSpeed,smoothEnergy,math.ceil( ply:GetEnergy() ));
	drawHUDBox(box_margin,box_margin*2+box_tall,mat_energy,math.Round(smoothEnergy).."% Energy",color_energy,smoothEnergy/100);

	-- RESET RENDER POSITION;
	cam.PopModelMatrix();
end


-- THIRDPERSON
local fov = 0;
local thirdperson = true;
local newpos
local tracedata = {
	mins=Vector(-10,-10,-10),
	maxs=Vector(10,10,10)
}
local ignoreent
local distance = 60;
local camPos = Vector(0, 0, 0)
local camAng = Angle(0, 0, 0)
hook.Add("ShouldDrawLocalPlayer","ThirdPersonDrawLocalPlayer", function()
	if( thirdperson ) and distance > 2 then
		return true
	end

	return false
end)
hook.Add("PlayerBindPress","ThirdpersonScroll",function(ply, bind, pressed)
	if not (ply and ply:IsValid() and ply:KeyDown(IN_ATTACK) and (ply and ply:IsValid() and ply:GetActiveWeapon() and ply:GetActiveWeapon():IsValid() and ply:GetActiveWeapon().GetClass and ply:GetActiveWeapon():GetClass() == "weapon_physgun")) then
		if string.find(bind, "invnext") then
			distance = distance + 2;
			if distance > 90 then
				distance = 90;
			end
			return true;
		elseif string.find(bind, "invprev") then
			distance = math.abs(distance - 2);
			return true;
		end
	end
end)


local newpos;
local newangles;
function ERP:CalcView(ply, pos, angles, fov) --Calculates the view, for run-view, menu-view, and death from the ragdoll's eyes.

		if IsValid(ERP.MainMenu) then
			local view = {origin = pos, angles = angles, fov = fov};

			view.origin = ERP.Config["mainmenu_view_origin"];
			view.angles = ERP.Config["mainmenu_view_angles"];
			view.fov = 90;

			return view
		end


	if not newpos then
		newpos = pos;
		newangles = angles;
	end

	if( thirdperson ) and distance > 2 then
		ignoreent = ply

		if(ply:IsAiming()) then--Over the shoulder view.
			tracedata.start = pos
			tracedata.endpos = pos - ( angles:Forward() * distance ) + ( angles:Right()* ((distance/90)*35) )
			tracedata.filter = ignoreent
			trace = util.TraceHull(tracedata)
	        pos = newpos
			newpos = LerpVector(  15 * FrameTime(), pos, trace.HitPos + trace.HitNormal*2 )
			--[[angles = newangles
			newangles = LerpAngle( 15 * FrameTime(), angles, (ply:GetEyeTraceNoCursor().HitPos-newpos):Angle() )]]

			camPos = pos
			camAng = angles;

			pos=newpos;
		else
			tracedata.start = pos
			tracedata.endpos = pos - ( angles:Forward() * distance * 2 ) + ( angles:Up()* ((distance/60)*20) )
			tracedata.filter = ignoreent

	    	trace = util.TraceHull(tracedata)
	        pos = newpos
			newpos = LerpVector( 15 * FrameTime(), pos, trace.HitPos + trace.HitNormal*2 )

			camPos = pos
			camAng = angles


			pos=newpos;
		end
	else
		newpos = ply:EyePos();
	end

	if ply:GetEnergy() < 80 then
		fov=fov-2+(math.sin(CurTime()*2))*.6;
	end

	return {origin = pos, angles = angles, fov = fov}
end

function ERP:PrePlayerDraw(p)
	if p == LocalPlayer() and distance < 40 then
		render.SetBlend(distance/40)
	end
end

function ERP:PostPlayerDraw(p)
	if p == LocalPlayer() and distance < 40 then
		render.SetBlend(1)
	end
end

-- OOC
net.Receive("ERP.Chat.ooc",function()
	local ply=net.ReadEntity()
	local msg=string.Trim(net.ReadString())
	local looc=net.ReadBool()

	if not IsValid(ply) or not ply:IsLoaded() or not msg then return end

	local tab={ES.Color.White}

	local char=ply:GetCharacter()

	table.insert(tab,ES.Color.Highlight)
	table.insert(tab,ply:Nick())
	table.insert(tab,ES.Color.White)
	table.insert(tab," in ")
	table.insert(tab,ES.Color.Highlight)
	table.insert(tab,looc and "LOOC" or "OOC")
	table.insert(tab,ES.Color.White)
	table.insert(tab,": ")
	table.insert(tab,msg)

	chat.AddText(unpack(tab))
end)

net.Receive("ERP.Chat.say",function()
	local ply=net.ReadEntity()
	local msg=string.Trim(net.ReadString())

	if not IsValid(ply) or not ply:IsLoaded() or not msg then return end

	local tab={}

	table.insert(tab,team.GetColor(ply:Team()))
	table.insert(tab,ply:GetCharacter():GetFullName())
	table.insert(tab,ES.Color.White)
	table.insert(tab," said: \"")

	local len=string.len(msg)
	local char=string.sub(msg,1,1)

	msg=string.upper(char)..string.sub(msg,2,len)
	table.insert(tab,msg)

	char=string.sub(msg,len,len)
	table.insert(tab,char ~= "." and char ~= "!" and char ~= "?" and ".\"" or "\"")

	chat.AddText(unpack(tab))
end)

-- SPAWNMENU
hook.Add("PostReloadToolsMenu","ERP.OverrideSpawnMenu",function()
	if IsValid(g_SpawnMenu) then
		--g_SpawnMenu.CreateMenu:Remove()
	end
end)

-- SCREEN EFFECTS
local tab = {}
tab[ "$pp_colour_addr" ] = 0
tab[ "$pp_colour_addg" ] = 0
tab[ "$pp_colour_addb" ] = 0
tab[ "$pp_colour_brightness" ] = 0
tab[ "$pp_colour_contrast" ] = 1
tab[ "$pp_colour_colour" ] = 0.1
tab[ "$pp_colour_mulr" ] = 0
tab[ "$pp_colour_mulg" ] = 0
tab[ "$pp_colour_mulb" ] = 0
function ERP:RenderScreenspaceEffects()
	if not LocalPlayer():Alive() then
		DrawColorModify( tab )
	end
end

-- PRE PLAYER DRAW
local bonesHead={
	"ValveBiped.Bip01_Neck1",
	"ValveBiped.Bip01_Head1",
}
local bonesClothing={
	"ValveBiped.Bip01_Pelvis",
	"ValveBiped.Bip01_Spine",
	"ValveBiped.Bip01_Spine1",
	"ValveBiped.Bip01_Spine2",
	"ValveBiped.Bip01_Spine4",
	"ValveBiped.Bip01_R_Clavicle",
	"ValveBiped.Bip01_R_UpperArm",
	"ValveBiped.Bip01_R_Forearm",
	"ValveBiped.Bip01_L_Clavicle",
	"ValveBiped.Bip01_L_UpperArm",
	"ValveBiped.Bip01_L_Forearm",
	"ValveBiped.Bip01_R_Clavicle",
	"ValveBiped.Bip01_R_Thigh",
	"ValveBiped.Bip01_R_Calf",
	"ValveBiped.Bip01_R_Foot",
	"ValveBiped.Bip01_R_Toe0",
	"ValveBiped.Bip01_L_Thigh",
	"ValveBiped.Bip01_L_Calf",
	"ValveBiped.Bip01_L_Foot",
	"ValveBiped.Bip01_L_Toe0"
}
local bonesHands={
	"ValveBiped.Bip01_L_Hand",
	"ValveBiped.Bip01_R_Hand",
}

local vecShrink=Vector(.1,.1,.1)
local vecNormal=Vector(1,1,1)
function ERP:PrePlayerDraw(ply)
	if not ply:IsLoaded() then return end

	local clotModel = ply:GetCharacter():GetClothing()
	local charModel = ply:GetCharacter():GetModel()
	local ent;

	-- The player itself
	ent=ply._erp_modelEnt;
	if IsValid(ent) then
		if ent:GetModel() ~= charModel then
			ent:SetModel(charModel)
		end
		ent:SetPos(ply:GetPos())
	else
		ent=ClientsideModel(charModel,RENDERGROUP_BOTH)
		ent:AddEffects(EF_BONEMERGE)
		ent:SetParent(ply)

		ply._erp_modelEnt=ent;
	end

	for k,v in ipairs(bonesClothing)do
		local boneID=ent:LookupBone(v)

		if not boneID then continue end

		ent:ManipulateBoneScale( boneID, vecShrink )
	end

	for k,v in ipairs(bonesHands)do
		local boneID=ent:LookupBone(v)

		if not boneID then continue end

		ent:ManipulateBoneScale( boneID, clothes.hasGloves and vecShrink or vecNormal )
	end

	-- The clothing
	ent=ply._erp_clothingEnt;
	if IsValid(ent) then
		if ent:GetModel() ~= clotModel then
			ent:SetModel(clotModel)
		end
		ent:SetPos(ply:GetPos())
	else
		ent=ClientsideModel(clotModel,RENDERGROUP_BOTH)
		ent:AddEffects(EF_BONEMERGE)
		ent:SetParent(ply)

		ply._erp_clothingEnt=ent;
	end

	for k,v in ipairs(bonesHands)do
		local boneID=ent:LookupBone(v)

		if not boneID then continue end

		ent:ManipulateBoneScale( boneID, clothes.hasGloves and vecNormal or vecShrink )
	end

	for k,v in ipairs(bonesHead)do
		local boneID=ent:LookupBone(v)

		if not boneID then continue end

		ent:ManipulateBoneScale( boneID, vecShrink )
	end
end
