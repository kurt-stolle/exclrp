include("shared.lua")

function ENT:Draw()
	self.Entity:DrawModel()

	local Pos = self:GetPos()
	local Ang = self:GetAngles()

	cam.Start3D2D(Pos + Ang:Up() * 0.9, Ang, 0.1)
		draw.SimpleText("$"..tostring(self:GetAmount()),"ESDefault+.Shadow",0,0,ES.Color.Black,1,1);
		draw.SimpleText("$"..tostring(self:GetAmount()),"ESDefault+.Shadow",0,-1,ES.Color.Black,1,1);
		draw.SimpleText("$"..tostring(self:GetAmount()),"ESDefault+.Shadow",0,1,ES.Color.Black,1,1);
		draw.SimpleText("$"..tostring(self:GetAmount()),"ESDefault+",0,0,ES.Color.White,1,1);
	cam.End3D2D()

	Ang:RotateAroundAxis(Ang:Right(), 180)

	cam.Start3D2D(Pos, Ang, 0.1)
		draw.SimpleText("$"..tostring(self:GetAmount()),"ESDefault+.Shadow",0,0,ES.Color.Black,1,1);
		draw.SimpleText("$"..tostring(self:GetAmount()),"ESDefault+.Shadow",0,-1,ES.Color.Black,1,1);
		draw.SimpleText("$"..tostring(self:GetAmount()),"ESDefault+.Shadow",0,1,ES.Color.Black,1,1);
		draw.SimpleText("$"..tostring(self:GetAmount()),"ESDefault+",0,0,ES.Color.White,1,1);
	cam.End3D2D()
end
