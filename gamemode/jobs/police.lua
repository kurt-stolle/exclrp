local JOB=ERP.Job()
JOB:SetName("Police");

-- TODO: Fix shitty generic description
JOB:SetDescription("Law and order is the key to a well functioning society.");
JOB:SetLoadout{"erp_weapon_baton_police"}
JOB:SetClass(JOB_GOVERNMENT);
JOB:SetPay(12);
JOB:SetColor(ES.Color.LightBlue);
JOB();
