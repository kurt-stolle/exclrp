local PLAYER = {};

PLAYER.DisplayName    = "Default Class";
PLAYER.WalkSpeed			= 100;
PLAYER.RunSpeed				= 270;

function PLAYER:SetModel()
  local pl=self.Player

  pl:SetModel(pl.character.model);
end

function PLAYER:Loadout()
  local pl=self.Player

  pl:Give("weapon_fists")
  pl:Give("erp_weapon_nothing")

  if pl:IsSuperAdmin() then
    pl:Give("erp_weapon_config")
  end

  pl:SelectWeapon("erp_weapon_nothing")

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

  pl:SetPlayerColor(col);
  pl:SetWeaponColor(col);
end

player_manager.RegisterClass( "player_erp_default", PLAYER, "player_default" );
