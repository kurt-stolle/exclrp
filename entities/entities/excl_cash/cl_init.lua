include("shared.lua")

function ENT:Draw()
	self.Entity:DrawModel()
	
	local Pos = self:GetPos()
	local Ang = self:GetAngles()
	
	cam.Start3D2D(Pos + Ang:Up() * 0.9, Ang, 0.1)
		draw.SimpleTextOutlined("$"..tostring(self:GetAmount()),"HudHintTextLarge",0,0,Color(255,255,255),1,1,1,Color(0,0,0));
	cam.End3D2D()

	Ang:RotateAroundAxis(Ang:Right(), 180)
	
	cam.Start3D2D(Pos, Ang, 0.1)
		draw.SimpleTextOutlined("$"..tostring(self:GetAmount()),"HudHintTextLarge",0,0,Color(255,255,255),1,1,1,Color(0,0,0));
	cam.End3D2D()
end