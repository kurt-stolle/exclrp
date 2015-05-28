function ERP:CreateErrorDialog(text,onDone)
	onDone = onDone or function() end
	local f =vgui.Create("esFrame")
	f:SetTitle("Error")

	local b =vgui.Create("esButton",f)
	b:SetTall(30)
	b:Dock(BOTTOM)
	b:DockMargin(10,10,10,10)
	b:SetText("Okay");
	b.DoClick = function()
		onDone();
		f:Remove();
	end
	local l=Label(text,f)
	l:Center();
	l:SetFont("ESDefault")
	l:SizeToContents();
	l:SetPos(20,50)
	l:SetColor(Color(255,255,255));

	f:SetSize(40 + l:GetWide(),30 + 20 + l:GetTall() + 20 + 30 + 10)
	f:Center();
	f:MakePopup();

	return f;
end
