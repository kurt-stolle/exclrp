
--TODO: Remake this whole thing. The code is from ProjectRP/IRP2k10, created by NewBee_ with some help from Yuriman.

--[[local actionmenu = false;
local actionmenuOptions = {};
local actionmenuPos = Vector(0,0,0); -- 3d vector!]]
function ERP:CreateActionMenu(pos,options)
	--[[actionmenu = true;
	actionmenuOptions = options;

	pos.x = math.floor(pos.x)
	pos.y = math.floor(pos.y)
	pos.z = math.floor(pos.z)
]]
	local menu = DermaMenu()
	for k,v in ipairs(options)do
		menu:AddOption( v.text, v.func )
	end
	menu:AddSpacer()
	menu:AddOption( "Close", function() end )
	menu:Open(ScrW()/2,ScrH()/2,false)

	--actionmenuPos = pos;
end

--[[
hook.Add("PrePaintMainHUD","exclDrawActionMenus",function()
	if actionmenu then

		if actionmenuPos:Distance(LocalPlayer():EyePos()) > 200 then
			actionmenu = false
			return
		end

		local scrPos = actionmenuPos:ToScreen();
		scrPos.x = math.floor(scrPos.x)
		scrPos.y = math.floor(scrPos.y) - 20

		draw.SimpleText("Actions","ESDefault+.Shadow",scrPos.x-50,scrPos.y-20,ES.Color.Black,0,0)
		draw.SimpleText("Actions","ESDefault+.Shadow",scrPos.x-50,scrPos.y-20,ES.Color.Black,0,0)
		draw.SimpleText("Actions","ESDefault+.Shadow",scrPos.x-50,scrPos.y-19,ES.Color.Black,0,0)
		draw.SimpleText("Actions","ESDefault+",scrPos.x-50,scrPos.y-20,ES.Color.White,0,0)

		draw.RoundedBox(2,scrPos.x-51,scrPos.y-1,102,#actionmenuOptions*20 + 2,Color(0,0,0))
		for k,v in ipairs(actionmenuOptions)do
			if ScrW()/2 < scrPos.x-50+100 and ScrW()/2 > scrPos.x-50 and ScrH()/2 < scrPos.y+ 20*(k-1)+20 and ScrH()/2 >  scrPos.y+ 20*(k-1) then
				v.hover =true;
			else
				v.hover = false;
			end

			draw.RoundedBox(2,scrPos.x-50,scrPos.y+ 20*(k-1),100,20,k % 2 == 1 and ES.Color["#1E1E1E"] or ES.Color["#222"]);
			draw.SimpleText(v.text or "Undefined","ESDefaultBold",scrPos.x,scrPos.y+ 20*(k-1) +10,v.hover and ES.Color.White or ES.Color["#AAA"],1,1);
		end
	end
end)
hook.Add("PlayerBindPress","exclActionmenuBind",function(ply, bind, pressed)
	if actionmenu and string.find(bind, "+use") and pressed then
		local scrPos = actionmenuPos:ToScreen();
		for k,v in pairs(actionmenuOptions)do
			if v.hover then
				if v.func then
					v.func();
					actionmenu = false;
					return true;
				end
				ES.DebugPrint("Empty button ran: no func.")
				actionmenu = false;
				return true;
			end
		end
		actionmenu = false;
		return true;
	end
end)
]]
