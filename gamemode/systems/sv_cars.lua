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
    cb(self._cars)
    return
  end

  self._cars = {}
  self._isLoadingCars=true

  ES.DBQuery("SELECT * FROM `erp_cars` WHERE charid = "..self:GetID().." LIMIT 50;",function(res)
    if not res or not res[1] then
      self._cars = {}
    else
      for k,v in ipairs(res)do
        v.modifiers = ES.Deserialize(v.modifiers);
      end
      self._cars = res
    end

    cb(self.cars)
  end)
end

-- NETWORKING
net.Receive("exclrp.cars.get",function(len,ply)
  if not ply:IsLoaded() or ply._nwSpam and ply._nwSpam > CurTime() then return end

  ply._nwSpam = CurTime()+1;

  ply:GetCharacter():LoadCars(function(cars)
    net.Start("exclrp.cars.get")
    net.WriteTable(cars)
    net.Send(ply)
  end)
end)
