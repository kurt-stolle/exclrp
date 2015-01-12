-- cl_vgui.lua
local PNL = {}
function PNL:Paint()
	draw.RoundedBox(0,0,0,self:GetWide(),self:GetTall(),Color(255,255,255,5));
	draw.RoundedBox(0,1,1,self:GetWide()-2,self:GetTall()-2,ES.Color["#111"]);
end
vgui.Register("exclPanel",PNL,"EditablePanel")

local PNL = {};

function PNL:Init()
	self.Char = "x";
	self.Red = false;
	self.Hover = false;
	self.PaintHook = function() end
	self.DoClick = function() end
end
function PNL:OnCursorEntered()
	self.Hover = true;
end
function PNL:OnCursorExited()
	self.Hover = false;
end
function PNL:OnMouseReleased()
	self:DoClick()
end
function PNL:Paint()
	draw.RoundedBoxEx(4,0,0,self:GetWide(),self:GetTall(),Color(220,0,0),false,false,true,true);
	if not self.Hover then
		draw.RoundedBoxEx(4,1,0,self:GetWide()-2,self:GetTall()-1,Color(255,255,255,10),false,false,true,true);
	end
	draw.SimpleTextOutlined(self.Char,"DermaDefaultBold",self:GetWide()/2,self:GetTall()/2-2,Color(255,255,255,255),1,1,1,Color(0,0,0,100));

	self.PaintHook();
end
vgui.Register( "exclCloseButton", PNL, "Panel" );

local PNL = {};

function PNL:Init()
	self.Title = "Unnamed";
	self.Red = false;
	self.PaintHook = function() end
	if self.ShowCloseButton then
		self:ShowCloseButton(false);
	end
	if self.btnClose then
		self.btnClose:Remove();
		self.btnMaxim:Remove();
		self.btnMinim:Remove();
	end
	
	self:SetTitle( "" )
	function self:SetTitle(title)
		self.Title = title;
	end
	self.PerformLayout = function() end
	
end
function PNL:Center()
	self:SetPos(ScrW()/2 - self:GetWide()/2, ScrH()/2 - self:GetTall()/2);
end
function PNL:Paint()
	surface.SetDrawColor(Color(0,0,0,200));
	surface.DrawRect(0,20,self:GetWide(),self:GetTall()-20);
	surface.SetDrawColor(Color(0,0,0,255));
	surface.DrawRect(0,20,2,self:GetTall()-20);
	surface.DrawRect(self:GetWide()-2,20,2,self:GetTall()-20);
	surface.DrawRect(2,self:GetTall()-2,self:GetWide()-4,2);
	
	draw.RoundedBoxEx(2,0,0,self:GetWide(),20,Color(0,0,0),true,true,false,false);
	draw.RoundedBox(2,1,1,self:GetWide()-2,18,Color(255,255,255,3),true,true,false,false);
	draw.RoundedBox(2,2,2,self:GetWide()-4,8,Color(255,255,255,2),true,true,false,false);
	draw.SimpleTextOutlined(self.Title,"DermaDefaultBold",self:GetWide()/2,9,Color(255,255,255,255),1,1,1,Color(0,0,0));
	
	self.PaintHook();
end
vgui.Register( "exclFrame", PNL, "DFrame" );

local PNL = {};

function PNL:Init()
	self.Title = "Unnamed";
	self.Red = false;
	self.Hover = false;
	self.PaintHook = function() end
	self.DoClick = function() end;
end
function PNL:OnCursorEntered()
	self.Hover = true;
end
function PNL:OnCursorExited()
	self.Hover = false;
end
function PNL:OnMouseReleased()
	self:DoClick()
end
function PNL:Paint()
	if self.Red then
		draw.RoundedBox(6,0,0,self:GetWide(),self:GetTall(),Color(0,0,0));
		draw.RoundedBox(6,1,1,self:GetWide()-2,self:GetTall()-2,Color(100,0,0));
		if self.Hover then
			draw.RoundedBox(6,1,1,self:GetWide()-2,self:GetTall()-2,Color(200+math.sin(CurTime()*3)*50,0,0));
		end
	else
		draw.RoundedBox(6,0,0,self:GetWide(),self:GetTall(),Color(0,0,0));
		if self.Hover then
			draw.RoundedBox(6,1,1,self:GetWide()-2,self:GetTall()-2,Color(0,0,100+math.sin(CurTime()*3)*50));
		end
	end
	draw.RoundedBox(4,2,2,self:GetWide()-4,self:GetTall()/2 - 2,Color(255,255,255,2));
	draw.SimpleTextOutlined(self.Title,"DermaDefaultBold",self:GetWide()/2,self:GetTall()/2-1,Color(255,255,255,255),1,1,1,Color(0,0,0));
	
	self.PaintHook();
end
vgui.Register( "exclButton", PNL, "Panel" );

local PNL = {};
function PNL:Init() end
function PNL:Draw() end
vgui.Register( "exclInvisiblePanel", PNL, "Panel" );

local PNL = {};

function PNL:Init()
	self.Title = "Unnamed";
	self.Icon = "gui/silkicons/car";
	self.Red = false;
	self.Hover = false;
	self.Position = 1;
	self.Selected = false;
	self.PaintHook = function() end
	self.DoClick = function() end;
end
function PNL:OnCursorEntered()
	self.Hover = true;
end
function PNL:OnCursorExited()
	self.Hover = false;
end
function PNL:OnMouseReleased()
	self:DoClick()
end
function PNL:Paint(w,h)
	draw.RoundedBox(0,0,0,self:GetWide(),self:GetTall(),Color(0,0,0,200));

	if not self.Selected then
		draw.RoundedBox(0,1,1,self:GetWide()-2,self:GetTall()-1,ES.GetColorScheme(3));
		draw.SimpleText(self.Title,"ESDefaultBold",6 + 16 + 6,self:GetTall()/2,ES.Color["#EEE"],0,1);
	end
	if self.Hover or self.Selected then
		draw.RoundedBox(0,1,1,self:GetWide()-2,self:GetTall()-1,ES.GetColorScheme(1));
		draw.SimpleText(self.Title,"ESDefaultBold",6 + 16 + 6,self:GetTall()/2,Color(255,255,255,255),0,1);
	end

	surface.SetMaterial(self.Icon);
	surface.SetDrawColor(Color(255,255,255,255));
	surface.DrawTexturedRect(6,(h/2) - (16/2),16,16) ;
	
	
	self.PaintHook();
end
vgui.Register( "exclTabbedButton", PNL, "Panel" );

local PNL = {};
function PNL:Init()
	self.PaintHook = function() end
	self.Tabs = {}
end
function PNL:AddTab(icon,title)
	local p = vgui.Create("exclInvisiblePanel",self)
	p:SetSize(self:GetWide(),self:GetTall()-30);
	p:SetPos(0,24);
	table.insert(self.Tabs,p);
	p:SetVisible(#self.Tabs==1);
	local b = vgui.Create("exclTabbedButton",self);
	b:SetSize(150,24);
	b:SetPos((#self.Tabs-1)*148,0);
	b.Position = #self.Tabs;
	b.Selected = (#self.Tabs == 1);
	b.Icon = Material(icon or "icon16/car.png");
	b.Title = title or "Untitled";
	b.DoClick = function()
		for k,v in pairs(self.Tabs)do
			if b.Position != v.button.Position then
				v:SetVisible(false);
				v.button.Selected=false;
			end
		end
		p:SetVisible(true);
		b.Selected = true;
	end
	p.button = b;
	
	return p;
end
function PNL:Paint(w,h)
	surface.SetDrawColor(ES.Color.Black);
	surface.DrawRect(0,23,w,h-23);
	surface.SetDrawColor(ES.GetColorScheme(1));
	surface.DrawRect(1,24,w-2,h-25);
	surface.SetDrawColor(ES.Color["#1E1E1E"]);
	surface.DrawRect(2,25,w-4,h-27);

	self.PaintHook();
end
vgui.Register( "exclTabbedPanel", PNL, "Panel" );

function ERP:CreateExclFrame(title,x,y,w,h,closeable) -- let's make it all more simple
	local p = vgui.Create("esFrame");
	p:SetSize(w,h);
	p:SetPos(x,y);
	p.Title = title;
--[[	if closeable then
		p.closebutton = vgui.Create("exclCloseButton",p);
		p.closebutton:SetPos(p:GetWide()-32,1);
		p.closebutton:SetSize(22,16);
		function p.closebutton:DoClick()
			self:GetParent():Remove();
		end
	end--]]
	
	return p;
end
function ERP:CreateErrorDialog(text,onDone)
	onDone = onDone or function() end
	local f =ERP:CreateExclFrame("An error occured",1,1,200,100,false);
	f:Center();
	f:MakePopup();
	local b =vgui.Create("esButton",f)
	b:SetPos(5,f:GetTall()-35);
	b:SetSize(f:GetWide()-10,30);
	b:SetText("Okay");
	b.DoClick = function()
		onDone();
		f:Remove();
	end
	local l=Label(text,f)
	l:Center();
	l:SizeToContents();
	l:SetPos(l:GetPos(),30)
	l:SetColor(Color(255,255,255));
	
	f:SetBackgroundBlur(true);
	return f;
end

local testpanel;
concommand.Add("testvgui",function()
	if testpanel and testpanel:IsValid() then gui.EnableScreenClicker(false); testpanel:Remove(); return; end
	
	gui.EnableScreenClicker(true);
	
	testpanel = ERP:CreateExclFrame("Testing",0,0,300,150,true);
	testpanel:Center();
	
	local buttona = vgui.Create("exclButton",testpanel);
	buttona:SetSize(100,25);
	buttona:SetPos(50,120);
	local buttonb = vgui.Create("exclButton",testpanel);
	buttonb:SetSize(100,25);
	buttonb:SetPos(50+100+10,120);
	buttonb.Red = true;
end);