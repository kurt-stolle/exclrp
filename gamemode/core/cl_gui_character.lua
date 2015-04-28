-- ingamemenu

 local WHITE = Color(255,255,255);
 local BLACK = Color(0,0,0);

surface.CreateFont("JobFont",{
	font = "Roboto";
	size = 48;
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


	menu = ERP:CreateExclFrame("Character",0,0,700,600,true);
	menu:Center();
	menu:MakePopup()

	local tabs = vgui.Create("esTabPanel",menu);
	tabs:Dock(FILL)
  tabs:DockMargin(8,8,8,8)
	local pnl = tabs:AddTab("Character","icon16/user.png")

	local pnl = tabs:AddTab("Jobs","icon16/world.png");

    local _lbl=vgui.Create("esLabel",pnl)
    _lbl:SetFont("ESDefault")
    _lbl:SetText("Jobs in ExclRP work a little different than in roleplay gamemodes you may be used to playing.\nOnce you select a job, you are expected, though not forced, to stick to it.\nYour job will save when you log out, so when you log back in you can continue where you left off.\nIf you're not sure which job is for you, pick a job that is underpopulated. This will help you gain money faster, as \nthe goods or services you can offer will not be as common as the goods or services other jobs offer.")
    _lbl:Dock(TOP)
    _lbl:SizeToContents()
    _lbl:DockMargin(10,10,10,0)
    for k,v in pairs(ERP.Jobs)do
  		local job = vgui.Create("exclInGameMenuJob",pnl);
  		job:Dock(TOP)
      job:DockMargin(10,10,10,0)
      job:SetTall(64)
  		job.Job = v;
  	end
	tabs:AddTab("Settings","icon16/wrench.png")
end);
