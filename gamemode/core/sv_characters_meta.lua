-- sv_characters_meta.lua
local CHARACTER = FindMetaTable("Character");

-- FIELDS
function CHARACTER:Save(field,var)
	if var then
		self[field]=var
	end
	ERP.SaveCharacter(self.Player,field)
end

-- MONEY
function CHARACTER:SetCash(i)
	self.cash = i;

	ERP.SaveCharacter(self.Player,"cash");
end
function CHARACTER:AddCash(i)
	self:SetCash(self:GetCash()+i);
end
CHARACTER.GiveCash = CHARACTER.AddCash
function CHARACTER:TakeCash(i)
	self:AddCash(-i);
end

function CHARACTER:SetBank(i)
	self.bank = i;

	ERP.SaveCharacter(self.Player,"bank");
end
function CHARACTER:AddBank(i)
	self:SetBank(self:GetBank()+i);
end
CHARACTER.GiveBank = CHARACTER.AddBank
function CHARACTER:TakeBank(i)
	self:AddBank(-i);
end

-- WEAPONS
function CHARACTER:HandleWeapons()
	ES.DebugPrint("Handling weapons...")

	local WeaponList={}
	for k,v in ipairs(self:GetInventory():GetItemsWithData())do
		if v.item:GetWeapon() and not WeaponList[v.item:GetWeapon()] then
			WeaponList[v.item:GetWeapon()] = v.data and v.data["Clip1"] or 0
		end
	end

	for k,v in ipairs(self.Player:GetWeapons())do
		if v.GenerateItem then
			if not WeaponList[v:GetClass()] then
				self.Player:StripWeapon(k)
				ES.DebugPrint("Player has weapon he no longer should: "..k)
			end
		end
	end

	for k,v in pairs(WeaponList)do
		if not self.Player:HasWeapon(v) then
			self.Player:Give(k)

			ES.DebugPrint("Player given weapon: "..k)

			for _,wep in ipairs(self.Player:GetWeapons())do
				if wep:GetClass() == k then
					wep:SetClip1(v)
				end
			end
		end
	end
end

-- JOBS
function CHARACTER:SetJob(job)
	if not job then
		return;
	end

	job=ERP.Jobs[job];

	if not job or job:GetTeam() == self.Player:Team() then return end

	net.Start("ERP.Job.ChangedFX"); net.WriteEntity(self.Player); net.WriteUInt(job:GetTeam(),8); net.Broadcast();

	self.job=job:GetName();
	self.joblevel=0;

	ERP.SaveCharacter(self.Player,"job");
	ERP.SaveCharacter(self.Player,"joblevel");

	job:OnSelect(self.Player)

	player_manager.OnPlayerSpawn( self.Player )
	player_manager.RunClass( self.Player, "Spawn" )
	player_manager.RunClass( self.Player, "Loadout" )
	player_manager.RunClass( self.Player, "SetModel" )
end

-- INVENTORY
function CHARACTER:GiveItem(item,x,y,data)
	if not ERP.ValidItem(item) then return ES.DebugPrint("Invalid item given to character!"); end

	local inv = self:GetInventory();

	if not inv then return ES.DebugPrint("Character has an invalid inventory.") end

	if not x and not y then
		x,y = inv:FitItem(item)
	end

	if not x or x <= 0 or not y or y <= 0 then return ES.DebugPrint("No space in inventory for item given to character!"); end

	inv:AddItem(item,x,y,data)

	self:HandleWeapons()

	ERP.SaveCharacter(self.Player,"inventory");
end
function CHARACTER:MoveItem(item,xOld,yOld,xNew,yNew)
	if not ERP.ValidItem(item) then return ES.DebugPrint("Invalid item given to character!"); end

	local inv = self:GetInventory();

	if not inv then return ES.DebugPrint("Character has an invalid inventory.") end

	inv:MoveItem(item,xOld,yOld,xNew,yNew)

	ERP.SaveCharacter(self.Player,"inventory");
end
function CHARACTER:DropItem(item,x,y)
	if not ERP.ValidItem(item) then return ES.DebugPrint("Invalid item given to character!"); end

	local inv = self:GetInventory();

	if not inv then return ES.DebugPrint("Character has an invalid inventory.")
	elseif not inv:HasItemAt(item:GetName(),x,y) then return ES.DebugPrint("Player does not have specified item") end

	local trace={}
	trace.start = self.Player:EyePos()
	trace.endpos = trace.start + (self.Player:GetAngles():Forward() * 50)
	trace.filter = self.Player

	trace=util.TraceLine(trace)

	item:SpawnInWorld(trace.HitPos,self.Player:GetAngles(),inv:GetItemData(item:GetName(),x,y))

	inv:RemoveItem(item,x,y)

	self:HandleWeapons()

	ERP.SaveCharacter(self.Player,"inventory");
end
function CHARACTER:TakeItem(item,x,y)
	if not ERP.ValidItem(item) then return ES.DebugPrint("Invalid item taken from character!"); end

	local inv = self:GetInventory();

	if not inv then return ES.DebugPrint("Character has an invalid inventory.")
	elseif not inv:HasItemAt(item:GetName(),x,y) then return ES.DebugPrint("Player does not have specified item") end

	inv:RemoveItem(item,x,y)

	self:HandleWeapons()

	ERP.SaveCharacter(self.Player,"inventory");
end

-- ARREST SYSTEM
function CHARACTER:Arrest()
  if bit.band(self.Player:GetStatus(),STATUS_ARRESTED) > 0 then return ES.DebugPrint(self.Player," is already arrested") end

  ES.DebugPrint(self.Player," is being arrested!")

  self.Player:SetStatus( self.Player:GetStatus() + STATUS_ARRESTED )
  self.Player:Freeze(true)
  self.arrestTime = os.time() + 20;

  self.Player:ESSendNotificationPopup("Arrested","You have been arrested!\n\nYou have been sentenced to "..math.ceil(ERP.Config["arrest_time"]/60).." minutes in jail.\n\nYou will be automatically transferred to jail in 20 seconds. You will remain there until your jail time is over or until a Police officer unarrests you.")

  ERP.SaveCharacter(self.Player,"arrestTime");

  timer.Simple(20,function()
    if self and IsValid(self.Player) and self.Player:GetCharacter() == self and bit.band(self.Player:GetStatus(),STATUS_ARRESTED) > 0 then
      self.Player:Freeze(false)

      local random = table.Random(ents.FindByClass("erp_jail_spawn"))
      if not IsValid(random) then return ES.DebugPrint("No JailSpawn areas found!") end

      self.Player:SetPos(random:GetPos())

      timer.Create("ERP."..self:GetFullName()..".ArrestTimer",ERP.Config["arrest_time"],1,function()
        if self and IsValid(self.Player) and self.Player:GetCharacter() == self and bit.band(self.Player:GetStatus(),STATUS_ARRESTED) > 0 then
            self:UnArrest()
        end
      end)
    end
  end)
end

function CHARACTER:UnArrest()
  if bit.band(self.Player:GetStatus(),STATUS_ARRESTED) == 0 then return end

  ES.DebugPrint(self.Player," was unarrested!")

  if timer.Exists("ERP."..self:GetFullName()..".ArrestTimer") then
    timer.Remove("ERP."..self:GetFullName()..".ArrestTimer")
  end

  self.Player:SetStatus(self.Player:GetStatus() - STATUS_ARRESTED)

  self.arrestTime = 0;

  self.Player:ESSendNotificationPopup("Unarrested","You have been released from custody.")

  ERP.SaveCharacter(self.Player,"arrested");
end
