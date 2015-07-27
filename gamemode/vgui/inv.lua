local PNL = {}
AccessorFunc(PNL,"item","Item",FORCE_STRING)
ES.UIAddHoverListener(PNL)
function PNL:Init()
	ES.UIInitRippleEffect(self)
	self.itempos = Vector(-1,-1,0)

	self.color_highlight = table.Copy(ES.GetColorScheme(3))
	self.color_highlight.a = 0
end
function PNL:Setup(item,x,y) -- item name!
	if item then
		self:SetItem(item)
	end

	item = ERP.Items[item]

	if not ERP.ValidItem(item) then return ES.DebugPrint("Invalid item passed.") end

	self.itempos.x = x;
	self.itempos.y = y;

	local tileSize = self:GetParent().tileSize or 52;

	self:SetSize(item:GetInventoryWidth() * tileSize, item:GetInventoryHeight() * tileSize)

	local mdl = vgui.Create("DModelPanel",self)
	mdl:SetWide(math.max(self:GetWide()-2,self:GetTall()-2))
	mdl:SetTall(mdl:GetWide())
	mdl:SetModel(item:GetModel())
	mdl:SetLookAt(item:GetInventoryLookAt())
	mdl:SetCamPos(item:GetInventoryCamPos())
	mdl:SetAnimated(false)
	mdl.LayoutEntity=function()end
	mdl:SetFOV(90)
	mdl:Center();
	mdl:SetMouseInputEnabled(false)

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
function PNL:OnMouseReleased()
	self:GetParent():OnItemSelected(self.item,self.itempos.x,self.itempos.y)
end
local matGradient = Material("exclserver/gradient.png")
function PNL:Paint(w,h)
	surface.SetDrawColor(self.color_highlight)
	surface.DrawRect(0,0,w,h)

end
function PNL:Think()
	self.color_highlight.a = Lerp(FrameTime()*4,self.color_highlight.a,self:GetHover() and 255 or 0)
end
function PNL:PaintOver(w,h)
	local txt = string.gsub(ERP.Items[self:GetItem()]:GetName()," ","\n")

	draw.DrawText(txt,"ESDefault",4,4,ES.Color.White)

		surface.SetDrawColor(ES.GetColorScheme(3))
		surface.DrawRect(1,1,w-2,2)
		surface.DrawRect(1,h-3,w-2,2)
		surface.DrawRect(1,2,2,h-4)
		surface.DrawRect(w-3,2,2,h-4)

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
	ES.DebugPrint("Inventory panel setup")

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
			item=item.item

			local pnl = vgui.Create("ERP.Inventory.Item",self)

			timer.Simple(0,function()
				if IsValid(pnl) then
					pnl:Setup(item,x,y)
					pnl:SetPos((x-1) * self.tileSize, (y-1) * self.tileSize)
				end
			end)

			table.insert(self._itemPanels,pnl)
		end
	end
end
function PNL:OnItemSelected(item,x,y)
	-- override me
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
