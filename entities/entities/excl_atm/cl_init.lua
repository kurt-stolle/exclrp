include("shared.lua")

function ENT:Initialize()
end

function ENT:Draw()
	self.Entity:DrawModel()
	
	local pos = self:GetPos()
	local ang = self:GetAngles()
	ang:RotateAroundAxis(ang:Up(),90);
	ang:RotateAroundAxis(ang:Forward(),83);
	cam.Start3D2D(pos + ang:Right()*-51 + ang:Up()*9.3, ang, 0.1)
		surface.SetDrawColor(Color(0,0,0));
		surface.DrawRect(-92,-51,120,73)
		draw.DrawText("You currently have\n$ "..(LocalPlayer():GetMoneyBank() or 0)..",-\nin your bank account","DermaDefaultBold",-32,-35,Color(0,100,0),1);
	cam.End3D2D()
end

local fr;
usermessage.Hook("exclOpenATMMenu",function()
	ERP:CreateActionMenu(LocalPlayer():GetEyeTrace().HitPos,
	{
	{text = "Deposit",func = function()
		if fr and fr:IsValid() then
			fr:Remove();
		end
		
		fr = ERP:CreateExclFrame("Deposit",1,1,200,89,true);
		fr:Center();
		fr:MakePopup();
		
		local textEntry = vgui.Create("DTextEntry", fr)
		textEntry:SetText("0")
		textEntry:SetSize(fr:GetWide()-10,16)
		textEntry:SetPos(5,35);
		textEntry.OnEnter = function(self) end
		
		local button = vgui.Create("esButton",fr)
		button:SetSize(fr:GetWide()-10,30);
		button:SetPos(5,fr:GetTall()-35);
		button:SetText("Confirm");
		button.DoClick = function()
			if tonumber(textEntry:GetValue()) > LocalPlayer():GetMoney() then ES.Notify("generic","You do not have enough cash on you to do this."); return; end
			RunConsoleCommand("excl_bank_deposit",textEntry:GetValue());
			fr:Remove();
		end
	end},
	{text = "Withdraw",func = function()
		if fr and fr:IsValid() then
			fr:Remove();
		end
		
		fr = ERP:CreateExclFrame("Withdraw",1,1,200,89,true);
		fr:Center();
		fr:MakePopup();
		
		local textEntry = vgui.Create("DTextEntry", fr)
		textEntry:SetText("0")
		textEntry:SetSize(fr:GetWide()-10,16)
		textEntry:SetPos(5,35);
		textEntry.OnEnter = function(self) end
		
		local button = vgui.Create("esButton",fr)
		button:SetSize(fr:GetWide()-10,30);
		button:SetPos(5,fr:GetTall()-35);
		button:SetText("Confirm");
		button.DoClick = function()
			if tonumber(textEntry:GetValue()) > LocalPlayer():GetMoneyBank() then ES.Notify("generic","You do not have enough cash in your account to do this."); return; end
			RunConsoleCommand("excl_bank_withdraw",textEntry:GetValue());
			fr:Remove();
		end
		
	end}
	})
end)

usermessage.Hook("eDeposDone",function(u)
	ES.Notify("generic","You deposited $"..u:ReadLong()..",- to your bank account")
end)
usermessage.Hook("eWithdrDone",function(u)
	ES.Notify("generic","You withdrew $"..u:ReadLong()..",- from your bank account")
end)