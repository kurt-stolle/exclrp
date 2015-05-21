
local scoreboard;

local _Material = Material( "pp/toytown-top" )
_Material:SetTexture( "$fbtexture", render.GetScreenEffectTexture() )

vgui.Register("ERPScoreboard.PlayerRow",{
	Init = function( self )

		self.Avatar		= vgui.Create( "AvatarImage", self )
		self.Avatar:SetSize( 42,42 )
    self.Avatar:Dock(LEFT)
		self.Avatar:SetMouseInputEnabled( false )

    --[[self.Model		= vgui.Create( "Spawnicon", self )
		self.Model:SetSize( 42,42 )
    self.Model:Dock(LEFT)
    self.Model:DockMargin(-42,0,0,0)]]

    local textarea=vgui.Create("Panel",self)
    textarea:Dock(FILL)
    textarea:DockMargin(10,4,10,4)

    self.Name = vgui.Create("esLabel", textarea)
    self.Name:SetFont("ESDefault+")
    self.Name:SetColor(ES.Color.White)
    self.Name:Dock(TOP)
    self.Name:SetText("")
    self.Name:SizeToContents()

    self.Nick = vgui.Create("esLabel", textarea)
    self.Nick:SetFont("ESDefault")
    self.Nick:SetColor(ES.Color.White)
    self.Nick:Dock(BOTTOM)
    self.Nick:SetText("")
    self.Nick:SizeToContents()

    self.Ping = vgui.Create("esLabel", self)
    self.Ping:SetFont("ESDefault+")
    self.Ping:SetColor(ES.Color.White)
    self.Ping:Dock(RIGHT)
    self.Ping:DockMargin(0,0,16,0)
    self.Ping:SetTall(42)

		self:Dock( TOP )
		self:SetHeight(44)
		self:DockMargin( 10,10,10,0 )
    self:DockPadding(1,1,1,1)

	end,
	PerformLayout = function(self)
		if not IsValid(self.Player) then return end

		local w,h = self:GetWide(), self:GetTall();
		self.Avatar:SetPos(h/2 - self.Avatar:GetTall()/2, h/2 - self.Avatar:GetTall()/2);
	end,
	Setup = function( self, pl )

		self.Player = pl

		self.Avatar:SetPlayer( pl, 64 )
    --self.Model:SetModel( pl:GetModel() )
    self.Name:SetText( pl:GetCharacter() and pl:GetCharacter():GetFullName() or "NO CHARACTER" )
    self.Name:SizeToContents();
    self.Nick:SetText( pl:Nick() )
    self.Nick:SizeToContents();
    self.Ping:SetText( pl:Ping() )
    self.Ping:SizeToContents()

		self:Think();
		self:PerformLayout();

	end,

	Think = function( self )

		if ( !IsValid( self.Player ) ) then
			self:MakeInvalid()
			return
		end

		if ( !self.Player:Alive() ) then
			self:SetZPos( 1000 )
		else
			self:SetZPos(0);
		end

	end,
	MakeInvalid = function(self)
		self:SetZPos(2000);
		self:Remove();
	end,
	OnMouseReleased=function(self)

	end,
	Paint = function(self,w,h)
		if ( !IsValid( self.Player ) ) then
			return
		end

		local col = team.GetColor(self.Player:Team());
		if not self.Player:Alive() then
			col.r = math.Clamp(col.r *.6,0,255);
			col.g = math.Clamp(col.g *.6,0,255);
			col.b = math.Clamp(col.b *.6,0,255);
		end

		if self.Player == LocalPlayer() then
			local add = math.abs(math.sin(CurTime() * 1) * 50);
			col.r = math.Clamp(col.r +add,0,255);
			col.g = math.Clamp(col.g +add,0,255);
			col.b = math.Clamp(col.b +add,0,255);
		end

    surface.SetDrawColor(col)
		surface.DrawRect(0,0,w,h)

    surface.SetDrawColor(Color(0,0,0,100))
		surface.DrawRect(0,0,w,1)
		surface.DrawRect(0,h-1,w,1)
		surface.DrawRect(0,1,1,h-2)
		surface.DrawRect(w-1,1,1,h-2)

		surface.SetDrawColor(Color(255,255,255,5));
		surface.DrawRect(1,1,w-2,1)
		surface.DrawRect(1,h-2,w-2,1)
		surface.DrawRect(1,2,1,h-4)
		surface.DrawRect(w-2,2,1,h-4)
	end
},"Panel");

local color_text = Color(255,255,255,0);
local color_shadow = Color(0,0,0,0);
local color_hidden = Color(0,0,0,0);
vgui.Register("ERPScoreboard",{
	Init = function( self )
		self.Expand = true;

		self.Header = self:Add( "Panel" )
		self.Header:Dock( TOP )
		self.Header:SetHeight( 100 )

		self.Footer = self:Add( "Panel" )
		self.Footer:Dock( BOTTOM )

    self.Host = self.Footer:Add( "DLabel" )
		self.Host:SetFont("ESDefaultBold");
		self.Host:SetTextColor( color_text );
		self.Host:Dock(TOP);
		self.Host:SetContentAlignment( 5 )
		self.Host:SetText("Hosted by the CasualBananas community");
		self.Host:SizeToContents();

    self.Credit = self.Footer:Add( "DLabel" )
		self.Credit:SetFont("ESDefaultBold");
		self.Credit:SetTextColor( color_text );
		self.Credit:Dock(TOP);
		self.Credit:SetContentAlignment( 5 )
		self.Credit:SetText("Created by Excl"); -- don't be a douche and remove my name here
		self.Credit:SizeToContents();
		self.Credit:DockMargin(0,3,0,0);

		self.Name = self.Header:Add( "DLabel" )
		self.Name:SetFont( "ESDefault+++" )
		self.Name:SetTextColor( color_text )
		self.Name:Dock( TOP )
		self.Name:SizeToContents();
		self.Name:SetContentAlignment( 5 )
		self.Name:SetText("ExclRP");

		self.Rows=vgui.Create("Panel",self)
    self.Rows:Dock(FILL)


		self:SetSize( 700, ScrH() - 200 )
		self.y = -self:GetTall();
		self.x = ScrW()/2 - self:GetWide()/2;

		self.ySmooth = self.y;
	end,

	PerformLayout = function( self )
		self.Header:SetHeight( self.Name:GetTall()+20 )
		local max = 0;
		for k,v in pairs(self.Footer:GetChildren())do
			if v.y + v:GetTall() > max then
				max = v.y + v:GetTall();
			end
		end

		self.Footer:SetHeight(max);
	end,

	Paint = function( self, w, h )
	end,

	Think = function( self  )

		local w,h = self:GetWide(),self:GetTall();

		if not self.Expand then
			if math.floor(self.y) > -h then
				color_text.a = Lerp(FrameTime()*12,color_text.a,0);
				color_shadow.a = color_text.a * .8;

				if math.floor(color_text.a) <= 1 then
					self.ySmooth = Lerp(FrameTime()*3,self.ySmooth,-h);
					self.y = math.Round(self.ySmooth);
				end

				self.Name:SetTextColor( color_text )
				self.Host:SetTextColor( color_text );
				self.Credit:SetTextColor( color_text );
				self.Name:SetExpensiveShadow( 2, color_shadow )
				self.Credit:SetExpensiveShadow( 1, color_shadow )
				self.Host:SetExpensiveShadow( 1, color_shadow )

			elseif self:IsVisible() and not self.Expand and math.floor(self.ySmooth) <= -h + 1 then
				self:Hide();
				color_text.a = 0;
				ES:DebugPrint("Scoreboard hidden");
			end

			return
		end

		local target = (ScrH()/2 - h/2);

		self.ySmooth = Lerp(FrameTime()*10,self.ySmooth,target);
		self.y = math.Round(self.ySmooth);

		if math.ceil(self.ySmooth) >= target then
			color_text.a = Lerp(FrameTime()*2,color_text.a,255);
			color_shadow.a = color_text.a * .8;

			self.Name:SetTextColor( color_text )
				self.Host:SetTextColor( color_text );
				self.Credit:SetTextColor( color_text );

				self.Name:SetExpensiveShadow( 2, color_shadow )
				self.Credit:SetExpensiveShadow( 1, color_shadow )
				self.Host:SetExpensiveShadow( 1, color_shadow )

		end

		for id, pl in pairs( player.GetAll() ) do
			if ( IsValid( pl.ScoreEntry ) ) then
				if (not IsValid(pl.ScoreEntry.scoreboard)) or pl.ScoreEntry.scoreboard ~= self then
					ES:DebugPrint("Removed invalid score panel");
					pl.ScoreEntry:MakeInvalid();
				else
					continue;
				end
			end

			if pl:Team() ~= TEAM_SPECTATOR then

				pl.ScoreEntry = vgui.Create("ERPScoreboard.PlayerRow",self.Rows );
				pl.ScoreEntry:Setup( pl );
        pl.ScoreEntry:Dock(TOP)
				pl.ScoreEntry.scoreboard = self;

      end
		end

	end,
},"Panel");

timer.Create("ERP.Scoreboard.UpdateLayout",1,0,function()
	if IsValid(scoreboard) then
		scoreboard:PerformLayout();
	end
end);


function ERP:ScoreboardShow()
	if ( !IsValid( scoreboard ) ) then
		scoreboard = vgui.Create("ERPScoreboard");
	end

	if ( IsValid( scoreboard ) ) then
		scoreboard.Expand = true;
		scoreboard:Show()

		gui.EnableScreenClicker(true);

		scoreboard:SetKeyboardInputEnabled( false )
	end
end

function ERP:ScoreboardHide()
	if ( IsValid( scoreboard ) ) then

		scoreboard.Expand = false;

		gui.EnableScreenClicker(false);
	end
end
