local ITEM = ERP.Item();
ITEM:SetName("Plant Pot");
ITEM:SetDescription("Can be used to grow weeds. Combine with seeds.");
ITEM:SetModel("models/props_junk/terracotta01.mdl");

ITEM:SetInventorySize(2,2)
ITEM:SetInventoryCamPos(Vector(0,0,30))
ITEM:SetInventoryLookAt(Vector(0,0,0))

ITEM:AddHook("SetupDataTables",function(self)
  self:NetworkVar("Int",0,"GrowStage")
end)

ITEM:AddHook("Initialize",function(self)
  self:SetGrowStage(0)
end)

if CLIENT then
  local growStageModels={
    ClientsideModel("models/Weed/weedplant_xxsmall_a.mdl"),
    ClientsideModel("models/Weed/weedplant_xsmall_a.mdl"),
    ClientsideModel("models/Weed/weedplant_small_a.mdl"),
    ClientsideModel("models/Weed/weedplant_medium_a.mdl"),
    ClientsideModel("models/Weed/weedplant_big_a.mdl")
  }

  for k,v in ipairs(growStageModels)do
    v:SetNoDraw(true)
  end

	ITEM:AddHook("Draw",function(self)
    local cMdl=growStageModels[self:GetGrowStage()]

    if cMdl then
      cMdl:SetRenderOrigin(self:GetPos() + self:GetAngles():Up() * 10)
      cMdl:SetRenderAngles(self:GetAngles())
      cMdl:DrawModel()
      cMdl:SetRenderOrigin()
      cMdl:SetRenderAngles()
    end

		self.Entity:DrawModel()
	end);

  ITEM:AddInteraction( "Harvest", ERP.ItemInteractWithServer("Harvest") );
elseif SERVER then
  ITEM:DefineCombination("Weed Seeds",function(self)
    self:SetGrowStage(1)

    local timername="ERP.Item.Weed.Next."..self:EntIndex()
    timer.Create(timername,ERP.Config["weed_grow_time"],4,function(self)
      if not IsValid(self) then
        timer.Remove(timername)
        return
      end

      self:SetGrowStage(self:GetGrowStage()+1)
    end)
  end)

  ITEM:AddInteraction("Harvest",function(self,ply)
		if not IsValid(ply) or not ply:IsPlayer() or not ply.character then return end

    if self:GetGrowStage() < 5 then
      ply:CreateErrorDialog(self:GetGrowStage() == 0 and "Add some seeds and grow a plant before you harvest" or "The plant is not ready for harvest yet.")
      return
    end

		ES.DebugPrint("Jarvesting weed of "..ply:Nick());

    local char=ply:GetCharacter()
    local weed=ERP.Items["D4NK W33D"]
    local x,y = char:GetInventory():FitItem(weed)
    if x<1 or y<1 then
      weed:SpawnInWorld(self:GetPos() + self:GetAngles():Up() * 10,self:GetAngles())
    else
      char:GiveItem(weed,x,y)
    end

    self:SetGrowStage(0)
	end);
end
ITEM();
