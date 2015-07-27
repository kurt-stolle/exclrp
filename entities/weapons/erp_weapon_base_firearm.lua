AddCSLuaFile()

DEFINE_BASECLASS("erp_weapon_base")
local ply;

WEAPON_STATUS_NONE = 0
WEAPON_STATUS_AIM = 1
WEAPON_STATUS_SPRINT = 2

-- Display values
SWEP.Base = "erp_weapon_base"
SWEP.PrintName = "Firearm Base"
SWEP.Slot = 0
SWEP.SlotPos = 0


-- ERP values
SWEP.GenerateItem = false

-- Information values
SWEP.Spawnable = false
SWEP.AdminOnly = true
SWEP.UseHands = true
SWEP.Category = "ExclRP"
SWEP.Slot = 5


-- Configuration values
SWEP.ViewModel = "models/weapons/c_357.mdl"
SWEP.WorldModel = "models/weapons/w_357.mdl"
SWEP.HoldType = "pistol"
SWEP.CanRechamber = true
SWEP.Sound = "Weapon_357"

SWEP.Primary.ClipSize = 16
SWEP.Primary.DefaultClip = 16
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "Pistol Ammo"
SWEP.Primary.Recoil = 1
SWEP.Primary.Accuracy = 0.1
SWEP.Primary.Force = 10
SWEP.Primary.Delay = .1
SWEP.Primary.Damage = 100
SWEP.Primary.Automatic = false

-- Bullshit
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

AccessorFunc(SWEP,"nextReload","NextReload",FORCE_NUMBER)
AccessorFunc(SWEP,"lastShoot","LastShoot",FORCE_NUMBER)
AccessorFunc(SWEP,"spread","Spread",FORCE_NUMBER)
-- Hooks
function SWEP:SetupDataTables()
  self:NetworkVar("Int",0,"Status" )
--  self:NetworkVar( "Float", 0, "Spread" );
end

function SWEP:Initialize()
  self:SetHoldType( self.HoldType )
  self:SetLastShoot(CurTime())
  self:SetStatus(WEAPON_STATUS_NONE)
  self:SetNextReload(CurTime())
  self:SetSpread(self.Primary.Accuracy)
end

function SWEP:IsFirearm()
  return true
end

function SWEP:IsSidearm()
  return self.HoldType == "pistol"
end

function SWEP:TranslateFOV( fov )
  self.fovSmooth = Lerp(FrameTime()*2,self.fovSmooth or fov,self:GetStatus() == WEAPON_STATUS_AIM and 50 or fov)
	return self.fovSmooth;
end

function SWEP:Think()
  ply=self.Owner;

  if not IsValid(ply) then return end

  -- Check if running
  if ply:KeyDown(IN_SPEED) and ply:GetVelocity():Length() > ply:GetWalkSpeed() + 10 and ply:IsOnGround() then
    if self:GetStatus() ~= WEAPON_STATUS_SPRINT then
      self:SetStatus(WEAPON_STATUS_SPRINT)
    end

  -- Check if aiming
  elseif ply:KeyDown(IN_ATTACK2) then
    if self:GetStatus() ~= WEAPON_STATUS_AIM then
      self:SetStatus(WEAPON_STATUS_AIM)
    end

  -- Check if just chilling
  else
    if self:GetStatus() ~= WEAPON_STATUS_NONE then
      self:SetStatus(WEAPON_STATUS_NONE)
    end

  end

  -- Close the gap if last fire > x seconds
  if self:GetLastShoot() + .1 < CurTime() then
    self:SetSpread(Lerp(FrameTime(),self:GetSpread(),self.Primary.Accuracy))
  end
end

function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_DRAW);
	self:SetNextPrimaryFire(CurTime() + 1);

  local timerName="ERP."..self.Owner:SteamID()..".ReloadTimer"
  if timer.Exists(timerName) then
    timer.Stop(timerName)
  	timer.Remove(timerName)
  end

	return true;
end

function SWEP:Holster()
  local timerName="ERP."..self.Owner:SteamID()..".ReloadTimer"
  if timer.Exists(timerName) then
    timer.Stop(timerName)
    timer.Remove(timerName)
  end

	return true;
end

SWEP.NextReload = CurTime();
local timeStartReload;
function SWEP:Reload()
	if self:GetNextReload() > CurTime() or self:GetStatus() ~= WEAPON_STATUS_NONE or not IsFirstTimePredicted()  then return end

  local hasAmmo,x,y = self.Owner:GetCharacter():GetInventory():HasItem(self.Primary.Ammo);

  if not hasAmmo then return end

	self:SetStatus(WEAPON_STATUS_NONE);
	self:SendWeaponAnim(ACT_VM_RELOAD);
	self.Owner:SetAnimation(PLAYER_RELOAD);

  if SERVER then
    self:EmitSound( self.Sound..".Reload" )
  end

	local clip = self:Clip1();
	local dur;
	if clip > 0 and self.CanRechamber then
		self.Rechamber = false;
		self:SetClip1(1);

		dur = self.Owner:GetViewModel():SequenceDuration();
	else
		self.Rechamber = true;

		dur = self.Owner:GetViewModel():SequenceDuration();
	end

	self:SetNextPrimaryFire(CurTime()+dur);
  self:SetNextReload(CurTime()+dur);
	self:SetLastShoot(0);

	timer.Create("ERP."..self.Owner:SteamID()..".ReloadTimer", dur,1,function()
		if not IsValid(self) or not IsValid(self.Owner) then return end

    if SERVER then
  		if not self.Rechamber then
  			self:SetClip1(self.Primary.ClipSize+1);
  		else
  			self:SetClip1(self.Primary.ClipSize);
  		end

      self.Owner:GetCharacter():GetInventory():RemoveItem(ERP.Items[self.Primary.Ammo],x,y)
    end
	end)
end

function SWEP:PrimaryAttack()
	if self:GetStatus() == WEAPON_STATUS_SPRINT then return end

	if self:Clip1() <= 0 then
		self:SetNextPrimaryFire(CurTime()+self.Primary.Delay);
		self:EmitSound( self.Sound..".Empty" )
		return;
	end

  self:TakePrimaryAmmo(1);
	self:Shoot( self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self:GetSpread() )
  self:SetLastShoot(CurTime());
  self:SetSpread( math.Clamp(self:GetSpread() + self.Primary.Delay * .1, 0, self.Primary.Accuracy* 2) )
  self:SetNextPrimaryFire(CurTime()+self.Primary.Delay);

  if SERVER then
		self.Owner:EmitSound(self.Sound..".Single", 100, math.random(100, 110))
	end

  return true
end

SWEP.Markers = {};
function SWEP:Shoot( dmg, recoil, numbul, cone )
	if IsFirstTimePredicted() then
		local bullet = {
			Num 		= numbul;
			Src 		= self.Owner:GetShootPos();
			Dir 		= ( self.Owner:EyeAngles() + self.Owner:GetPunchAngle() ):Forward();
			Spread 	= Vector( cone, cone, 0 );
			Tracer	= 3;
			Force	  = self.Primary.Force;
			Damage	= dmg;
			Callback = function(attacker, tr, dmginfo)
			  if tr.HitWorld and tr.MatType == MAT_METAL then
			      local eff = EffectData()
			      eff:SetOrigin(tr.HitPos)
			      eff:SetNormal(tr.HitNormal)
			      util.Effect("cball_bounce", eff)
			   end

			   if tr.Entity and IsValid(tr.Entity) and tr.Entity:IsPlayer() then

			      table.insert(self.Markers,{
			         pos = tr.HitPos, alpha = 255
			      })
			   end
			 end
		}

		self.Owner:FireBullets(bullet)
	end

	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK);
	self.Owner:SetAnimation(PLAYER_ATTACK1);
	self.Owner:MuzzleFlash();


	if CLIENT then
		self:FireCallback();

		if  IsFirstTimePredicted() then
			local eyeang = self.Owner:EyeAngles()
			eyeang.pitch = eyeang.pitch - (recoil * 0.3)*2
			eyeang.yaw = eyeang.yaw - (recoil * math.random(-1, 1) * 0.3)
			self.Owner:SetEyeAngles( eyeang )
		end
	end
end

local ActivityTranslateHipFire = {}
ActivityTranslateHipFire [ ACT_MP_STAND_IDLE ] 					= ACT_HL2MP_IDLE_SHOTGUN;
ActivityTranslateHipFire [ ACT_MP_WALK ] 						= ACT_HL2MP_IDLE_SHOTGUN+1;
ActivityTranslateHipFire [ ACT_MP_RUN ] 						= ACT_HL2MP_IDLE_SHOTGUN+2;
ActivityTranslateHipFire [ ACT_MP_CROUCH_IDLE ] 				= ACT_HL2MP_IDLE_SHOTGUN+3;
ActivityTranslateHipFire [ ACT_MP_CROUCHWALK ] 					= ACT_HL2MP_IDLE_SHOTGUN+4;
ActivityTranslateHipFire [ ACT_MP_ATTACK_STAND_PRIMARYFIRE ] 	= ACT_HL2MP_IDLE_SMG1+5;
ActivityTranslateHipFire [ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ] 	= ACT_HL2MP_IDLE_SMG1+5;
ActivityTranslateHipFire [ ACT_MP_RELOAD_STAND ]		 		= ACT_HL2MP_IDLE_SMG1+6;
ActivityTranslateHipFire [ ACT_MP_RELOAD_CROUCH ]		 		= ACT_HL2MP_IDLE_SMG1+6;
ActivityTranslateHipFire [ ACT_MP_JUMP ] 						= ACT_HL2MP_IDLE_SHOTGUN+7;
ActivityTranslateHipFire [ ACT_RANGE_ATTACK1 ] 					= ACT_HL2MP_IDLE_SMG1+8;
ActivityTranslateHipFire [ ACT_MP_SWIM ] 						= ACT_HL2MP_IDLE_SHOTGUN+9;

local ActivityTranslatePistolNoAim = {}
ActivityTranslatePistolNoAim [ ACT_MP_STAND_IDLE ] 					= ACT_HL2MP_IDLE_PISTOL;
ActivityTranslatePistolNoAim [ ACT_MP_WALK ] 						= ACT_HL2MP_IDLE_PISTOL+1;
ActivityTranslatePistolNoAim [ ACT_MP_RUN ] 						= ACT_HL2MP_IDLE_PISTOL+2;
ActivityTranslatePistolNoAim [ ACT_MP_CROUCH_IDLE ] 				= ACT_HL2MP_IDLE_PISTOL+3;
ActivityTranslatePistolNoAim [ ACT_MP_CROUCHWALK ] 					= ACT_HL2MP_IDLE_PISTOL+4;
ActivityTranslatePistolNoAim [ ACT_MP_ATTACK_STAND_PRIMARYFIRE ] 	= ACT_HL2MP_IDLE_PISTOL+5;
ActivityTranslatePistolNoAim [ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ] 	= ACT_HL2MP_IDLE_PISTOL+5;
ActivityTranslatePistolNoAim [ ACT_MP_RELOAD_STAND ]		 		= ACT_HL2MP_IDLE_PISTOL+6;
ActivityTranslatePistolNoAim [ ACT_MP_RELOAD_CROUCH ]		 		= ACT_HL2MP_IDLE_PISTOL+6;
ActivityTranslatePistolNoAim [ ACT_MP_JUMP ] 						= ACT_HL2MP_IDLE_PISTOL+7;
ActivityTranslatePistolNoAim [ ACT_RANGE_ATTACK1 ] 					= ACT_HL2MP_IDLE_PISTOL+8;
ActivityTranslatePistolNoAim [ ACT_MP_SWIM ] 						= ACT_HL2MP_IDLE_PISTOL+9;

local ActivityTranslateSprintRifle = {}
ActivityTranslateSprintRifle [ ACT_MP_STAND_IDLE ] 					= ACT_HL2MP_IDLE_PASSIVE;
ActivityTranslateSprintRifle [ ACT_MP_WALK ] 						= ACT_HL2MP_IDLE_PASSIVE+1;
ActivityTranslateSprintRifle [ ACT_MP_RUN ] 							= ACT_HL2MP_IDLE_PASSIVE+2;
ActivityTranslateSprintRifle [ ACT_MP_CROUCH_IDLE ] 					= ACT_HL2MP_IDLE_PASSIVE+3;
ActivityTranslateSprintRifle [ ACT_MP_CROUCHWALK ] 					= ACT_HL2MP_IDLE_PASSIVE+4;
ActivityTranslateSprintRifle [ ACT_MP_ATTACK_STAND_PRIMARYFIRE ] 	= ACT_HL2MP_IDLE_PASSIVE+5;
ActivityTranslateSprintRifle [ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ] 	= ACT_HL2MP_IDLE_PASSIVE+5;
ActivityTranslateSprintRifle [ ACT_MP_RELOAD_STAND ]		 			= ACT_HL2MP_IDLE_PASSIVE+6;
ActivityTranslateSprintRifle [ ACT_MP_RELOAD_CROUCH ]		 		= ACT_HL2MP_IDLE_PASSIVE+6;
ActivityTranslateSprintRifle [ ACT_MP_JUMP ] 						= ACT_HL2MP_IDLE_PASSIVE+7;
ActivityTranslateSprintRifle [ ACT_RANGE_ATTACK1 ] 					= ACT_HL2MP_IDLE_PASSIVE+8;
ActivityTranslateSprintRifle [ ACT_MP_SWIM ] 						= ACT_HL2MP_IDLE_PASSIVE+9;

local ActivityTranslateSprintPistol = {}
ActivityTranslateSprintPistol [ ACT_MP_STAND_IDLE ] 					= ACT_HL2MP_IDLE;
ActivityTranslateSprintPistol [ ACT_MP_WALK ] 						= ACT_HL2MP_IDLE+1;
ActivityTranslateSprintPistol [ ACT_MP_RUN ] 							= ACT_HL2MP_IDLE+2;
ActivityTranslateSprintPistol [ ACT_MP_CROUCH_IDLE ] 					= ACT_HL2MP_IDLE+3;
ActivityTranslateSprintPistol [ ACT_MP_CROUCHWALK ] 					= ACT_HL2MP_IDLE+4;
ActivityTranslateSprintPistol [ ACT_MP_ATTACK_STAND_PRIMARYFIRE ] 	= ACT_HL2MP_IDLE+5;
ActivityTranslateSprintPistol [ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ] 	= ACT_HL2MP_IDLE+5;
ActivityTranslateSprintPistol [ ACT_MP_RELOAD_STAND ]		 			= ACT_HL2MP_IDLE+6;
ActivityTranslateSprintPistol [ ACT_MP_RELOAD_CROUCH ]		 		= ACT_HL2MP_IDLE+6;
ActivityTranslateSprintPistol [ ACT_MP_JUMP ] 						= ACT_HL2MP_IDLE_DUEL+7;
ActivityTranslateSprintPistol [ ACT_RANGE_ATTACK1 ] 					= ACT_HL2MP_IDLE+8;
ActivityTranslateSprintPistol [ ACT_MP_SWIM ] 						= ACT_HL2MP_IDLE+9;

function SWEP:TranslateActivity( act )

	local holdtype = string.lower(self.HoldType);

	if ( holdtype == "ar2" or holdtype=="smg" ) then
		if self:GetStatus() == WEAPON_STATUS_NONE and ActivityTranslateHipFire[ act ] ~= nil  then
			return ActivityTranslateHipFire[ act ]
		elseif self:GetStatus() == WEAPON_STATUS_SPRINT and ActivityTranslateSprintRifle[ act ] ~= nil then
			return ActivityTranslateSprintRifle[act];
		end
	end

	if ( holdtype == "revolver" or holdtype=="pistol") then
		if self:GetStatus() == WEAPON_STATUS_NONE and holdtype == "revolver" and ActivityTranslatePistolNoAim[ act ] ~= nil  then
			return ActivityTranslatePistolNoAim[ act ]
		elseif self:GetStatus() == WEAPON_STATUS_SPRINT and ActivityTranslateSprintPistol[ act ] ~= nil  then
			return ActivityTranslateSprintPistol[ act ]
		end
	end

	if ( self.ActivityTranslate[ act ] ~= nil ) then
		return self.ActivityTranslate[ act ]
	end

	return -1
end

if CLIENT then
  function SWEP:DoDrawCrosshair(...)
    self.CrosshairGap= 1000 * self:GetSpread() * (90/self.Owner:GetFOV())

    return BaseClass.DoDrawCrosshair(self,...)
  end

  local lastFire = 0;
  function SWEP:FireCallback()
  	if IsFirstTimePredicted() then
  		local vm = self.Owner:GetViewModel();
  		local muz = vm:GetAttachment("1");

  		if not self.Em then
  			self.Em = ParticleEmitter(muz.Pos);
  		end

  		local par = self.Em:Add("particle/smokesprites_000" .. math.random(1, 9), muz.Pos);
  		par:SetStartSize(math.random(0.5, 1));
  		par:SetStartAlpha(100);
  		par:SetEndAlpha(0);
  		par:SetEndSize(math.random(4, 4.5));
  		par:SetDieTime(1 + math.Rand(-0.3, 0.3));
  		par:SetRoll(math.Rand(0.2, .8));
  		par:SetRollDelta(0.8 + math.Rand(-0.3, 0.3));
  		par:SetColor(140,140,140,200);
  		par:SetGravity(Vector(0, 0, .5));
  		local mup = (muz.Ang:Up()*-1);
  		par:SetVelocity(Vector(0, 0,7)-Vector(mup.x,mup.y,0));

  		local par = self.Em:Add("sprites/heatwave", muz.Pos);
  		par:SetStartSize(4);
  		par:SetEndSize(0);
  		par:SetDieTime(0.6);
  		par:SetGravity(Vector(0, 0, 1));
  		par:SetVelocity(Vector(0, 0, 1));
  	end
  	lastFire = CurTime();
  end

  function SWEP:AdjustMouseSensitivity()
  	return self:GetStatus() == WEAPON_STATUS_AIM and .5 or 1;
  end

  local runAngle=Angle(-10,3,-5)
  local runPos=Vector(0,-3,0)
  local runAnglePistol=Angle(70,0,0)
  local runPosPistol=Vector(3,-15,-10)
  function SWEP:GetViewModelPosition( pos, ang )
    local targetPos,targetAng,animSpeed;

    if self:GetStatus() == WEAPON_STATUS_SPRINT then
      if self.Slot == 1 then
        targetAng=runAnglePistol;
        targetPos=runPosPistol;
      else
        targetAng=runAngle;
        targetPos=runPos;
      end

      animSpeed = 5
    elseif self:GetStatus() == WEAPON_STATUS_AIM then
      targetAng=Angle(0,0,0)
      targetPos=Vector(0,0,0)

      animSpeed = 8
    else
      targetAng=Angle(0,0,0)
      targetPos=Vector(0,0,0)

      animSpeed = 8
    end

    self.smoothTargetPos = LerpVector(FrameTime()*animSpeed,self.smoothTargetPos or targetPos,targetPos)
    self.smoothTargetAng = LerpAngle(FrameTime()*animSpeed,self.smoothTargetAng or targetAng,targetAng)

    ang:RotateAroundAxis( ang:Right(), self.smoothTargetAng.x);
  	ang:RotateAroundAxis( ang:Up(), self.smoothTargetAng.y);
  	ang:RotateAroundAxis( ang:Forward(),  self.smoothTargetAng.z);
  	pos = pos + self.smoothTargetPos.x * ang:Right();
  	pos = pos + self.smoothTargetPos.y * ang:Forward();
  	pos = pos + self.smoothTargetPos.z * ang:Up();

  	return pos, ang
  end

  local lp,wep;
  hook.Add("HUDPaint","weapon_base_firearm.drawhitmarkers",function()
  	lp=LocalPlayer();
  	if IsValid(lp) then
  		wep = lp:GetActiveWeapon();
  		if IsValid(wep) and wep.Markers then
  		   for k,v in pairs( wep.Markers)do
  		      if v.alpha < 5 then
  		         table.remove( wep.Markers,k);
  		         continue;
  		      end
  		      local pos = v.pos:ToScreen();

  		      surface.SetDrawColor(Color(255,255,255,v.alpha))
  		      surface.DrawLine(pos.x-2,pos.y-2,pos.x-5,pos.y-5);
  		      surface.DrawLine(pos.x+2,pos.y+2,pos.x+5,pos.y+5);
  		      surface.DrawLine(pos.x-2,pos.y+2,pos.x-5,pos.y+5);
  		      surface.DrawLine(pos.x+2,pos.y-2,pos.x+5,pos.y-5);
  		      v.alpha = v.alpha-FrameTime()*240;
  		   end
  		end
  	end
  end)
end
