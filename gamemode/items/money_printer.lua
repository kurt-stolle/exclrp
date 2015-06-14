local ITEM = ERP.Item();
ITEM:SetName("Money Printer");
ITEM:SetDescription("A printer used to illegally print cash.");
ITEM:SetModel("models/props_c17/consolebox01a.mdl");
ITEM:SetInventorySize(5,2)
ITEM:AddHook("SetupDataTables",function(self)
	self:NetworkVar( "Int", 0, "Money" )
end)

if CLIENT then

	ITEM:AddHook("Draw",function(self)
		self.Entity:DrawModel()
		local Pos = self:GetPos()
		local Ang = self:GetAngles()

		Ang:RotateAroundAxis(Ang:Up(), 90)
		Ang:RotateAroundAxis(Ang:Forward(), 90)
		cam.Start3D2D(Pos + Ang:Up() * 16.51 + Ang:Forward() * 12 + Ang:Right() * -8.1, Ang, 0.09)
			draw.SimpleTextOutlined("$"..self:GetMoney(),"ESDefault",-1,-2,Color(200,0,0),1,1,1,Color(0,0,0));
		cam.End3D2D()
		cam.Start3D2D(Pos + Ang:Up() * 16.51 + Ang:Forward() * -3 + Ang:Right() * -3.5, Ang, 0.2)
			draw.SimpleTextOutlined("STATUS","ESDefault-",-1,-20,Color(255,255,255),1,1,1,Color(0,0,0));
			draw.SimpleTextOutlined("Printing","ESDefaultBold",-1,-2,Color(255,255,255),1,1,1,Color(0,0,0));
		cam.End3D2D()
	end);

	ITEM:AddInteraction( "Collect", ERP.ItemInteractWithServer("Collect") );

elseif SERVER then

	ITEM:AddHook("Initialize",function(self)
		local timerTitle="ERP.Timer.MoneyPrinter."..tostring(self:EntIndex());
		timer.Create(timerTitle,60,0,function()
			if not IsValid(self) then
				timer.Remove(timerTitle);
			end
			self:SetMoney(self:GetMoney()+math.random(8,12))
		end);
		self:SetMoney(0);
	end);
	ITEM:AddHook("OnRemove",function(self)
		timer.Remove("exclTimeMoney"..self:EntIndex());
	end);

	ITEM:AddInteraction("Collect",function(self,ply)
		if not IsValid(ply) or not ply:IsPlayer() or not ply.character then return end

		ES.DebugPrint("Clearing money printer of "..ply:Nick());
		ply:GetCharacter():AddCash(self:GetMoney())
		self:SetMoney(0)
	end);

end
ITEM();
