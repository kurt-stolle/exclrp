local ITEM = ERP.Item();
ITEM:SetName("Pistol Ammo");
ITEM:SetValue(60)
ITEM:SetDescription("Standard pistol ammo.");
ITEM:SetModel("models/Items/BoxSRounds.mdl");
ITEM:SetInventorySize(1,1)
ITEM:SetInventoryCamPos(Vector(0,0,32))
ITEM:SetInventoryLookAt(Vector(0,0,0))
ITEM();

game.AddAmmoType{name="Pistol Ammo",tracer=TRACER_LINE_AND_WHIZ}

local ITEM = ERP.Item();
ITEM:SetName(".357 Ammo");
ITEM:SetValue(70)
ITEM:SetDescription(".357 magnum ammo.");
ITEM:SetModel("models/items/357ammobox.mdl");
ITEM:SetInventorySize(1,1)
ITEM:SetInventoryCamPos(Vector(0,0,32))
ITEM:SetInventoryLookAt(Vector(0,0,0))
ITEM();

game.AddAmmoType{name=".357 Ammo",tracer=TRACER_LINE_AND_WHIZ}

local ITEM = ERP.Item();
ITEM:SetName("Buckshot Ammo");
ITEM:SetValue(90)
ITEM:SetDescription("A box of buckshot ammo.");
ITEM:SetModel("models/Items/BoxBuckshot.mdl");
ITEM:SetInventorySize(1,1)
ITEM:SetInventoryCamPos(Vector(0,0,32))
ITEM:SetInventoryLookAt(Vector(0,0,0))
ITEM();

game.AddAmmoType{name="Buckshot Ammo",tracer=TRACER_LINE_AND_WHIZ}

local ITEM = ERP.Item();
ITEM:SetName("SMG Ammo")
ITEM:SetValue(80)
ITEM:SetDescription("Deadly SMG ammo.")
ITEM:SetModel("models/Items/BoxMRounds.mdl")
ITEM:SetInventorySize(1,1)
ITEM:SetInventoryCamPos(Vector(0,0,32))
ITEM:SetInventoryLookAt(Vector(0,0,0))
ITEM();

game.AddAmmoType{name="SMG Ammo",tracer=TRACER_LINE_AND_WHIZ}

local ITEM = ERP.Item();
ITEM:SetName("Rifle Ammo")
ITEM:SetValue(100)
ITEM:SetDescription(".")
ITEM:SetModel("models/items/ammopack_medium.mdl")
ITEM:SetInventorySize(1,1)
ITEM:SetInventoryCamPos(Vector(0,30,0))
ITEM:SetInventoryLookAt(Vector(0,0,0))
ITEM();

game.AddAmmoType{name="Rifle Ammo",tracer=TRACER_LINE_AND_WHIZ}
