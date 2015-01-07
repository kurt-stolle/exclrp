-- cl_mainmenu.lua

GM.MainMenu = false;

hook.Add( "RenderScreenspaceEffects", "ERPProcessMMEffects", function()
	if GAMEMODE.MainMenu and GAMEMODE.MainMenu:IsValid()then
		local tab = {}
		tab[ "$pp_colour_addr" ] = 0
		tab[ "$pp_colour_addg" ] = 0
		tab[ "$pp_colour_addb" ] = 0
		tab[ "$pp_colour_brightness" ] = 0
		tab[ "$pp_colour_contrast" ] = 1
		tab[ "$pp_colour_colour" ] = 0
		tab[ "$pp_colour_mulr" ] = 0
		tab[ "$pp_colour_mulg" ] = 0
		tab[ "$pp_colour_mulb" ] = 0
	 
		DrawColorModify( tab )
	end
end)

local PNL = {}
function PNL:Init()
	self.m_fCreateTime = SysTime();
end
function PNL:Paint()
	Derma_DrawBackgroundBlur(self,6)

	surface.SetDrawColor(Color(0,0,0))
	surface.DrawRect(0,self:GetTall()-100,self:GetWide(),1);
	surface.DrawRect(0,self:GetTall()-250,self:GetWide(),1);
	surface.SetDrawColor(Color(255,255,255))
	surface.DrawRect(0,self:GetTall()-101,self:GetWide(),1);
	surface.DrawRect(0,self:GetTall()-249,self:GetWide(),1);
	surface.SetDrawColor(Color(30,30,30))
	surface.DrawRect(0,self:GetTall()-248,self:GetWide(),150-3);
	
	--[[draw.SimpleTextOutlined("EXCL'S","HUDNumber4",self:GetWide()-250,self:GetTall()-240,Color(0,0,0),0,0,1,Color(255,255,255,10));
	draw.SimpleTextOutlined("ROLEPLAY","HUDNumber4",self:GetWide()-250,self:GetTall()-200,Color(0,0,0),0,0,1,Color(255,255,255,10));
	
	surface.SetDrawColor(Color(0,0,0))
	surface.DrawRect(self:GetWide()-265,self:GetTall()-249,5,149);]]
end
vgui.Register( "exclMainMenuPanel", PNL, "EditablePanel" );
local PNL = {};

function PNL:Init()
	self.Title = "Unnamed";
	self.Hover = false;
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
	if self.Hover then
		draw.SimpleText("<","HUDNumber4",self:GetWide(),0,Color(0,0,0,230),2,0);
	end
	draw.SimpleText(self.Title,"HUDNumber4",self:GetWide()-30,0,Color(0,0,0,230),2,0);
end
vgui.Register( "exclMainMenuOptionButton", PNL, "Panel" );

local slideActive = false;
local slideDirection = false; //  true for right, false for left
local slideItems = {};
local onDoneSliding = function() end
local function setUpSlide(direction,items,onDone)
	slideItems = table.Copy(items);
	for k,v in pairs(slideItems)do
		v.OriginalPos = {};
		v.OriginalPos.x,v.OriginalPos.y = v:GetPos();
	end
	slideActive = true;
	slideDirection = direction;
	onDoneSliding = onDone;
end
local function Go() -- for sliding back after char is made
end
hook.Add("Think","HandleSlide",function()
	if slideActive then
		if !slideDirection then
			for k,v in pairs(slideItems)do
				if v:GetPos() < v.OriginalPos.x-ScrW()+1 then
					onDoneSliding();
					return;
				end
				v:SetPos(math.Clamp(v:GetPos()-100,v.OriginalPos.x-ScrW(),v.OriginalPos.x),v.OriginalPos.y)
			end
		else
			for k,v in pairs(slideItems)do
				if v:GetPos() > v.OriginalPos.x+ScrW()-1 then
					onDoneSliding();
					return;
				end
				v:SetPos(math.Clamp(Lerp(0.1,v:GetPos(),v.OriginalPos.x+ScrW()),v.OriginalPos.x,v.OriginalPos.x+ScrW()),v.OriginalPos.y)
			end
		end
	end
end)

local PNL = {};
function PNL:Init() end
function PNL:Paint() end
vgui.Register( "exclMainMenuEmpty", PNL, "EditablePanel" );

local randomfirst = {"Ruben","Kurt","Billy","Timmy","Peter","Steward","Stuart","Justin","Uglies","Jason","Price","Ben","Bruno","Excl","Alex","James","T-Dawg","Edward","Craig","Greg","Tom","Thomas","Niggan","Nigel","Nate","TB-Cookies","Pebbles","Chuck","Garry","Gabe","Mark","Moozle","Kay","Kaj","Kai","Werner","Harry","Charles","Charlie","Chris","Vito","Silvester","Minge","Mickey","Mick","Robin","Robert","Ardawan","Legogûy"};
local randomlast = {"Rutten","Stolle","Jean","McCarter","Selie","Jackson","Bieber","Smellyfarts","Tummyrub","Ducktown","McMac","Raider","Smits","van der sloot","Laka","Gruggles","Firing","Obeseitan","Meowingtons","irritantamerikaan","crunchy","Mooty","Saladim","Saladem","Bergsla","van Casteren","Newman","Newell","DeJeanar","Nescafe","Bajen","Sousterrain","Eaudetoilette","tomatensiroop","Spaghetti","Carbiniri","Calsonez","Stalone"};

local errorCreateTooMuch;

net.Receive("ERPOpenMainMenu",function()
	if GAMEMODE.MainMenu and GAMEMODE.MainMenu:IsValid() then
		GAMEMODE.MainMenu:Remove();
	end

	local decoded = net.ReadTable();
	
	gui.EnableScreenClicker(true);
	
	GAMEMODE.MainMenu = vgui.Create("exclMainMenuPanel");
	GAMEMODE.MainMenu:SetPos(0,0);
	GAMEMODE.MainMenu:SetSize(ScrW(),ScrH());
	
	// main items
	local slideitems = {}
	local first = randomfirst[math.random(1,#randomfirst)];
	local last = randomlast[math.random(1,#randomlast)];
	local create = vgui.Create("esButton",GAMEMODE.MainMenu);
	create:SetPos(GAMEMODE.MainMenu:GetWide() - 160,GAMEMODE.MainMenu:GetTall()-232);
	create:SetSize(150,30);
	create:SetText("Create Character");
	create.DoClick = function()
		if #decoded >= 4 then
			if not errorCreateTooMuch or not errorCreateTooMuch:IsValid() then
				errorCreateTooMuch= GAMEMODE:CreateErrorDialog("You can not create over 4 characters.");
			end
			return;
		end
		setUpSlide(false,slideitems,function()
			first = randomfirst[math.random(1,#randomfirst)];
			last = randomlast[math.random(1,#randomlast)];
		
			local modelselected=math.random(1,#GAMEMODE:GetAllowedCharacterModels());
		
			local holder = vgui.Create("exclMainMenuEmpty",GAMEMODE.MainMenu);
			holder:SetSize(GAMEMODE.MainMenu:GetWide(),GAMEMODE.MainMenu:GetTall());
			holder:SetPos(-GAMEMODE.MainMenu:GetWide(),0);
			
			local create = vgui.Create("esButton",holder);
			create:SetPos(GAMEMODE.MainMenu:GetWide()-160,GAMEMODE.MainMenu:GetTall()-232);
			create:SetSize(150,30);
			create:SetText("Create");
			create.DoClick = function()
				slideActive = false;
				slideDirection = false; //  true for right, false for left
				slideItems = {};
				onDoneSliding = function() end
				RunConsoleCommand("excl_createcharacter",first,last,GAMEMODE:GetAllowedCharacterModels()[modelselected]);
			end
			
			local dc = vgui.Create("esButton",holder);
			dc:SetPos(GAMEMODE.MainMenu:GetWide()-160,GAMEMODE.MainMenu:GetTall()-147);
			dc:SetSize(150,30);
			dc:SetText("Back");
			dc.DoClick = function() 
				setUpSlide(false,{holder},function()
					holder:Remove();
					setUpSlide(true,slideitems,function() end)
				end)
			end
			
			local model = vgui.Create("DModelPanel",holder);
			model:SetPos(0,GAMEMODE.MainMenu:GetTall()-120-400);
			model:SetModel(GAMEMODE:GetAllowedCharacterModels()[modelselected]);
			model:SetSize( 400, 400 );
			model:SetCamPos( Vector( 100,0,40 ) );
			model:SetLookAt( Vector( 0, 0,40 ) );
			model.LayoutEntity = function(self) self:RunAnimation() end // hou op met spinnen, jij gek model panel.
			local lName
			local prev = vgui.Create("esButton",holder);
			prev:SetPos(130,GAMEMODE.MainMenu:GetTall()-147);
			prev:SetSize(70,30);
			prev:SetText("Previous");
			prev.DoClick = function()
				modelselected = modelselected-1;
				if modelselected < 1 then
					modelselected = #GAMEMODE:GetAllowedCharacterModels();
				end

				model:SetModel(GAMEMODE:GetAllowedCharacterModels()[modelselected]);
			end
			lMdl = Label("Model: "..string.gsub(string.gsub(string.gsub(string.gsub(GAMEMODE:GetAllowedCharacterModels()[modelselected],"models/player/Group0",""),"1/",""),"2/",""),".mdl",""),holder);
			lMdl:SetFont("DefaultBold");
			lMdl:SetColor(Color(255,255,255,200));
			lMdl:SetPos(300,holder:GetTall()-220);
			lMdl:SizeToContents();
			local next = vgui.Create("esButton",holder);
			next:SetPos(130+10+70,GAMEMODE.MainMenu:GetTall()-147);
			next:SetSize(70,30);
			next.DoClick = function()
				modelselected = modelselected+1;
				if modelselected > #GAMEMODE:GetAllowedCharacterModels() then
					modelselected = 1;
				end

				lMdl:SetText("Model: "..string.gsub(string.gsub(string.gsub(string.gsub(GAMEMODE:GetAllowedCharacterModels()[modelselected],"models/player/Group0",""),"1/",""),"2/",""),".mdl",""));
				lMdl:SizeToContents();
				model:SetModel(GAMEMODE:GetAllowedCharacterModels()[modelselected]);
			end
			next:SetText("Next");
			
			lName = Label("Name: "..first.." "..last ,holder);
			lName:SetFont("DefaultBold");
			lName:SetColor(Color(255,255,255,200));
			lName:SetPos(300,holder:GetTall()-240);
			lName:SizeToContents();
			
			local statedit = vgui.Create("esButton",holder);
			statedit:SetPos(300,GAMEMODE.MainMenu:GetTall()-147);
			statedit:SetSize(150,30);
			statedit:SetText("Randomize Stats");
			statedit.DoClick = function()
			end
			
			local nameedit = vgui.Create("esButton",holder);
			nameedit:SetPos(300,GAMEMODE.MainMenu:GetTall()-190);
			nameedit:SetSize(150,30);
			nameedit:SetText("Customize Name");
			nameedit.DoClick = function()
				local pnlName = GAMEMODE:CreateExclFrame("Edit name",1,1,225,120,true);
				pnlName:Center();
				pnlName:MakePopup();
				local firstText;
				local lastText;
				local accept = vgui.Create("esButton",pnlName);
				accept:SetText("Accept");
				accept:SetSize(pnlName:GetWide()-10,30);
				accept:SetPos(5,pnlName:GetTall()-35);

				local l = Label("First:",pnlName);
				l:SetPos(10,38);
				l:SetColor(Color(200,200,200));
				l:SizeToContents();
				local l = Label("Last:",pnlName);
				l:SetPos(10,58);
				l:SetColor(Color(200,200,200));
				l:SizeToContents();

				local firstText = vgui.Create("DTextEntry", pnlName)
				firstText:SetText(first)
				firstText:SetSize(pnlName:GetWide()-40-5,17)
				firstText:SetPos(40,37);
				firstText.OnEnter = function(self) if IsValid(lastText) then lastText:RequestFocus() end  end
				local lastText = vgui.Create("DTextEntry", pnlName)
				lastText:SetText(last)
				lastText:SetSize(pnlName:GetWide()-40-5,17)
				lastText:SetPos(40,57);
				lastText.OnEnter = function(self) if IsValid(accept) then accept:DoClick() end end

				accept.DoClick = function(self)
					if IsValid(firstText) and IsValid(lastText) then
					
						first = firstText:GetValue();
						last = lastText:GetValue();

						if IsValid(lName) then
							lName:SetText("Name: "..first.." "..last);
							lName:SizeToContents();
						end

						pnlName:Close();

					end
				end
			end
			
			
			setUpSlide(true,{holder},function() end)
		end)
	end
	table.insert(slideitems,create);
	
	local settings = vgui.Create("esButton",GAMEMODE.MainMenu);
	settings:SetPos(GAMEMODE.MainMenu:GetWide()-160,GAMEMODE.MainMenu:GetTall()-190);
	settings:SetSize(150,30);
	settings:SetText("Settings");
	table.insert(slideitems,settings);
	
	local dc = vgui.Create("esButton",GAMEMODE.MainMenu);
	dc:SetPos(GAMEMODE.MainMenu:GetWide()-160,GAMEMODE.MainMenu:GetTall()-147);
	dc:SetSize(150,30);
	dc.Red = true;
	dc:SetText("Disconnect");
	table.insert(slideitems,dc);
	
	// characters
	
	for k,v in pairs(decoded)do
		local model = vgui.Create("DModelPanel",GAMEMODE.MainMenu);
		model:SetPos((k-1)*200,GAMEMODE.MainMenu:GetTall()-120-400);
		model:SetModel(v.model);
		model:SetSize( 400, 400 );
		model:SetCamPos( Vector( 100,0,40 ) );
		model:SetLookAt( Vector( 0, 0,40 ) );
		local button;
		table.insert(slideitems,model);
		timer.Simple(0,function()
			button = vgui.Create("esButton",GAMEMODE.MainMenu);
			local x,y = model:GetPos();
			button:SetPos(x+200-70,GAMEMODE.MainMenu:GetTall()-147); // y same as dc.pos.y
			button:SetSize(150,30);
			button:SetText("Select");
			button.DoClick = function()
				RunConsoleCommand("excl_selectcharacter",v.id);
			end
			table.insert(slideitems,button);
		end)
		model.LayoutEntity = function(self) 
			if IsValid(button) and button.Hover then
				self:RunAnimation();
			end
		end
		
		local x,y = model:GetPos();
		local l = Label(v.firstname.." "..v.lastname,GAMEMODE.MainMenu);
		l:SetFont("TabLarge");
		surface.SetFont("TabLarge");
		l:SetPos(x+200-surface.GetTextSize(v.firstname.." "..v.lastname)/2,y+60);
		l:SizeToContents();
		table.insert(slideitems,l);
	end
end)
usermessage.Hook("ECreateDone",function()
	Go();
end);