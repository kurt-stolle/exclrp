local JOB=ERP.Job()
JOB:SetName("Police");

-- TODO: Fix shitty generic description
JOB:SetDescription("Law and order is the key to a well functioning society.");
JOB:SetLoadout{"erp_weapon_baton_police"}
JOB:SetFaction(FACTION_GOVERNMENT);
JOB:SetPay(12);
JOB:SetColor(ES.Color.LightBlue);

if CLIENT then

elseif SERVER then
  function JOB:OnSelect(ply)
    ply:GetCharacter():Save("clothing","Police armor")
  end
end

JOB();
