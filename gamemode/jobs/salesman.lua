local JOB=ERP.Job();
JOB:SetName("Salesman");

-- TODO: Fix shitty generic description
JOB:SetDescription("Sell things to the citizens.");
JOB:SetPay(15);
JOB:SetColor(ES.Color.Amber);

if CLIENT then

elseif SERVER then
  function JOB:OnSelect(ply)
    ply:GetCharacter():Save("clothing","Standard outfit")
  end
end

JOB();
