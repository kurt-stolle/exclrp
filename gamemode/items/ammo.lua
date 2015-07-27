local ITEM = ERP.Item();
ITEM:SetName("Pistol Ammo");
ITEM:SetDescription("Standard pistol ammo.");
ITEM:SetModel("models/Items/BoxSRounds.mdl");
ITEM:SetInventorySize(1,1)
ITEM:SetInventoryCamPos(Vector(0,0,32))
ITEM:SetInventoryLookAt(Vector(0,0,0))
ITEM();

game.AddAmmoType{name="Pistol Ammo",tracer=TRACER_LINE_AND_WHIZ}

local ITEM = ERP.Item();
ITEM:SetName(".357 Ammo");
ITEM:SetDescription(".357 magnum ammo.");
ITEM:SetModel("models/Items/BoxFlares.mdl");
ITEM:SetInventorySize(1,1)
ITEM:SetInventoryCamPos(Vector(0,0,32))
ITEM:SetInventoryLookAt(Vector(0,0,0))
ITEM();

game.AddAmmoType{name=".357 Ammo",tracer=TRACER_LINE_AND_WHIZ}

local ITEM = ERP.Item();
ITEM:SetName("Buckshot Ammo");
ITEM:SetDescription("A box of buckshot ammo.");
ITEM:SetModel("models/Items/BoxBuckshot.mdl");
ITEM:SetInventorySize(1,1)
ITEM:SetInventoryCamPos(Vector(0,0,32))
ITEM:SetInventoryLookAt(Vector(0,0,0))
ITEM();

game.AddAmmoType{name="Buckshot Ammo",tracer=TRACER_LINE_AND_WHIZ}

local ITEM = ERP.Item();
ITEM:SetName("SMG Ammo")
ITEM:SetDescription("Deadly SMG ammo.")
ITEM:SetModel("models/Items/BoxMRounds.mdl")
ITEM:SetInventorySize(1,1)
ITEM:SetInventoryCamPos(Vector(0,0,32))
ITEM:SetInventoryLookAt(Vector(0,0,0))
ITEM();

game.AddAmmoType{name="SMG Ammo",tracer=TRACER_LINE_AND_WHIZ}

local ITEM = ERP.Item();
ITEM:SetName("Rifle Ammo")
ITEM:SetDescription(".")
ITEM:SetModel("models/Items/BoxMRounds.mdl")
ITEM:SetInventorySize(1,1)
ITEM:SetInventoryCamPos(Vector(0,0,16))
ITEM:SetInventoryLookAt(Vector(0,0,0))
ITEM();

game.AddAmmoType{name="Rifle Ammo",tracer=TRACER_LINE_AND_WHIZ}
