-- cl_mainmenu.lua

ERP.MainMenu = false;

local color_outline=Color(255,255,255,5);

surface.CreateFont("TabLarge", {
	font = "Roboto",
	size = 13,
	weight = 700,
	shadow = true,
})

hook.Add( "RenderScreenspaceEffects", "ERP.MM.PostProcess", function()
	if IsValid(ERP.MainMenu) then
		local tab = {}
		tab[ "$pp_colour_addr" ] = 0
		tab[ "$pp_colour_addg" ] = 0
		tab[ "$pp_colour_addb" ] = 0
		tab[ "$pp_colour_brightness" ] = 0
		tab[ "$pp_colour_contrast" ] = 1
		tab[ "$pp_colour_colour" ] = 0.1
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
	Derma_DrawBackgroundBlur(self,self.m_fCreateTime)

	surface.SetDrawColor(color_outline)
	surface.DrawRect(0,self:GetTall()-101,self:GetWide(),1);
	surface.DrawRect(0,self:GetTall()-249,self:GetWide(),1);
	surface.SetDrawColor(ES.Color["#1E1E1E"])
	surface.DrawRect(0,self:GetTall()-248,self:GetWide(),150-3);
end
vgui.Register( "exclMainMenuPanel", PNL, "EditablePanel" );
local PNL = {};

function PNL:Init()
	self.title = "Unnamed";
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
	draw.SimpleText(self.title,"HUDNumber4",self:GetWide()-30,0,Color(0,0,0,230),2,0);
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
				if not IsValid(v) then continue end

				if v:GetPos() > v.OriginalPos.x+ScrW()-1 then
					onDoneSliding();
					return;
				end
				v:SetPos(math.Clamp(Lerp(0.1,v:GetPos(),v.OriginalPos.x+ScrW()),v.OriginalPos.x,v.OriginalPos.x+ScrW()),v.OriginalPos.y)
			end
		end
	end
end)

local function genFirstName()
	return table.Random{"Ruben","Kurt","Billy","Timmy","Peter","Steward","Stuart","Justin","Uglies","Jason","Price","Ben","Bruno","Alex","James","T-Dawg","Edward","Craig","Greg","Tom","Thomas","Niggan","Nigel","Nate","DJ","Pebbles","Chuck","Garry","Gabe","Mark","Moozle","Kaj","Harry","Charles","Charlie","Chris","Vito","Silvester","Minge","Mickey","Mick","Robin","Robert","Ardawan"};
end

local function genLastName()
	local parts={"malo","zak","abo","wonk","sto","le","foo","bar","nig","ger","ten","tan","ver"}
	local suffixes={"son","li","ssen","kor",""}
	local syl=math.random(1,3)
	local name="";
	for i=1,syl,1 do
		local rnd=math.random(1,#parts)
		name=name..parts[rnd];
		table.remove(parts,rnd);
	end
	name=name..table.Random(suffixes)
	name=string.upper(string.Left(name,1))..string.Right(name,string.len(name)-1);
	return name
end

local errorCreateTooMuch;

net.Receive("ERP.Character.OpenMenu",function()
	if IsValid(ERP.MainMenu) then
		ERP.MainMenu:Remove();
	end

	local decoded = net.ReadTable();

	ERP.MainMenu = vgui.Create("exclMainMenuPanel");
	ERP.MainMenu:SetPos(0,0);
	ERP.MainMenu:SetSize(ScrW(),ScrH());

	// main items
	local slideitems = {}
	local create = vgui.Create("esButton",ERP.MainMenu);
	create:SetPos(ERP.MainMenu:GetWide() - 160,ERP.MainMenu:GetTall()-232);
	create:SetSize(150,30);
	create:SetText("Create Character");
	create.DoClick = function()
		if #decoded >= 4 then
			if not errorCreateTooMuch or not errorCreateTooMuch:IsValid() then
				errorCreateTooMuch= ERP:CreateErrorDialog("You can not create over 4 characters.");
			end
			return;
		end
		setUpSlide(false,slideitems,function()
			local first = genFirstName();
			local last = genLastName();

			local modelselected=math.random(1,#ERP.GetAllowedCharacterModels());

			local holder = vgui.Create("EditablePanel",ERP.MainMenu);
			holder:SetSize(ERP.MainMenu:GetWide(),ERP.MainMenu:GetTall());
			holder:SetPos(-ERP.MainMenu:GetWide(),0);

			local create = vgui.Create("esButton",holder);
			create:SetPos(ERP.MainMenu:GetWide()-160,ERP.MainMenu:GetTall()-232);
			create:SetSize(150,30);
			create:SetText("Create");
			create.DoClick = function()
				slideActive = false;
				slideDirection = false; //  true for right, false for left
				slideItems = {};
				onDoneSliding = function() end

				net.Start("ERP.Character.New");
				net.WriteString(first);
				net.WriteString(last);
				net.WriteUInt(modelselected,8);
				net.SendToServer();
			end

			local dc = vgui.Create("esButton",holder);
			dc:SetPos(ERP.MainMenu:GetWide()-160,ERP.MainMenu:GetTall()-147);
			dc:SetSize(150,30);
			dc:SetText("Back");
			dc.DoClick = function()
				setUpSlide(false,{holder},function()
					holder:Remove();
					setUpSlide(true,slideitems,function() end)
				end)
			end

			local model = vgui.Create("DModelPanel",holder);
			model:SetPos(0,ERP.MainMenu:GetTall()-120-400);
			model:SetModel(ERP.GetAllowedCharacterModels()[modelselected]);
			model:SetSize( 400, 400 );
			model:SetCamPos( Vector( 100,0,40 ) );
			model:SetLookAt( Vector( 0, 0,40 ) );
			model.LayoutEntity = function(self) self:RunAnimation() end // hou op met spinnen, jij gek model panel.
			local lName
			local prev = vgui.Create("esButton",holder);
			prev:SetPos(130,ERP.MainMenu:GetTall()-147);
			prev:SetSize(70,30);
			prev:SetText("Previous");
			prev.DoClick = function()
				modelselected = modelselected-1;
				if modelselected < 1 then
					modelselected = #ERP.GetAllowedCharacterModels();
				end

				model:SetModel(ERP.GetAllowedCharacterModels()[modelselected]);
			end
			lMdl = Label("Model: "..string.gsub(string.gsub(string.gsub(string.gsub(ERP.GetAllowedCharacterModels()[modelselected],"models/player/Group0",""),"1/",""),"2/",""),".mdl",""),holder);
			lMdl:SetFont("ESDefaultBold");
			lMdl:SetColor(Color(255,255,255,200));
			lMdl:SetPos(300,holder:GetTall()-220);
			lMdl:SizeToContents();
			local next = vgui.Create("esButton",holder);
			next:SetPos(130+10+70,ERP.MainMenu:GetTall()-147);
			next:SetSize(70,30);
			next.DoClick = function()
				modelselected = modelselected+1;
				if modelselected > #ERP.GetAllowedCharacterModels() then
					modelselected = 1;
				end

				lMdl:SetText("Model: "..string.gsub(string.gsub(string.gsub(string.gsub(ERP.GetAllowedCharacterModels()[modelselected],"models/player/Group0",""),"1/",""),"2/",""),".mdl",""));
				lMdl:SizeToContents();
				model:SetModel(ERP.GetAllowedCharacterModels()[modelselected]);
			end
			next:SetText("Next");

			lName = Label("Name: "..first.." "..last ,holder);
			lName:SetFont("ESDefaultBold");
			lName:SetColor(Color(255,255,255,200));
			lName:SetPos(300,holder:GetTall()-240);
			lName:SizeToContents();

			local regen = vgui.Create("esButton",holder);
			regen:SetPos(300,ERP.MainMenu:GetTall()-147);
			regen:SetSize(150,30);
			regen:SetText("Regenerate Name");
			regen.DoClick = function()
				first = genFirstName();
				last = genLastName();

				if IsValid(lName) then
					lName:SetText("Name: "..first.." "..last);
					lName:SizeToContents();
				end
			end

			local nameedit = vgui.Create("esButton",holder);
			nameedit:SetPos(300,ERP.MainMenu:GetTall()-190);
			nameedit:SetSize(150,30);
			nameedit:SetText("Customize Name");
			nameedit.DoClick = function()
				local pnlName = ERP:CreateExclFrame("Edit name",1,1,225,120,true);
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

						pnlName:Remove();

					end
				end
			end


			setUpSlide(true,{holder},function() end)
		end)
	end
	table.insert(slideitems,create);

	local settings = vgui.Create("esButton",ERP.MainMenu);
	settings:SetPos(ERP.MainMenu:GetWide()-160,ERP.MainMenu:GetTall()-190);
	settings:SetSize(150,30);
	settings:SetText("Settings");
	settings.DoClick=function()

	end
	table.insert(slideitems,settings);

	local dc = vgui.Create("esButton",ERP.MainMenu);
	dc:SetPos(ERP.MainMenu:GetWide()-160,ERP.MainMenu:GetTall()-147);
	dc:SetSize(150,30);
	dc.Red = true;
	dc:SetText("Disconnect");
	dc.DoClick=function()
		LocalPlayer():ConCommand("disconnect;");
	end
	table.insert(slideitems,dc);

	// characters

	for k,v in pairs(decoded)do
		local model = vgui.Create("DModelPanel",ERP.MainMenu);
		model:SetPos((k-1)*200,ERP.MainMenu:GetTall()-120-400);
		model:SetModel(v.model);
		model:SetSize( 400, 400 );
		model:SetCamPos( Vector( 100,0,40 ) );
		model:SetLookAt( Vector( 0, 0,40 ) );
		local button;
		table.insert(slideitems,model);
		timer.Simple(0,function()
			button = vgui.Create("esButton",ERP.MainMenu);
			local x,y = model:GetPos();
			button:SetPos(x+200-70,ERP.MainMenu:GetTall()-147); // y same as dc.pos.y
			button:SetSize(150,30);
			button:SetText("Select");
			button.DoClick = function()
				net.Start("ERP.Character.Select");
				net.WriteUInt(v.id,4);
				net.SendToServer();
			end
			table.insert(slideitems,button);
		end)
		model.LayoutEntity = function(self)
			if IsValid(button) and button.Hover then
				self:RunAnimation();
			end
		end

		local x,y = model:GetPos();
		local l = Label(v.firstname.." "..v.lastname,ERP.MainMenu);
		l:SetFont("ESDefaultBold");
		surface.SetFont("ESDefaultBold");
		l:SetPos(x+200-surface.GetTextSize(v.firstname.." "..v.lastname)/2,y+60);
		l:SizeToContents();
		table.insert(slideitems,l);
	end

	ERP.MainMenu:MakePopup();
end)
usermessage.Hook("ECreateDone",function()
	Go();
end);
