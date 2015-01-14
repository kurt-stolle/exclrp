-- ingamemenu
 
 local WHITE = Color(255,255,255);
 local BLACK = Color(0,0,0);
 
surface.CreateFont("JobFont",{
	font = "Trebuchet MS";
	size = 32;
})

surface.CreateFont( "HUDNumber1", { 
 	font = "Arial", 
 	size = 22,
 	weight = 350
 })

surface.CreateFont( "TargetID", {
	font = "Trebuchet MS",
	size = 22,
	weight = 900,
	antialias = true,
})

local PNL = {};
function PNL:Paint()
	draw.RoundedBox(4,0,0,self:GetWide(),self:GetTall(),BLACK);
	draw.SimpleText("+","HUDNumber1",self:GetWide()/2,self:GetTall()/2-2,ES.Color["#CCC"],1,1);
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
	draw.RoundedBoxEx(4,0,0,self:GetWide()*0.4,self:GetTall(),self.Job.color,true,false,true,false );
	draw.RoundedBoxEx(2,2,2,self:GetWide()*0.4-4,self:GetTall()-4,Color(self.Job.color.r-self.Colorcenter,self.Job.color.g-self.Colorcenter,self.Job.color.b-self.Colorcenter),true,false,true,false  );
	
	draw.RoundedBoxEx(2,self:GetWide()*0.4,0,self:GetWide()*0.6,self:GetTall(),ES.Color["#DDD"],false,true,false,true );
	
	draw.RoundedBox(2,self:GetWide()-35-25,10,40,25,ES.Color["#1E1E1E"]);
	draw.SimpleText("1","TargetID",self:GetWide()-35-(25/2),9+(25/2),ES.Color["#CCC"],1,1);
	
	//money object
	draw.RoundedBox(2,self:GetWide()-35-25,self:GetTall()-35,50,25,ES.Color["#1E1E1E"]);
	draw.SimpleText((self.Job.pay or "error")..",-","TargetID",self:GetWide()-15,self:GetTall()-(11+(25/2)),ES.Color["#CCC"],2,1);
	draw.SimpleText("$","TargetID",self:GetWide()-55,self:GetTall()-(11+(25/2)),ES.Color["#CCC"],0,1);
	//name
	draw.SimpleText(self.Job.name,"JobFont",10,self:GetTall()/2-2,WHITE,0,1);
	
	//description
	draw.DrawText(ES.FormatLine(self.Job.description,"ESDefaultBold",300),"ESDefaultBold",self:GetWide()-80,10,color_black,2);
end
vgui.Register("exclInGameMenuJob", PNL, "Panel" );

local menu;
usermessage.Hook("EOIERP",function()
	if menu and menu:IsValid() then
		menu:Remove();
		return;
	end

	
	menu = ERP:CreateExclFrame("Control Menu",0,0,700,600,true);
	menu:Center();
	menu:MakePopup()
	
	local tabs = vgui.Create("esTabPanel",menu);
	tabs:SetPos(5,35);
	tabs:SetSize(menu:GetWide()-10,menu:GetTall()-40);
	tabs:AddTab("Help pages","icon16/star.png")
	tabs:AddTab("Character","icon16/user.png")
	local pnl = tabs:AddTab("Jobs","icon16/world.png");
	for k,v in pairs(ERP.Jobs)do
		local job = vgui.Create("exclInGameMenuJob",pnl);
		job:SetPos(10,10+(k-1)*90);
		job:SetSize(pnl:GetWide()-20,80);
		job.Job = v;
		local upgrade = vgui.Create("exclInGameMenuJobUpgrade",job);
		upgrade:SetPos(job:GetWide()-35,10)
		upgrade:SetSize(25,25);
	end
	tabs:AddTab("Settings","icon16/wrench.png")
end);