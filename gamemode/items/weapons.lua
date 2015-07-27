hook.Add("Initialize","exclrp.items.weapons",function()
  for k,v in ipairs(weapons.GetList()) do
    if v.GenerateItem then

      local price= ( 1 / (v.Primary.Delay or .1) ) * (v.Primary.Damage or 20) * 1.2;

      if v.Slot == 2 then
        price=price*1.8
      end

      -- The single unit
      local ITEM = ERP.Item();
      ITEM:SetName(v.PrintName);
      ITEM:SetWeapon(v.ClassName)
      ITEM:SetDescription("A "..v.PrintName.." weapon.");
      ITEM:SetModel(v.WorldModel);
      ITEM:SetValue(price)
      ITEM:DefineData("Clip1",0,"Int")

      ITEM:SetInventorySize(v.Slot == 2 and 3 or 2,v.Slot == 2 and 2 or 1)
      ITEM:SetInventoryCamPos(Vector(0,10,0))
      ITEM:SetInventoryLookAt(Vector(0,0,0))

      ITEM();

      -- The shipment
      local ITEM = ERP.Item();
      ITEM:SetName(v.PrintName.." Shipment");
      ITEM:SetDescription("A shipmeant of "..v.PrintName.." weapons.");
      ITEM:SetModel("models/Items/item_item_crate.mdl");
      ITEM:SetValue(price*8)
      ITEM:DefineData("Amount",10,"Int")


      ITEM:SetInventorySize(3,3)
      ITEM:SetInventoryCamPos(Vector(1,-1,42))
      ITEM:SetInventoryLookAt(Vector(1,-1,0))


      if CLIENT then
      	ITEM:AddHook("Draw",function(self)
      		self.Entity:DrawModel()

          local pos = self:GetPos()
          local ang = self:GetAngles()

          ang:RotateAroundAxis(ang:Up(),180)

          cam.Start3D2D(pos + ang:Up() * 23.75, ang, 0.2)
          	draw.SimpleText(ITEM:GetName(),"ESDefaultBold",-5,-70,ES.Color.Black,1,1)
            draw.SimpleText(ITEM:GetName(),"ESDefaultBold",-5,-70,ES.Color.Black,1,1)

            draw.SimpleText(self:GetAmount().." Units","ESDefault-",-5,-58,ES.Color.Black,1,1)
            draw.SimpleText(self:GetAmount().." Units","ESDefault-",-5,-58,ES.Color.Black,1,1)
          cam.End3D2D()
      	end);

      	ITEM:AddInteraction( "Take One", ERP.ItemInteractWithServer("Take One") );
      elseif SERVER then
      	ITEM:AddInteraction("Take One",function(self,ply)
      		if not IsValid(ply) or not ply:IsPlayer() or not ply:IsLoaded() then return end

          local pos,ang=self:GetPos(),self:GetAngles()

          -- Set clothing
          if self:GetAmount() <= 1 then
            self:Remove();
          else
            local amt=self:GetAmount()-1
            self:SetAmount(amt)
          end

          -- Spawn one
          ERP.Items[v.PrintName]:SpawnInWorld(pos + ang:Up() * 30,ang)
      	end);
      end

      ITEM();


    end
  end
end)
