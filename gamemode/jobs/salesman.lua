local JOB=ERP.Job();
JOB:SetName("Salesman");

-- TODO: Fix shitty generic description
JOB:SetDescription("Sell things to the citizens.");
JOB:SetPay(15);
JOB:SetColor(ES.Color.Amber);
JOB();
