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
	shadow = true,
	font = "Roboto"})


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

local smoothHealth=0;
local smoothEnergy=0;

local animationSpeed=3;

local color_background=ES.Color["#1E1E1E"]

local color_health=ES.Color.Red;
local color_energy=ES.Color.Amber;

local box_wide=220;
local box_tall=26;

local mat_money=Material( "icon16/money.png" );
local mat_name=Material( "icon16/user_suit.png" );

local box_margin=16; -- 16px between boxes
local icon_margin=(box_tall/2)-8;
local function drawHUDBox(x,y,icon,text)
	draw.RoundedBox(2,x-1,y-1,box_wide+2,box_tall+3,ES.Color.Black);
	draw.RoundedBox(2,x,y,box_wide,box_tall,color_background);

	if icon then
		surface.SetDrawColor(ES.Color.White);
		surface.SetMaterial(icon);
		surface.DrawTexturedRect(x+icon_margin,y+icon_margin,16,16);
	end

	if text then
		draw.SimpleText(text,"ERP.HudNormal",x+(icon_margin*2)+16,y+box_tall/2,ES.Color.White,0,1);
	end
end

local screen_width,screen_height,mat;

local context_tall = (box_margin*3 + box_tall*2);
local context_wide = (box_margin*3 + box_wide*2);

function ERP:HUDPaint()
	hook.Call("PrePaintMainHUD");

	local localplayer = LocalPlayer();
	if (not localplayer:IsLoaded()) or hook.Call("ShouldDrawLocalPlayer()") then
		return;
	end

	-- SAVE THESE
	screen_width	= ScrW();
	screen_height	= ScrH();

	-- ENABLE AA
	render.PushFilterMag(TEXFILTER.ANISOTROPIC);
	render.PushFilterMin(TEXFILTER.ANISOTROPIC);

	-- SET THE POSITION OF THE HUD
	mat = Matrix();
	mat:Translate( Vector( 0, screen_height - context_tall) );

	cam.PushModelMatrix( mat )

	-- WALLET
	drawHUDBox(box_margin*2+box_wide,box_margin,mat_money,convertMoneyString());

	-- CHARACTER NAME
	drawHUDBox(box_margin*2+box_wide,box_margin*2+box_tall,mat_name,LocalPlayer().character:GetFullName());

	-- HEALTH
	smoothHealth = Lerp(FrameTime() * animationSpeed, smoothHealth, localplayer:Health());

	drawHUDBox(box_margin,box_margin,nil,"Health");
	if smoothHealth >= 1 then
		draw.RoundedBox(2, box_margin+1, box_margin+1, (box_wide-2) * smoothHealth/100, box_tall-2, color_health)
	end

	-- ENERGY
	smoothEnergy = Lerp(FrameTime() * animationSpeed,smoothEnergy,math.ceil( localplayer:ESGetNetworkedVariable("energy",100) ));

	drawHUDBox(box_margin,box_margin*2+box_tall,nil,"Energy");
	if smoothEnergy >= 1 then 
		draw.RoundedBox(2, box_margin+1, (box_margin*2+box_tall)+1, (box_wide-2) * smoothEnergy/100, box_tall-2, color_energy)
	end

	-- RESET RENDER POSITION;
	cam.PopModelMatrix();

	-- DISABLE AA
	render.PopFilterMag();
	render.PopFilterMin();
end

local fov = 0;
local thirdperson = true;
local newpos
local tracedata = {}
local ignoreent
local distance = 0;
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
			trace = util.TraceLine(tracedata)  
	        pos = newpos
			newpos = LerpVector( 0.3, pos, trace.HitPos + trace.HitNormal*2 )
			angles = newangles
			newangles = LerpAngle( 0.3, angles, (ply:GetEyeTraceNoCursor().HitPos-newpos):Angle() )

			camPos = pos
			camAng = angles;
			
			pos=newpos;
		else
			tracedata.start = pos
			tracedata.endpos = pos - ( angles:Forward() * distance * 2 ) + ( angles:Up()* ((distance/60)*20) )
			tracedata.filter = ignoreent
			
	    	trace = util.TraceLine(tracedata)
	        pos = newpos
			newpos = LerpVector( 0.3, pos, trace.HitPos + trace.HitNormal*2 )

			camPos = pos
			camAng = angles
			

			pos=newpos;
		end
	else
		newpos = ply:EyePos();
	end

	fov=fov-2+(math.sin(CurTime()*2))*.3;

	local view = {origin = pos, angles = angles, fov = fov};
	if ERP.MainMenu and ERP.MainMenu:IsValid() then
		view.origin = Vector(-2677.004639, -645.997803, 92.479630);
		view.angles = Angle(6.719857, -59.160347, 0.000000);
		view.fov = 90;
	end
	return view
end

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