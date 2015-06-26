include("shared.lua")

function ENT:Initialize()
end

local w,h=165,160
function ENT:Draw()
	self.Entity:DrawModel()

	if not LocalPlayer():IsLoaded() then return end

	local pos = self:GetPos()
	local ang = self:GetAngles()
	ang:RotateAroundAxis(ang:Up(),90);
	ang:RotateAroundAxis(ang:Forward(),77);
	cam.Start3D2D(pos + ang:Right()*-48.5 + ang:Up()*19.8 + ang:Forward() * -8.3, ang, 0.08)
		surface.SetDrawColor(Color(0,0,0));
		surface.DrawRect(-w/2,-h/2,w,h)
		draw.SimpleText("Account balance","ESDefault+",0,-32,ES.Color.Lime,1,1);
		draw.SimpleText("$ "..(LocalPlayer().character:GetBank() or 0),"ESDefault++",0,0,ES.Color.Lime,1,1);
		surface.SetDrawColor(ES.Color.White)
		if math.sin(CurTime()*4) > 0 then
			draw.SimpleText("PLEASE INSERT CARD","ESDefault",0,38,ES.Color.White,1,1);
		end
	cam.End3D2D()
end

local fr;
usermessage.Hook("exclOpenATMMenu",function()
	local ply=LocalPlayer()

	ERP:CreateActionMenu(ply:GetEyeTrace().HitPos,
	{
	{text = "Deposit",func = function()
		if fr and fr:IsValid() then
			fr:Remove();
		end

		fr = vgui.Create("esFrame")
		fr:SetTitle("Deposit")
		fr:SetSize(200,30+20+20+20+30+20)

		fr:Center();
		fr:MakePopup();

		local textEntry = vgui.Create("DTextEntry", fr)
		textEntry:SetText("0")
		textEntry:SetTall(20)
		textEntry:Dock(TOP)
		textEntry:DockMargin(20,20,20,0)
		textEntry:SetPos(5,35);
		textEntry.OnEnter = function(self) end

		local button = vgui.Create("esButton",fr)
		button:SetTall(30)
		button:Dock(BOTTOM)
		button:DockMargin(20,20,20,20)
		button:SetText("Confirm");
		button.DoClick = function()
			if tonumber(textEntry:GetValue()) > LocalPlayer().character:GetCash() then ES.NotifyPopup("Error","You do not have enough cash on you to do this."); return; end
			RunConsoleCommand("erp_bank_deposit",textEntry:GetValue());
			fr:Remove();
		end

		fr:MakePopup();
	end},
	{text = "Withdraw",func = function()
		if fr and fr:IsValid() then
			fr:Remove();
		end

		fr = vgui.Create("esFrame")
		fr:SetTitle("Withdraw")
		fr:SetSize(200,30+20+20+20+30+20)

		fr:Center();


		local textEntry = vgui.Create("DTextEntry", fr)
		textEntry:SetText("0")
		textEntry:SetTall(20)
		textEntry:Dock(TOP)
		textEntry:DockMargin(20,20,20,0)
		textEntry:SetPos(5,35);
		textEntry.OnEnter = function(self) end

		local button = vgui.Create("esButton",fr)
		button:SetTall(30)
		button:Dock(BOTTOM)
		button:DockMargin(20,20,20,20)
		button:SetText("Confirm");
		button.DoClick = function()
			if tonumber(textEntry:GetValue()) > ply.character:GetBank() then ES.NotifyPopup("Error","You do not have enough cash in your account to do this."); return; end
			RunConsoleCommand("erp_bank_withdraw",textEntry:GetValue());
			fr:Remove();
		end

		fr:MakePopup();

	end}
	})
end)

usermessage.Hook("eDeposDone",function(u)
	ES.NotifyPopup("Success","You deposited $"..u:ReadLong()..",- to your bank account")
end)
usermessage.Hook("eWithdrDone",function(u)
	ES.NotifyPopup("Success","You withdrew $"..u:ReadLong()..",- from your bank account")
end)
