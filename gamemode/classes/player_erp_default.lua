local PLAYER = {};

DEFINE_BASECLASS( "player_default" )

PLAYER.DisplayName    = "ERP Default Class";
PLAYER.WalkSpeed			= 100;
PLAYER.RunSpeed				= 270;

STATUS_NONE = 0
STATUS_ARRESTED = 1
STATUS_DEAD = 2
STATUS_WANTED = 4

function PLAYER:SetupDataTables()
  self.Player:NetworkVar( "Float", 0, "Energy" )

  BaseClass.SetupDataTables(self)
end

function PLAYER:SetModel()
  local pl=self.Player
  local char=pl:GetCharacter()

  pl:SetModel(char:IsFemale() and char:GetClothing().modelFemale or char:GetClothing().model);

  local color = char:GetClothing().color

  pl:SetPlayerColor(Vector(color.r/255,color.g/255,color.b/255))
end

function PLAYER:Loadout()
  local pl=self.Player
  local char=pl:GetCharacter()

  pl:StripWeapons()
  pl:Give("weapon_fists")
  pl:Give("weapon_physgun")
  pl:Give("gmod_camera")
  pl:Give("gmod_tool")
  pl:Give("erp_weapon_nothing")

  if char.job then
    local job=ERP.Jobs[char.job];

    if IsValid(job) then
      for k,v in pairs(job:GetLoadout())do
        pl:Give(v);
      end
    end
  end

  char:HandleWeapons()

  pl:SelectWeapon("erp_weapon_nothing")
end

function PLAYER:Spawn()
  local pl=self.Player
  local col = Vector(180/255,180/255,180/255);

  -- for models
  pl:AddEffects(EF_NOSHADOW)

  -- handle status
  pl:SetStatus(STATUS_NONE);

  -- handle job
  if pl.character.job and ERP.Jobs[pl.character.job] then
    local job=ERP.Jobs[pl.character.job];

    pl:SetTeam(job:GetTeam())

    col = Vector(job.color.r/255,job.color.g/255,job.color.b/255);
  else
    pl:SetTeam(TEAM_UNASSIGNED)
  end

  -- handle color
  pl:SetWeaponColor(col)

  -- handle energy
  pl:SetEnergy(100);
end

player_manager.RegisterClass( "player_erp_default", PLAYER, "player_default" );
