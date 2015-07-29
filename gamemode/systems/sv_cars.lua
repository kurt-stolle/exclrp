-- RESOURCE
resource.AddWorkshop("266579667") -- LWCars shared textures (required)
resource.AddWorkshop("417346741") -- LWCars Suzuki Liana GLX

-- DATABASE
hook.Add("ESDatabaseReady","exclrp.cars.createdb",function()
	ES.DBQuery("CREATE TABLE IF NOT EXISTS `erp_cars` (`id` INT unsigned NOT NULL AUTO_INCREMENT, charid INT unsigned NOT NULL, car varchar(255), modifiers text, PRIMARY KEY (`id`), UNIQUE KEY (`id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8;")
end)

-- METAMETHODS
local CHARACTER = FindMetaTable("Character")
function CHARACTER:LoadCars(cb)
  if self._isLoadingCars then
    return
  elseif self._cars then
		net.Start("exclrp.cars.get")
    net.WriteTable(self._cars)
    net.Send(self.Player)
    cb(self._cars)
    return
  end

  self._cars = {}
  self._isLoadingCars=true

  ES.DBQuery("SELECT car,modifiers FROM `erp_cars` WHERE charid = "..self:GetID().." LIMIT 50;",function(res)
    if not res or not res[1] then
      self._cars = {}
    else
      for k,v in ipairs(res)do
        v.modifiers = ES.Deserialize(v.modifiers);
      end
      self._cars = res
    end

		net.Start("exclrp.cars.get")
    net.WriteTable(res)
    net.Send(self.Player)

		if type(cb) == "function" then
			cb(res)
		end
  end)
end

-- NETWORKING
util.AddNetworkString("exclrp.cars.get")
net.Receive("exclrp.cars.get",function(len,ply)
  if not ply:IsLoaded() or ply._nwSpam and ply._nwSpam > CurTime() then return end

  ply._nwSpam = CurTime()+1;

  ply:GetCharacter():LoadCars()
end)

util.AddNetworkString("exclrp.cars.buy")
net.Receive("exclrp.cars.buy",function(len,ply)
	if not ply:IsLoaded() or ply._nwSpam and ply._nwSpam > CurTime() or not ply:GetCharacter()._cars then return ply:CreateErrorDialog("Invalid request!") end

	ply._nwSpam = CurTime()+1;

	local car = ERP.Cars[net.ReadString() or ""]

	local char=ply:GetCharacter()

	if not car or car.price > char:GetCash() then return ply:CreateErrorDialog("You don't have enough cash to buy this car. Find an ATM to withdraw some cash.") end

	for k,v in ipairs(char._cars or {})do
		if v.car == car.name then
			ply:CreateErrorDialog("You already own this car!")
			return
		end
	end

	char:TakeCash(car.price)
	table.insert(char._cars,{car=car.name,modifiers={}})

	ES.DBQuery("INSERT INTO `erp_cars` (charid,car,modifiers) VALUES ("..char:GetID()..",'"..car.name.."','"..ES.Serialize{}.."')")

	char:LoadCars()

	ply:ESSendNotificationPopup("generic","Successfully purchased a "..car.name.."! You may now always spawn it at the car dealership.")
end)

util.AddNetworkString("exclrp.cars.spawn")
net.Receive("exclrp.cars.spawn",function(len,ply)
	if not ply:IsLoaded() or ply._nwSpam and ply._nwSpam > CurTime() then return ply:CreateErrorDialog("Invalid request!") end

	ply._nwSpam = CurTime()+1;

	local car = ERP.Cars[net.ReadString()]

	local char=ply:GetCharacter()

	if not char:HasCar(car.name) then return ply:CreateErrorDialog("You don't own this car. Buy it first.") end

	if IsValid(ply._spawnedCar) then ply._spawnedCar:Remove() end

	local spawn=table.Random(ents.FindByClass("erp_car_spawn"))

	if not IsValid(spawn) then
		return ply:CreateErrorDialog("No valid parking space found. Try again later.")
	end

	local ent=ents.Create("prop_vehicle_jeep")
	ent:SetModel(car.model)
	ent:SetKeyValue("vehiclescript",car.script)
	ent:SetPos(spawn:GetPos())
	ent:SetAngles(spawn:GetAngles())
	ent:Spawn()
	ent:Activate()

	ply._spawnedCar = ent

	ply:ESSendNotificationPopup("generic","Your car was spawned at a parking space nearby.")
end)

-- HOOKS
hook.Add("ERPCharacterUnloaded","exclrp.cars.unload",function(ply)
	if IsValid(ply._spawnedCar) then ply._spawnedCar:Remove() end
end)

CarDamageConfig =
{
	Debug = true, ---------------------- Print Damage
	OneHitExplode = true, --------------- One Hit Explode on take damage from explosion (ex. RPG C4)
	HPtoSmoke = 50, ----------------------- Minimum HP to making smoke
	VehicleHP = 200, ----------------------- Vehicle HP
	CleanVehicleProp = 30, ---------------------- Clear Vehicles in second
	MinRandomExplode = 1, ------------------------ Minimum random time to explode after the car burning
	MaxRandomExplode = 15, ------------------------ Maximum random time to explode after the car burning
	MagnitudeDamage = 100, --------------------------- explosion damages given to player
	DamageMultiple = 800, --------------------------- Damage Multiple
	MinDamageEntity = 1, ----------------------------- Minimum damage can take to vehicle
	MaxDamageEntity = 10, ----------------------------- Maximum damage can take to vehicle
	FireRadius = 100, ------------------------------- Radius to ignite around prop near car when explode
	ExplodeRadius = 500, ------------------------------- Radius Explosion around prop near car when explode
	IgniteAroundProp = 30, -------------------------- Second to ignite around prop near car when explode
	VehicleUp = 100, --------------------- Make vehicle fly up in to sky when explode
	ExplosionSound = "ambient/explosions/explode_1.wav", ------------- Sound Explode
	IgniteSound = "ambient/fire/ignite.wav", ----------------- Sound start ignite
	ExplosionEffect = "HelicopterMegaBomb", ------------------ Particle Explode list here : http://maurits.tv/data/garrysmod/wiki/wiki.garrysmod.com/indexe14a.html
	BurningEffect = "fire_large_01", ------------------ Particle Burning after out of HP
	IgniteEffect = "burning_engine_01", ------------------ Particle Smoke near explode
	WreckCar = "models/props_pipes/GutterMetal01a" --------------- Material Wreck car
}

----------------Burning Sound-------------------
sound.Add{
 name = "fire_med_loop1",
 channel = CHAN_STATIC,
 volume = 10.0,
 soundlevel = 100,
 pitchstart = 100,
 pitchend = 100,
 sound = "ambient/fire/fire_med_loop1.wav"
}

hook.Add("OnEntityCreated","exclrp.cars.sethealth",function(ent)
	if ent:IsVehicle() then
		if ent:GetClass() == "prop_vehicle_prisoner_pod" then return end
		ent:SetHealth(100)
	end
end)

local function explode(ent)
	local vPoint = ent:GetPos()
	local effectdata = EffectData()
	effectdata:SetStart( vPoint )
	effectdata:SetOrigin( vPoint )
	effectdata:SetScale(1)
	util.Effect( "HelicopterMegaBomb", effectdata )
	util.BlastDamage(ent, ent, ent:GetPos(), 500, 100)
	ent:EmitSound("ambient/explosions/explode_1.wav", 100)

	if ent:GetDriver():IsPlayer() then
		local explodeplayer = DamageInfo()
		explodeplayer:SetDamage( 9999999999 )
		explodeplayer:SetDamageType( DMG_BLAST )
		ent:GetDriver():TakeDamageInfo( explodeplayer )
	end

	for k, v in ipairs(ents.FindInSphere( ent:GetPos() , 100 )) do
		v:Ignite( CarDamageConfig.IgniteAroundProp )
	end

	ent:Remove()

	local prop = ents.Create("prop_physics")
	prop:SetModel(ent:GetModel())
	prop:SetMaterial("models/props_pipes/GutterMetal01a")
	prop:SetPos(ent:GetPos())
	prop:SetAngles(ent:GetAngles())
	prop:Spawn()
	prop:Ignite(29-1, 0)
	timer.Simple(30, function()
		if not IsValid(prop) then return end

		prop:StopSound("fire_med_loop1")
		prop:Remove()
	end)

	ParticleEffectAttach("fire_large_01",PATTACH_ABSORIGIN_FOLLOW,prop,0)
	prop:EmitSound("fire_med_loop1", 100)
	prop:GetPhysicsObject():ApplyForceCenter( (prop:GetPos() - (prop:GetPos() - prop:GetUp() * 100)) * 5000)
end

hook.Add("EntityTakeDamage", "exclrp.cars.damage", function(ent, dmginfo)
	local infl = dmginfo:GetInflictor()
	local att = dmginfo:GetAttacker()
	local amount	= dmginfo:GetDamage()

	if not ent:IsVehicle() or ent:GetClass() == "prop_vehicle_prisoner_pod" then return end

	local damage
	if dmginfo:IsExplosionDamage() then
		ent.IsDamageFromExplosion = true

		damageExplosion = amount * 800
		ent:SetHealth(ent:Health() - damageExplosion)
	else
		damage = math.Clamp(amount * 800,1,10)

		ent:SetHealth(ent:Health() - damage)
	end

	if ent:Health() <= 50 and not ent.smoke then
		ParticleEffectAttach("burning_engine_01",PATTACH_ABSORIGIN_FOLLOW,ent,0)
		ent:EmitSound(CarDamageConfig.IgniteSound, 100)
		ent.smoke = true
	end

	if ent:Health() <= 0 and not ent.Burning and ent.IsDamageFromExplosion == true then
		ent.Burning = true

		explode(ent)
	elseif ent:Health() <= 0 and not ent.Burning then
		ent.Burning = true

		local ExplodeTime = math.random(4,8)

		ParticleEffectAttach("fire_large_01",PATTACH_ABSORIGIN_FOLLOW,ent,0)

		ent:EmitSound("ambient/fire/ignite.wav", 100)
		ent:EmitSound("fire_med_loop1", 100)

		ent:Ignite(ExplodeTime, 0)
		timer.Simple(ExplodeTime, function()
			explode(ent)
		end)
	end
end)
