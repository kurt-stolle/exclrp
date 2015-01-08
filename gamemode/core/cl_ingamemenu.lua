-- ingamemenu
 
 local WHITE = Color(255,255,255);
 local BLACK = Color(0,0,0);
 
surface.CreateFont("JobFont",{

	font = "akbar";
	size = 48;

})
local PNL = {};
function PNL:Paint()
	draw.RoundedBox(4,0,0,self:GetWide(),self:GetTall(),BLACK);
	draw.SimpleText("+","HUDNumber1",self:GetWide()/2,self:GetTall()/2-2,WHITE,1,1);
end
vgui.Register("exclInGameMenuJobUpgrade", PNL, "Panel" );
local PNL = {};
function PNL:Init()
	self.Job = ERP:GetJobs()[1];
	self.Colorcenter = 70
	self.Hover = false;
end
function PNL:OnCursorEntered()
	self.Colorcenter = -10
	self.Hover = true;
end
function PNL:OnCursorExited()
	self.Colorcenter = 70;
	self.Hover= false;
end
function PNL:OnMouseReleased()
	RunConsoleCommand("excl_job",self.Job.teamn);
end
function PNL:Think()
	if self.Hover then
	self.Colorcenter = self.Colorcenter+math.sin(CurTime()*2);
	end
end
function PNL:Paint()
	draw.RoundedBoxEx(6,0,0,self:GetWide()*0.4,self:GetTall(),self.Job.color,true,false,true,false );
	draw.RoundedBoxEx(4,2,2,self:GetWide()*0.4-4,self:GetTall()-4,Color(self.Job.color.r-self.Colorcenter,self.Job.color.g-self.Colorcenter,self.Job.color.b-self.Colorcenter),true,false,true,false  );
	
	draw.RoundedBoxEx(6,self:GetWide()*0.4,0,self:GetWide()*0.6,self:GetTall(),Color(150,150,150),false,true,false,true );
	
	surface.SetDrawColor(Color(0,0,0));
	surface.SetTexture(0);
	surface.DrawPoly{
	{x=self:GetWide()*0.36,y=0},
	{x=self:GetWide()*0.4,y=self:GetTall()/2},
	{x=self:GetWide()*0.38,y=self:GetTall()/2},
	{x=self:GetWide()*0.34,y=0}};
	surface.DrawPoly{
	{x=self:GetWide()*0.4,y=self:GetTall()/2},
	{x=self:GetWide()*0.36,y=self:GetTall()},
	{x=self:GetWide()*0.34,y=self:GetTall()},
	{x=self:GetWide()*0.38,y=self:GetTall()/2}};
	surface.SetDrawColor(150,150,150);
	surface.DrawPoly{
	{x=self:GetWide()*0.35,y=0},
	{x=self:GetWide()*0.40,y=0},
	{x=self:GetWide()*0.40,y=self:GetTall()/2}};
	surface.DrawPoly{
	{x=self:GetWide()*0.40,y=self:GetTall()/2},
	{x=self:GetWide()*0.40,y=self:GetTall()},
	{x=self:GetWide()*0.35,y=self:GetTall()}};
	//skill object
	draw.RoundedBox(4,self:GetWide()-35-25,10,40,25,WHITE);
	draw.SimpleText("1","TargetID",self:GetWide()-35-(25/2),9+(25/2),BLACK,1,1);
	
	//money object
	draw.RoundedBox(4,self:GetWide()-35-25,self:GetTall()-35,50,25,WHITE);
	draw.SimpleText((self.Job.pay or "error")..",-","TargetID",self:GetWide()-15,self:GetTall()-(11+(25/2)),BLACK,2,1);
	draw.SimpleText("$","TargetID",self:GetWide()-55,self:GetTall()-(11+(25/2)),BLACK,0,1);
	//name
	draw.SimpleText(self.Job.name,"JobFont",10,self:GetTall()/2-2,WHITE,0,1);
	
	//description
	draw.DrawText(ERP:exclFormatLine(self.Job.description,"DermaDefaultBold",300),"DermaDefaultBold",self:GetWide()-80,10,BLACK,2);
end
vgui.Register("exclInGameMenuJob", PNL, "Panel" );

local menu;
usermessage.Hook("EOIERP",function()
	if menu and menu:IsValid() then
		menu:Remove();
		return;
	end

	
	menu = ERP:CreateExclFrame("In-Game control menu",0,0,700,600,true);
	menu:Center();
	menu:MakePopup()
	
	local tabs = vgui.Create("exclTabbedPanel",menu);
	tabs:SetPos(5,25);
	tabs:SetSize(menu:GetWide()-10,menu:GetTall()-30);
	tabs:AddTab("icon16/star.png","Help pages")
	tabs:AddTab("icon16/user.png","Character")
	local pnl = tabs:AddTab("icon16/world.png","Jobs");
	for k,v in pairs(ERP:GetJobs())do
		local job = vgui.Create("exclInGameMenuJob",pnl);
		job:SetPos(10,10+(k-1)*90);
		job:SetSize(pnl:GetWide()-20,80);
		job.Job = v;
		local upgrade = vgui.Create("exclInGameMenuJobUpgrade",job);
		upgrade:SetPos(job:GetWide()-35,10)
		upgrade:SetSize(25,25);
	end
	tabs:AddTab("icon16/wrench.png","Settings")
end);