-- TODO: Unfinished implementation

-- Load from database
local ranks_sync={}
hook.Add("ESDatabaseReady","ERP.ES.SetupGangsSQL",function()
	ES.DebugPrint("Loading gangs information...")
	ES.DBQuery("CREATE TABLE IF NOT EXISTS `erp_gangs` (`id` int unsigned NOT NULL AUTO_INCREMENT, name varchar(255), description varchar(255), sign varchar(255), members TEXT, exp int unsigned default 0, ranks TEXT, PRIMARY KEY (`id`), UNIQUE KEY (`id`)) ENGINE=MyISAM DEFAULT CHARSET=latin1;",function()
    ES.DBQuery("SELECT name, description, sign, members, exp, ranks FROM `erp_gangs`;",function(res)
      if not res or not res[1] then return end

      ranks_sync=res

      for k,v in ipairs(res)do
        local gang=ERP.Gang(v.name,v.description,v.sign)
        gang.members=ES.Deserialize(v.members)
        gang.ranks=ES.Deserialize(v.ranks)
        gang.exp=v.exp
      end
    end);
	end):wait();
end)

-- Extend gang class
local GANG=FindMetaTable("Gang");

function GANG:AddMember(charID,name)
  if not charID or not name then
    ES.DebugPrint("Failed to add member to gang; invalid arguments.",charID,name)
    return false
  end

  table.insert(self.members,{id=charID,name=name,rank="none"})

  return true
end

function GANG:AddRank(name,power)
  if not name or not power or power < 1 or power > 9998 then
    ES.DebugPrint("Failed to add rank to gang; invalid arguments.",name,power)
    return false
  end

  self.ranks[name]=power

  return true
end

function GANG:Save()

end

function GANG:Sync()

end
