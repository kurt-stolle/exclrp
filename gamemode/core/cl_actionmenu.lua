-- cl_actionmenu
-- the action menu

local actionmenu = false;
local actionmenuOptions = {};
local actionmenuPos = Vector(0,0,0); -- 3d vector!
function GM:CreateActionMenu(pos,options)
	actionmenu = true;
	actionmenuOptions = options;
	actionmenuPos = pos;
end

hook.Add("PrePaintMainHUD","exclDrawActionMenus",function()
	if actionmenu then
		
		local scrPos = actionmenuPos:ToScreen();
		draw.RoundedBox(4,scrPos.x-51,scrPos.y-1,102,#actionmenuOptions*20 + 2,Color(0,0,0))
		for k,v in pairs(actionmenuOptions)do
			if ScrW()/2 < scrPos.x-50+100 and ScrW()/2 > scrPos.x-50 and ScrH()/2 < scrPos.y+ 20*(k-1)+20 and ScrH()/2 >  scrPos.y+ 20*(k-1) then
				v.hover =true;
				draw.RoundedBox(4,scrPos.x-50,scrPos.y+ 20*(k-1),100,20,Color(0,0,100+math.sin(CurTime())*50));
			else
				v.hover = false;
				draw.RoundedBox(4,scrPos.x-50,scrPos.y+ 20*(k-1),100,20,Color(0,0,0));
			end
			
			draw.RoundedBox(2,scrPos.x-49,scrPos.y+ 20*(k-1) + 1,98,9,Color(255,255,255,10));
			draw.SimpleTextOutlined(v.text or "Undefined","DermaDefaultBold",scrPos.x,scrPos.y+ 20*(k-1) +9,Color(255,255,255),1,1,1,Color(0,0,0))
		end
		draw.SimpleTextOutlined("x","DermaDefault",ScrW()/2,ScrH()/2,Color(255,255,255),1,1,1,Color(0,0,0));
	end
end)
hook.Add("PlayerBindPress","exclActionmenuBind",function(ply, bind, pressed)
	if actionmenu and string.find(bind, "+attack") and pressed then 
		local scrPos = actionmenuPos:ToScreen();
		for k,v in pairs(actionmenuOptions)do
			if v.hover then
				if v.func then
					v.func();
					actionmenu = false;
					return true;
				end
				print("Empty button ran: no func.")
				actionmenu = false;
				return true;
			end
		end
		actionmenu = false;
		return true;
	end
end)