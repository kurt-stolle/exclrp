local PLAYER = {};

PLAYER.DisplayName    = "Default Class";
PLAYER.WalkSpeed			= 100;
PLAYER.RunSpeed				= 270;

STATUS_ARRESTED = 1
STATUS_TYPING = 2

function PLAYER:SetupDataTables()
  self.Player:NetworkVar( "Float", 0, "Energy" )
end

function PLAYER:SetModel()
  local pl=self.Player

  pl:SetModel(pl.character.model);
end

function PLAYER:Loadout()
  local pl=self.Player

  pl:StripWeapons()
  pl:Give("weapon_fists")
  pl:Give("weapon_physgun")
  pl:Give("gmod_camera")
  pl:Give("gmod_tool")
  pl:Give("erp_weapon_nothing")

  if pl.character.job and ERP.Jobs[pl.character.job] then
    for k,v in pairs(ERP.Jobs[pl.character.job]:GetLoadout())do
      pl:Give(v)
    end
  end

  pl:SelectWeapon("erp_weapon_nothing")

  pl:SetEnergy(100);
end

function PLAYER:Spawn()
  local pl=self.Player
  local col = Vector(180/255,180/255,180/255);

  pl:AddEffects(EF_NOSHADOW)

  if pl.character.job and ERP.Jobs[pl.character.job] then
    local job=ERP.Jobs[pl.character.job];

    pl:SetTeam(job:GetTeam())

    col = Vector(job.color.r/255,job.color.g/255,job.color.b/255);
  else
    pl:SetTeam(TEAM_UNASSIGNED)
  end

  pl:SetStatus(0)
  pl:SetPlayerColor(col);
  pl:SetWeaponColor(col);
end

player_manager.RegisterClass( "player_erp_default", PLAYER, "player_default" );
