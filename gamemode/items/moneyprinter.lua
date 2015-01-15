local ITEM = ERP.Item();
ITEM:SetName("Money Printer");
ITEM:SetDescription("A printer used to illegally print cash.");
ITEM:SetModel("models/props_c17/consolebox01a.mdl");
if CLIENT then
	ITEM:AddHook("Draw",function(self)
		self.Entity:DrawModel()
		local Pos = self:GetPos()
		local Ang = self:GetAngles()
		
		local owner = self:GetOwner()
		if IsValid(owner) and owner.character and owner.character:GetFullName() then
			owner = owner.character:GetFullName();
		else
			owner = "Undefined";
		end

		Ang:RotateAroundAxis(Ang:Up(), 90)
		Ang:RotateAroundAxis(Ang:Forward(), 90)
		cam.Start3D2D(Pos + Ang:Up() * 16.51 + Ang:Forward() * 12 + Ang:Right() * -8.1, Ang, 0.09)
			draw.SimpleTextOutlined("$"..tostring(0),"ESDefault",-1,-2,Color(200,0,0),1,1,1,Color(0,0,0));
		cam.End3D2D()
		cam.Start3D2D(Pos + Ang:Up() * 16.51 + Ang:Forward() * -3 + Ang:Right() * -3.5, Ang, 0.15)
			draw.SimpleTextOutlined("Printer owned by:","ESDefault",-1,-20,Color(255,255,255),1,1,1,Color(0,0,0));
			draw.SimpleTextOutlined(owner,"ESDefaultBold",-1,-2,Color(255,255,255),1,1,1,Color(0,0,0));
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
ITEM();