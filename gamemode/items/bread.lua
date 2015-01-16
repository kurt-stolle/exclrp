local ITEM = ERP.Item();
ITEM:SetName("Bread")
ITEM:SetDescription("A loaf of bread, used to restore 20 energy")	
ITEM:SetModel("models/weapons/c_items/c_bread_plainloaf.mdl")

if CLIENT then
	ITEM:AddHook("Draw", function(self)
		self.Entity:DrawModel()	
		local Pos = self:GetPos()
		local Ang = self:GetAngles()
		local Ang2 = self:GetAngles()
		local TextAng2 = Ang2
		local TextAng = Ang
		Ang:RotateAroundAxis(Ang:Forward(), 90)
		TextAng:RotateAroundAxis(TextAng:Right(), 0)

		Ang2:RotateAroundAxis(Ang:Forward(), 90)
		TextAng2:RotateAroundAxis(TextAng:Right(), 180)


		cam.Start3D2D(Pos + Ang:Right() * -11, TextAng, 0.21)
				draw.SimpleTextOutlined( 'Consumable', "Default", 0, 0, Color( 178, 73, 174, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255))
		--		draw.SimpleTextOutlined( 'Ingredient', "Default", 0, 0, Color( 255, 113, 126, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255))	
			--	draw.SimpleTextOutlined( 'Bread', "Default", 0, 0, Color( 255, 255, 255, 170 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255))
		cam.End3D2D()
		cam.Start3D2D(Pos + Ang:Right() * -15, TextAng, 0.21)
				draw.SimpleTextOutlined( 'Bread', "Default", 0, 0, Color( 255, 255, 255, 170 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255))
		cam.End3D2D()

		cam.Start3D2D(Pos + Ang2:Right() * -11, TextAng2, 0.21)
				draw.SimpleTextOutlined( 'Consumable', "Default", 0, 0, Color( 178, 73, 174, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255))
				--draw.SimpleTextOutlined( 'Ingredient', "Default", 0, 0, Color( 255, 113, 126, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255))	
		--		draw.SimpleTextOutlined( 'Bread', "Default", 0, 0, Color( 255, 255, 255, 170 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255))
		cam.End3D2D()
		cam.Start3D2D(Pos + Ang2:Right() * -15, TextAng2, 0.21)
				draw.SimpleTextOutlined( 'Bread', "Default", 0, 0, Color( 255, 255, 255, 170 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255))
		cam.End3D2D()
	end);
elseif SERVER then
	ITEM:AddHook("Initialize", function(self)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		local phys = self:GetPhysicsObject()
		phys:Wake()
	end);

	ITEM:AddHook("Use", function(activator, caller)
		local energy = activator:ESGetNetworkedVariable("energy",100);
		activator:ESSetNetworkedVariable("energy", math.Clamp(energy + 5,0,100))
		self:Remove()
	--	activator:EmitSound("", 100, 100) TODO: Eating Sound
	end);
end

ITEM();