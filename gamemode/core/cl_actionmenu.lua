-- cl_actionmenu
-- the action menu

local actionmenu = false;
local actionmenuOptions = {};
local actionmenuPos = Vector(0,0,0); -- 3d vector!
function ERP:CreateActionMenu(pos,options)
	actionmenu = true;
	actionmenuOptions = options;
	actionmenuPos = pos;
end

hook.Add("PrePaintMainHUD","exclDrawActionMenus",function()
	if actionmenu then

		local scrPos = actionmenuPos:ToScreen();

		draw.SimpleText("ACTION MENU","ESDefaultBold",scrPos.x-51+1,scrPos.y-20+1,ES.Color["#FFFFFFA0"],0,0)
		draw.SimpleText("ACTION MENU","ESDefaultBold",scrPos.x-51,scrPos.y-20,ES.Color.Black,0,0)

		draw.RoundedBox(2,scrPos.x-51,scrPos.y-1,102,#actionmenuOptions*20 + 2,Color(0,0,0))
		for k,v in ipairs(actionmenuOptions)do
			if ScrW()/2 < scrPos.x-50+100 and ScrW()/2 > scrPos.x-50 and ScrH()/2 < scrPos.y+ 20*(k-1)+20 and ScrH()/2 >  scrPos.y+ 20*(k-1) then
				v.hover =true;
				draw.RoundedBox(2,scrPos.x-50,scrPos.y+ 20*(k-1),100,20,ES.GetColorScheme(1));
				draw.SimpleTextOutlined(v.text or "Undefined","DermaDefaultBold",scrPos.x,scrPos.y+ 20*(k-1) +9,Color(255,255,255),1,1,1,Color(0,0,0))
			else
				v.hover = false;
				draw.RoundedBox(2,scrPos.x-50,scrPos.y+ 20*(k-1),100,20,ES.Color.White);
				draw.SimpleText(v.text or "Undefined","DermaDefaultBold",scrPos.x,scrPos.y+ 20*(k-1) +9,ES.Color["#444"],1,1,1);
			end

			draw.RoundedBox(2,scrPos.x-49,scrPos.y+ 20*(k-1) + 1,98,9,Color(255,255,255,10));

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
