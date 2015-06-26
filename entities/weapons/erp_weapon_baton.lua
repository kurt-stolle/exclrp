AddCSLuaFile()

SWEP.Base = "erp_weapon_base"

SWEP.AnimPrefix = "stunstick"

SWEP.Slot = 4

SWEP.PrintName = "Baton"
SWEP.Spawnable = true
SWEP.AdminOnly = true
SWEP.Category = "ExclRP"
SWEP.UseHands = true

SWEP.StickColor = ES.Color.White


SWEP.Primary.Automatic = true
SWEP.Secondary.Automatic = true

SWEP.ViewModel = Model("models/weapons/v_stunbaton.mdl")
SWEP.WorldModel = Model("models/weapons/w_stunbaton.mdl")

SWEP.HitDistance = 80
SWEP.HoldType = "melee"

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )

	if SERVER then return end

	CreateMaterial("exclrp/stick/"..self:GetClass(), "VertexLitGeneric", {
		["$basetexture"] = "models/debug/debugwhite",
		["$surfaceprop"] = "metal",
		["$envmap"] = "env_cubemap",
		["$envmaptint"] = "[ .5 .5 .5 ]",
		["$selfillum"] = 0,
		["$model"] = 1
	}):SetVector("$color2", self.StickColor:ToVector())
end

function SWEP:Deploy()
	if SERVER then
    self:SetMaterial("!exclrp/stick/"..self:GetClass())
    return true;
  end

	local vm = self:GetOwner():GetViewModel()

	if not IsValid(vm) then
    return true
  end

	self:PreDrawViewModel(vm)

	return true
end

function SWEP:PreDrawViewModel(vm)
	if not IsValid(vm) then return end

	for i = 9, 15 do
		vm:SetSubMaterial(i, "!darkrp/"..self:GetClass())
	end
end

function SWEP:ViewModelDrawn(vm)
	if not IsValid(vm) then return end

	vm:SetSubMaterial()
end

function SWEP:PrimaryAttack()
  self:Swing(function(ent)
    if SERVER and IsValid( ent ) and ( ent:IsNPC() or ent:IsPlayer() or ent:Health() > 0 ) then
  		local dmginfo = DamageInfo()

  		local attacker = self.Owner

  		if not IsValid( attacker ) then
        attacker = self
      end

  		dmginfo:SetAttacker( attacker )
  		dmginfo:SetInflictor( self )
  		dmginfo:SetDamage( math.random( 20,26 ) )
  		dmginfo:SetDamageForce( self.Owner:GetRight() * 4912 + self.Owner:GetForward() * 9998 )

  		ent:TakeDamageInfo( dmginfo )

			if ent:IsPlayer() then
			 ent:SetEnergy(0)
			end

  	end
  end)
end

function SWEP:SecondaryAttack()
  -- Override me
end

local SparkSound = {
	Sound ("weapons/stunstick/spark1.wav"),
	Sound ("weapons/stunstick/spark2.wav"),
	Sound ("weapons/stunstick/spark3.wav")
}
function SWEP:Reload()
	if CLIENT or self._lastReload and self._lastReload + .8 > CurTime() then return end

	self._lastReload=CurTime()

	self:EmitSound(SparkSound[math.random(1,#SparkSound)])

	return true
end

local HitSound = {
		Sound("weapons/stunstick/stunstick_impact1.wav"),
		Sound("weapons/stunstick/stunstick_impact2.wav")
	}

local HitFleshSound = {
		Sound("weapons/stunstick/stunstick_fleshhit1.wav"),
		Sound("weapons/stunstick/stunstick_fleshhit2.wav")
	}
local SwingSound = {
	Sound("weapons/stunstick/stunstick_swing1.wav"),
	Sound("weapons/stunstick/stunstick_swing2.wav")
}
function SWEP:Swing(callback)

	local vm = self:GetOwner():GetViewModel()
	if IsValid(vm) then
		vm:SendViewModelMatchingSequence(vm:LookupSequence("attackch"))
		vm:SetPlaybackRate(1.2)
	end

	local time = ( vm:SequenceDuration() / vm:GetPlaybackRate() ) * .5

	self:SetNextPrimaryFire(CurTime() + 2*time + 0.1);
  self:SetNextSecondaryFire(CurTime() + 2*time + 0.1);

	self.Owner:SetAnimation( PLAYER_ATTACK1 );

  self:EmitSound( SwingSound[math.random(1,#SwingSound)] );

	timer.Simple(time,function()
		if not IsValid(self) or not IsValid(self.Owner) then return end

	  self.Owner:LagCompensation( true );

		local tr = util.TraceLine{
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * self.HitDistance,
			filter = self.Owner,
			mask = MASK_SHOT_HULL
		};

		if not IsValid( tr.Entity ) then
			tr = util.TraceHull( {
				start = self.Owner:GetShootPos(),
				endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * self.HitDistance,
				filter = self.Owner,
				mins = Vector( -10, -10, -8 ),
				maxs = Vector( 10, 10, 8 ),
				mask = MASK_SHOT_HULL
			} )
		end

		-- We need the second part for single player because SWEP:Think is ran shared in SP
		if tr.Hit and not ( game.SinglePlayer() and CLIENT ) then
			if IsValid(tr.Entity) and ( tr.Entity:IsPlayer() or tr.Entity:IsNPC() ) then
				self:EmitSound( HitFleshSound[math.random(1,#HitFleshSound)] )
			else
				self:EmitSound( HitSound[math.random(1,#HitSound)] )
			end

			local effectData = EffectData()
			effectData:SetOrigin(tr.HitPos)
			effectData:SetNormal(tr.HitNormal)

			util.Effect("StunstickImpact", effectData)
		end

	  callback(tr.Entity)

		if SERVER and IsValid( tr.Entity ) then
			if tr.Entity:IsPlayer() then
				tr.Entity:ScreenFade(SCREENFADE.IN, ES.Color.White, 0.8, 0)
			end

			local phys = tr.Entity:GetPhysicsObject()
			if IsValid( phys ) then
				phys:ApplyForceOffset( self.Owner:GetAimVector() * 80 * phys:GetMass(), tr.HitPos )
			end
		end


		self.Owner:LagCompensation( false )
	end)
end
