-- Variables
local matrix = Matrix();
local matrixScale = Vector(0, 0, 0);
local matrixTranslation = Vector(0, 0, 0);
local menu;

-- VGUI
local PNL={}
AccessorFunc(PNL,"_text","Text",FORCE_STRING);
AccessorFunc(PNL,"_icon","Icon");
AccessorFunc(PNL,"_fn","DoClick");
function PNL:Init()
	self:SetColor(ES.Color["#1E1E1E"])
	self:SetText("Undefined")

	ES.UIInitRippleEffect(self)
end
function PNL:OnCursorEntered()
	self:SetColor(ES.Color["#282828"])
end
function PNL:OnCursorExited()
	self:SetColor(ES.Color["#1E1E1E"])
end
function PNL:PaintOver(w,h)
	ES.UIDrawRippleEffect(self,w,h)

	if self:GetIcon() then
		surface.SetDrawColor(ES.Color.White)
		surface.SetMaterial(self:GetIcon())
		surface.DrawTexturedRect(w/2 - 8, h/3-8,16,16)
	end

	draw.SimpleText(self:GetText(),"ESDefault-",w/2,3*h/4,ES.Color.White,1,1)
end
function PNL:OnMousePressed()
	ES.UIMakeRippleEffect(self)
end
function PNL:OnMouseReleased()
	if self._fn then
		self._fn();
	end
end
vgui.Register("ERP.TabMenu.Button",PNL,"esPanel")

vgui.Register("ERP.TabMenu",{
	Init = function(self)
		if IsValid(menu) then
			menu:Remove()
		end

		menu=self;

		self.scale=0;
		self.color=Color(0,0,0,0)
		self.bubbles={}
		self._applyPop=false;
	end,
	AddBubble=function(self,text,icon,fn)
		local btn=vgui.Create("ERP.TabMenu.Button",self)
		btn:SetSize(70,70)
		btn:SetVisible(false)
		btn:SetText(text)
		btn:SetIcon(icon)
		btn:SetDoClick(fn)

		table.insert(self.bubbles,btn)
	end,
	Think=function(self)
	 	self.scale = Lerp(FrameTime()*7,self.scale,1);
		self.color.a = self.scale*200;

		local c=#self.bubbles;
		for k,v in ipairs(self.bubbles)do
			v._rad=Lerp(FrameTime()*8,v._rad or 0,2*math.pi*k*(1/c));

			v.x = self:GetWide()/2 - math.sin(v._rad) * 200 - v:GetWide()/2;
			v.y = self:GetTall()/2 - math.cos(v._rad) * 200 - v:GetTall()/2;

			v:SetVisible(true);
		end
	end,
	Paint = function(self,w,h)
		mul=FrameTime()*10;

		if (self.color.a < 1) then return end

		draw.RoundedBox(0,0,0,w,h,self.color)

		local clr = Color(255,255,255,self.color.a)

		draw.SimpleText("ExclRP","ESDefault+.Shadow",w/2,h/2 - 16,self.color,1,1)
		draw.SimpleText("ExclRP","ESDefault+",w/2,h/2 - 16,clr,1,1)
		draw.SimpleText(#player.GetAll().. " Players","ESDefault-.Shadow",w/2,h/2+4,self.color,1,1)
		draw.SimpleText(#player.GetAll().. " Players","ESDefault-",w/2,h/2+4,clr,1,1)
		draw.SimpleText(game.GetMap(),"ESDefault-.Shadow",w/2,h/2 + 19,self.color,1,1)
		draw.SimpleText(game.GetMap(),"ESDefault-",w/2,h/2 + 19,clr,1,1)

		local x,y = ScrW()/2 - self.scale * ScrW()/2,ScrH()/2 - self.scale * ScrH()/2
		render.PushFilterMag( TEXFILTER.ANISOTROPIC )
		render.PushFilterMin( TEXFILTER.ANISOTROPIC )

		matrix=Matrix();
		matrixTranslation.x = x;
		matrixTranslation.y = y;
		matrix:SetTranslation( matrixTranslation )
		matrixScale.x = self.scale;
		matrixScale.y = self.scale;
		matrix:Scale( matrixScale )

		cam.PushModelMatrix( matrix )

		self._applyPop=true;
	end,
	PaintOver=function(self,w,h)
		if not self._applyPop then return end

		self._applyPop=false;

		cam.PopModelMatrix()
		render.PopFilterMag()
		render.PopFilterMin()
	end
},"Panel");

-- Scoreboard hooks
function ERP:ScoreboardShow()
	if not LocalPlayer():IsLoaded() then return end

	local _menu=vgui.Create("ERP.TabMenu")
	_menu:Dock(FILL)

	_menu:AddBubble("Scoreboard",Material("icon16/user.png"),function()
		ES.OpenUI_Playerlist()
	end)
	_menu:AddBubble("ID",Material("icon16/user_suit.png"),function()
		ERP.OpenUI_ID()
	end)
	_menu:AddBubble("Inventory",Material("icon16/user.png"),function()
		ES.OpenUI_Inventory()
	end)
	_menu:AddBubble("Job",Material("icon16/wrench.png"),function()
		ERP.OpenUI_Job()
	end)
	_menu:AddBubble("Log out",Material("icon16/world.png"),function()
		net.Start("ERP.Character.UnLoad"); net.SendToServer();
		LocalPlayer().character=nil;
	end)

	_menu:MakePopup()
end

function ERP:ScoreboardHide()
	if IsValid(menu) then
		menu:Remove()
	end
end
