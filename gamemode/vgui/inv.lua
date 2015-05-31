local PNL = {}
function PNL:Init()
	self.inventory = ERP.Inventory();
  self.tileSize=52
end
function PNL:Setup(inv)
	self.inventory = inv;

	self:Update();
end
function PNL:Update()

end
function PNL:SetGridSize(x,y)
	self.gridSize = Vector(x,y,0);
	self:SetSize(x*self.tileSize,y*self.tileSize);
end
function PNL:Paint()
	draw.RoundedBox(2,0,0,self:GetWide(),self:GetTall(),ES.Color["#111"]);
	for x=0,self.gridSize.x-1,1 do
		for y=(x%2),self.gridSize.y-1,2 do

		    draw.RoundedBox(0,x*self.tileSize,y*self.tileSize,self.tileSize,self.tileSize,ES.Color["#222"]);
		end
	end
end
vgui.Register("ERP.Inventory",PNL,"Panel")
