local ITEM = ERP:Item();
ITEM:SetName("Money Printer");
ITEM:SetDescription("A printer used to illegally print cash.");
ITEM:SetModel("models/props_c17/consolebox01a.mdl");
if CLIENT then
	ITEM:AddHook("Draw",function(self)
		self.Entity:DrawModel()
		local Pos = self:GetPos()
		local Ang = self:GetAngles()
		
		local owner = self.dt.owner
		if IsValid(owner) and owner:RPNameFull() then
			owner = owner:Nick();
		else
			owner = "Undefined";
		end
		
		Ang:RotateAroundAxis(Ang:Up(), 90)
		cam.Start3D2D(Pos + Ang:Up() * 11, Ang, 1.3)
			draw.SimpleTextOutlined("+","HUDNumber5",-1,-2,Color(0,200+(math.sin(CurTime())*50),0,200),1,1,1,Color(0,0,0,255));
		cam.End3D2D()
		cam.Start3D2D(Pos + Ang:Up() * 11, Ang, 0.25)
			draw.SimpleText("CASH","DermaDefaultBold",-1,-2,Color(255,255,255,255),1,1);
		cam.End3D2D()
		
		Ang:RotateAroundAxis(Ang:Forward(), 90)
		cam.Start3D2D(Pos + Ang:Up() * 16.51 + Ang:Forward() * 12 + Ang:Right() * -8.1, Ang, 0.09)
			draw.SimpleTextOutlined("$"..tostring(0),"DermaDefault",-1,-2,Color(200,0,0),1,1,1,Color(0,0,0));
		cam.End3D2D()
		cam.Start3D2D(Pos + Ang:Up() * 16.51 + Ang:Forward() * -3 + Ang:Right() * -3.5, Ang, 0.2)
			draw.SimpleTextOutlined("Printer owned by:","DermaDefault",-1,-20,Color(255,255,255),1,1,1,Color(0,0,0));
			draw.SimpleTextOutlined(owner,"TargetID",-1,-2,Color(255,255,255),1,1,1,Color(0,0,0));
		cam.End3D2D()
	end);
elseif SERVER then
	ITEM:AddHook("Initialize",function(self)
		timer.Create("exclTimeMoney"..self:EntIndex(),230,0,function(e)
			if not e or not e:IsValid() then return; end
			
	end,self)
	end);
	ITEM:AddHook("OnRemove",function(self)
		timer.Remove("exclTimeMoney"..self:EntIndex());
	end);
end
ITEM("moneyprinter");