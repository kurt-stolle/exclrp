local JOB=ERP.Job()
JOB:SetName("Gangster");

-- TODO: Fix shitty generic description
JOB:SetDescription("Crime pays! The professional criminal is the job for the citizen who wants to walk a dark path.");

JOB:SetFaction(FACTION_CRIME);
JOB:SetPay(8);
JOB:SetColor(ES.Color.Red);

if CLIENT then

elseif SERVER then
  function JOB:OnSelect(ply)
    ply:GetCharacter():Save("clothing","Standard Armor")
  end
end

JOB();
