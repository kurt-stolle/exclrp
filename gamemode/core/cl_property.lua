ERP.Properties = {};
ERP.OwnedProperty = {};

local doors = {
	"prop_door_rotating",
	"func_door",
	"func_door_rotating"
};

hook.Add("OnContextMenuOpen","ERP.ContextMenu.Properties",function()
	local e = LocalPlayer():GetEyeTrace().Entity;
	
	if IsValid(e) and LocalPlayer():IsLoaded() and LocalPlayer():GetEyeTrace().HitPos:Distance(LocalPlayer():EyePos()) < 100 then

		if table.HasValue(doors,e:GetClass()) and availableProperty[e:EntIndex()] then
			if not ERP.OwnedProperty[availableProperty[e:EntIndex()]] then
				ERP:CreateActionMenu(LocalPlayer():GetEyeTrace().HitPos,{
				{text="Buy property",func=function()
					RunConsoleCommand("excl_buyproperty");
				end}
				})
			elseif ERP.OwnedProperty[availableProperty[e:EntIndex()]].id == LocalPlayer():UniqueID() then
				ERP:CreateActionMenu(LocalPlayer():GetEyeTrace().HitPos,{
				{text="Lock",func=function()
					RunConsoleCommand("excl_lockdoor");
				end},
				{text="Unlock",func=function()
					RunConsoleCommand("excl_unlockdoor");
				end}
				})
			else

			end
		end

	end
end)

local availableProperty = {};
net.Receive("ERPSynchProperty",function(len)
	ERP.Properties = net.ReadTable();
	for k,v in pairs(ERP.Properties) do
		if v.doors then
			for a,b in pairs(v.doors) do
				if tonumber(b) then
					availableProperty[tonumber(b)] = k;
					print(b);
				end
			end
		end
	end
	ERP.OwnedProperty = net.ReadTable();
end)

local alpha = 0
hook.Add("HUDPaint","exclDoorPropertyHints",function()
	local lp = LocalPlayer();
	if lp:GetEyeTrace() and IsValid(lp:GetEyeTrace().Entity) and table.HasValue(doors,lp:GetEyeTrace().Entity:GetClass()) and availableProperty[lp:GetEyeTrace().Entity:EntIndex()] then
		local e = lp:GetEyeTrace().Entity;
		local p = e:LocalToWorld(e:OBBCenter());

		if lp:GetEyeTrace().HitPos:Distance(lp:EyePos()) < 100 then
			alpha = Lerp(0.01,alpha,255);
		else
			alpha = Lerp(0.1,alpha,0);
		end

		p = p:ToScreen();

		draw.SimpleTextOutlined(ERP.Properties[availableProperty[e:EntIndex()]].name or "Error! Unidentified property!","TargetID",p.x,p.y,Color(255,255,255,alpha),1,1,1,Color(0,0,0,alpha));
		if ERP.OwnedProperty[availableProperty[e:EntIndex()]] then
			draw.SimpleTextOutlined("Owned by: "..ERP.OwnedProperty[availableProperty[e:EntIndex()]].nick,"DermaDefaultBold",p.x,p.y+25,Color(255,255,255,alpha),1,1,1,Color(0,0,0,alpha));
		else
			draw.SimpleTextOutlined("Press C to rent","DermaDefaultBold",p.x,p.y+25,Color(200,200,200,alpha),1,1,1,Color(0,0,0,alpha));
			draw.SimpleTextOutlined("This property costs $"..tostring(50+(#ERP.Properties[availableProperty[e:EntIndex()]].doors*6))..",- per hour.","DermaDefaultBold",p.x,p.y+40,Color(200,200,200,alpha),1,1,1,Color(0,0,0,alpha));
		end
	else
		if alpha > .5 then
			alpha = Lerp(0.1,alpha,0);
		end
	end
end);
