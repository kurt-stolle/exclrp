local nodrawWeps = {"CHudDeathNotice", "CHudHealth", "CHudBattery", "CHudAmmo", "CHudSecondaryAmmo", "CHudDamageIndicator"}
function ERP:HUDShouldDraw(name)
	if table.HasValue(nodrawWeps, name) then
		return false;
	end
	return true;
end

COLOR_BLACK = COLOR_BLACK or Color(0,0,0,255);

local fov = 0;
local thirdperson = true;
local newpos
local tracedata = {}
local ignoreent
local distance = 0;
local camPos = Vector(0, 0, 0)
local camAng = Angle(0, 0, 0)

local bulletsFrom = Vector(ScrW()-80,ScrH()-70,0);
local matBullet = Material("exclrp/bulletHudParti.png");
local bullets= {}
function ERP:CreateHUDBullet()
	table.insert(bullets,{
		gravitySpeed = math.random(2,3),
		predictUp = math.random(100,250),
		predictSide = math.random(50,150),
		spinAdd = math.random(2,20),
		spin = math.random(0,180),
		pos = bulletsFrom,
	});
end
hook.Add("Think","ExclThinkHUDBullets",function()
	for k,v in pairs(bullets)do
			if (bulletsFrom.x - v.predictSide + 5 > v.pos.x ) then
				v.pos = Vector(v.pos.x-v.gravitySpeed,v.pos.y+v.gravitySpeed,0);
				v.spin = ((v.spin + v.spinAdd) % 360);
			else
				v.pos = Vector(v.pos.x-v.gravitySpeed,Lerp(0.05,v.pos.y,bulletsFrom.y-v.predictUp),0);
				v.spin = ((v.spin + v.spinAdd) % 360);
			end
			if v.pos.y > ScrH()+10 then
				v=nil;k=nil;
			end
	end
end);
hook.Add("HUDPaint","ExclDrawHUDBullets",function()
	for k,v in pairs(bullets)do
		surface.SetDrawColor(255,255,255,255);
		surface.SetMaterial(matBullet);
		surface.DrawTexturedRectRotated(v.pos.x,v.pos.y,16,16,v.spin);
	end
end);

local function convertMoneyString()
	local str=",-"
	local count=-1
	local array= string.Explode("",tostring(LocalPlayer().character.cash));
	for i=string.len(tostring(LocalPlayer().character.cash)),1,-1 do
		if count == 2 then
			str = "."..str;
		end
		str=array[i]..str;
		
		count = (count+1)%3;
	end
	
	return str;
end
local function getJobString()
	local str = "Unemployed";
	if LocalPlayer():GetJob() and type(LocalPlayer():GetJob()) == "table" then
		str = LocalPlayer():GetJob().name;
	end
	
	return str;
end

function ERP:HUDPaint()
	hook.Call("PrePaintMainHUD");

	local localplayer = LocalPlayer();
	if (not localplayer:IsLoaded()) or hook.Call("ShouldDrawLocalPlayer()") then
		return;
	end

	surface.SetDrawColor(0,0,0,100);
	surface.SetMaterial(Material("exclrp/gradient.png"));
	surface.DrawTexturedRectRotated(ScrW()/2,40,ScrW(),80,0);
	surface.DrawTexturedRectRotated(ScrW()/2,ScrH()-40,ScrW(),80,180);
	surface.DrawTexturedRectRotated(40,ScrH()/2,ScrH(),80,90);
	surface.DrawTexturedRectRotated(ScrW()-40,ScrH()/2,ScrH(),80,270);
	
	surface.SetDrawColor(255,255,255,255);
	surface.SetMaterial(Material("exclrp/cashbar.png"));
	surface.DrawTexturedRect(10,ScrH()-150,256,64);
	draw.SimpleText(convertMoneyString(),"ES.MainMenu.MainElementInfoBnnsSmall",65,ScrH()-150+32,Color(255,255,255),0,1);
	
	surface.SetDrawColor(255,255,255,255);
	surface.SetMaterial(Material("exclrp/jobbar.png"));
	surface.DrawTexturedRect(30,ScrH()-80,256,64);
	draw.SimpleText(getJobString(),"ES.MainMenu.MainElementInfoBnnsSmall",95,ScrH()-80+32,Color(255,255,255),0,1);
	
	local aw = localplayer:GetActiveWeapon();
	if( IsValid(aw) and aw.Primary and aw.Primary.Ammo and aw.Primary.Ammo != "none" )then
		surface.SetDrawColor(255,255,255,255);
		surface.SetMaterial(Material("exclrp/ammobar.png"));
		surface.DrawTexturedRect(ScrW()-256-30,ScrH()-80,256,64);
		surface.SetFont("DermaDefaultBold");
		draw.SimpleText(aw:Clip1(),"TargetID",ScrW()-95-surface.GetTextSize("/ "..(localplayer:GetAmmoCount(aw.Primary.Ammo) or 0)),ScrH()-80+32,Color(255,255,255),2,1);
		draw.SimpleText("/ "..(localplayer:GetAmmoCount(aw.Primary.Ammo) or 0),"DermaDefaultBold",ScrW()-95,ScrH()-80+36,Color(255,255,255),2,1);
	end
end

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
function ERP:CalcView(p, pos, angles, fov) --Calculates the view, for run-view, menu-view, and death from the ragdoll's eyes.
	local view = {origin = pos, angles = angles, fov = fov};
	if ERP.MainMenu and ERP.MainMenu:IsValid() then
		view.origin = Vector(-2677.004639, -645.997803, 92.479630);
		view.angles = Angle(6.719857, -59.160347, 0.000000);
		view.fov = 90;
	end
	return view
end
local newpos;
local newangles;
hook.Add("CalcView", "exclThirdperson", function(ply, pos , angles ,fov)
	if !newpos then
		newpos = pos;
		newangles = angles;
	end

	if( thirdperson ) and distance > 2 then
		ignoreent = ply
					
		if(ply:IsAiming()) then--Over the shoulder view.
			tracedata.start = pos
			tracedata.endpos = pos - ( angles:Forward() * distance ) + ( angles:Right()* ((distance/90)*35) )
			tracedata.filter = ignoreent
			trace = util.TraceLine(tracedata)  
	        pos = newpos
			newpos = LerpVector( 0.3, pos, trace.HitPos + trace.HitNormal*2 )
			angles = newangles
			newangles = LerpAngle( 0.3, angles, (ply:GetEyeTraceNoCursor().HitPos-newpos):Angle() )

			camPos = pos
			camAng = angles;
			return ERP:CalcView(ply, newpos, angles, fov)
		else
			tracedata.start = pos
			tracedata.endpos = pos - ( angles:Forward() * distance * 2 ) + ( angles:Up()* ((distance/60)*20) )
			tracedata.filter = ignoreent
			
	    	trace = util.TraceLine(tracedata)
	        pos = newpos
			newpos = LerpVector( 0.3, pos, trace.HitPos + trace.HitNormal*2 )

			camPos = pos
			camAng = angles
			return ERP:CalcView(ply, newpos , angles ,fov)

		end
	else
		newpos = ply:EyePos();
	end
	
	return ERP:CalcView(ply, pos , angles ,fov-2+(math.sin(CurTime()*2))*.3)
end)

usermessage.Hook("ESM",function(u)
	if not LocalPlayer():IsLoaded() then return end

	LocalPlayer().character.cash = u:ReadLong() or 0;
end)
usermessage.Hook("ESBM",function(u)
	if not LocalPlayer():IsLoaded() then return end

	LocalPlayer().character.bank = u:ReadLong() or 0;
end)

local doors = {
	"prop_door_rotating",
	"func_door",
	"func_door_rotating"};
function ERP:OnContextMenuOpen()
	local e= LocalPlayer():GetEyeTrace().Entity
	if not IsValid(e) or not LocalPlayer():IsLoaded() or LocalPlayer():GetEyeTrace().HitPos:Distance(LocalPlayer():EyePos()) > 100 then return false end
	
	if table.HasValue(doors,e:GetClass()) and availableProperty[e:EntIndex()] then
		if !ERP.OwnedProperty[availableProperty[e:EntIndex()]] then
			ERP:CreateActionMenu(LocalPlayer():GetEyeTrace().HitPos,{
			{text="Buy property",func=function()
				RunConsoleCommand("excl_buyproperty");
			end}
			})
		elseif ERP.OwnedProperty[availableProperty[e:EntIndex()]].id == LocalPlayer():UniqueID() then
			ERP:CreateActionMenu(LocalPlayer():GetEyeTrace().HitPos,{
			{text="Lock",func=function()
				RunConsoleCommand("excl_lockdoor");
			end},
			{text="Unlock",func=function()
				RunConsoleCommand("excl_unlockdoor");
			end}
			})
		else
		
		end
	end

	return false;
end