-- cl_notifications
-- the good ol' notification system.

local randomnotes = {
"You can press [F4] to view the in-game menu.",
"This gamemode is created by _NewBee (Excl)",
"Become a VIP to unlock extra features.",
"If you wear a tag you will get in-game benefits.",
"You can view our VIP benefits at our website."
}
local meta={}
local notify = {}
notify.tbl = {}
notify.icons = {}
notify.icons["boom"] =Material("exclrp/notices/cleanup.png");
notify.icons["generic"] =Material("exclrp/notices/generic.png");
notify.icons["error"]	=Material("exclrp/notices/error.png");
notify.icons["undo"] =Material("exclrp/notices/undo.png");
notify.icons["hint"] =Material("exclrp/notices/cleanup.png");

function meta:SetText(s)
	if not s then s="Unidentified"; end
	surface.SetFont("DermaDefaultBold");
	
	local w=surface.GetTextSize(s);	
	self.Text=s;
	self.w=(w+60);
end
function meta:SetIcon(s)
	if notify.icons[s] then
		self.Icon=notify.icons[s];
	end
end
function meta:Draw()
	surface.SetFont("DermaDefaultBold");

	local t=self.Text;
	local x=self.x;
	local y=self.y;
	local w=self.w;
	local h=self.h;
	local icon=self.Icon;
	local c=self.Color;
	
	draw.RoundedBox(4,x,y,w,h,Color(0,0,0,200));
	draw.RoundedBox(4,x+2,y+2,w-4,h-4,c);
	draw.RoundedBox(4,x+3,y+3,w-6,(h-6)/2,Color(255,255,255,100));
	
	surface.SetDrawColor( 255, 255, 255, 255 );
	surface.SetMaterial(icon);
	surface.DrawTexturedRect(x+5,y-8,40,40);
	
	draw.SimpleText(t,"DermaDefaultBold",x+50,y+11,Color(0,0,0),0,1);
end
function meta:CalculatePos(val)
	local moveto=(val*50);
	self.y=Lerp(0.1, self.y, moveto);
	local x
	if not self.Close then
		x= ScrW()-10-self.w;
	else
		x= self.movex+50;
	end
	self.x=Lerp(0.1, self.x, x);
	if self.x>ScrW()+1 then
		table.remove(notify.tbl,val);
	end
end	

function createNotify(t,i,c)
	local obj={}
	if (not i) or (not notify.icons[string.lower(i)]) then
		i="generic";
	else
		i=string.lower(i);
	end
	
	setmetatable(obj,meta);
	meta.__index = meta;
	
	obj.x=ScrW();
	obj.movex= ScrW();
	obj.y=50;
	obj.w=200;
	obj.h=24;
	obj.Text="Unknown";
	obj:SetText(tostring(t))
	obj.Color=(c or Color(213,213,213));
	obj.Icon=notify.icons[i];
	obj.Close=false;
	
	surface.PlaySound("ambient/levels/canals/drip"..math.random(1,4)..".wav");
	
	table.insert(notify.tbl,obj);
	timer.Simple(4,function()
		obj.Close=true
		obj.movex=ScrW()
	end)
end

usermessage.Hook("exclNC",function(u)
	local m=u:ReadString();
	local i=u:ReadString() or nil;

	createNotify(m,i);
end)

hook.Add("HUDPaint", "exclNoteHUD", function()
	local t=notify.tbl;
	for i=1, #t do
		if t[i] then
			t[i]:Draw(i) -- ES.BroadcastNotification

		end
	end
end)
hook.Add("Think", "exclNoteCalc", function()
	local t=notify.tbl;
	for i=1, #t do
		if t[i] then
			t[i]:CalculatePos(i)
		end
	end
end)

timer.Create("exclTimeNotes", 75, 0, createNotify, randomnotes[math.random(1,#randomnotes)],"hint")

function notification.AddLegacy(t,i,c)
	if i == NOTIFY_GENERIC then
		createNotify(t,"generic")
	elseif i == NOTIFY_UNDO then
		createNotify(t,"boom")
	elseif i == NOTIFY_HINT then
		createNotify(t,"hint")
	elseif i == NOTIFY_ERROR then
		createNotify(t,"error")
	end
end


