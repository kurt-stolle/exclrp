local PNL = {}
AccessorFunc(PNL,"item","Item",FORCE_STRING)
ES.UIAddHoverListener(PNL)
function PNL:Init()
	ES.UIInitRippleEffect(self)
end
function PNL:Setup(item)
	if item then
		self:SetItem(item)
	end

	item = ERP.Items[item]

	if not ERP.ValidItem(item) then return ES.DebugPrint("Invalid item passed.") end

	local tileSize = self:GetParent().tileSize or 52;

	self:SetSize(item:GetInventoryWidth() * tileSize, item:GetInventoryHeight() * tileSize)

	local mdl = vgui.Create("Spawnicon",self)
	mdl:SetWide(math.max(self:GetWide(),self:GetTall()))
	mdl:SetTall(mdl:GetWide())
	mdl:SetModel(item:GetModel())
	mdl:Center();

	self.model = mdl
end
function PNL:PerformLayout()
	if IsValid(self.model) then
		self.model:Center()
	end
end
function PNL:OnMousePressed()
	ES.UIMakeRippleEffect(self)
end
local matGradient = Material("exclserver/gradient.png")
function PNL:Paint(w,h)
	surface.SetDrawColor(ES.Color["#000000AF"])
	surface.SetMaterial(matGradient)
	surface.DrawTexturedRect(0,0,w,h)
end
function PNL:PaintOver(w,h)
	if self:GetHover() then
		local clr = table.Copy(ES.GetColorScheme(2))
		clr.a = 150;
		draw.RoundedBox(2,0,0,w,h,clr)
	end

	ES.UIDrawRippleEffect(self,w,h)
end
vgui.Register("ERP.Inventory.Item",PNL,"Panel")

local PNL = {}
function PNL:Init()
	self.inventory = ERP.Inventory();
  self.tileSize=52
	self._itemPanels = {};
end
function PNL:Setup(inv)
	self.inventory = inv;

	self:Update();
end
function PNL:Update()
	for k,v in ipairs(self._itemPanels) do
		if IsValid(v) then
			v:Remove()
		end
	end
	self._itemPanels={}

	for x,_t in pairs(self.inventory:GetGrid())do
		for y,item in pairs(_t) do

			local pnl = vgui.Create("ERP.Inventory.Item",self)

			timer.Simple(0,function()
				if IsValid(pnl) then
					pnl:Setup(item)
					pnl:SetPos((x-1) * self.tileSize, (y-1) * self.tileSize)
				end
			end)

			table.insert(self._itemPanels,pnl)
		end
	end
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
