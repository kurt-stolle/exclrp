surface.CreateFont("ERP.TargetID",{
  font="Roboto",
  size=18,
  weight=400
})
surface.CreateFont("ERP.TargetID.Shadow",{
  font="Roboto",
  size=18,
  weight=400,
  blursize=2
})

surface.CreateFont("ERP.TargetID-",{
  font="Roboto",
  size=14,
  weight=400
})
surface.CreateFont("ERP.TargetID-.Shadow",{
  font="Roboto",
  size=14,
  weight=400,
  blursize=2
})


local ply,posLocal,posTarget;

local color_white = Color(255,255,255)
local color_black = Color(0,0,0)
local color_job;
local drawText = draw.SimpleText
local matGrad=  Material("exclserver/gradient.png")
local jobstring;

hook.Add("HUDPaint","ERP.HUDPaint.TargetID",function()
  ply=LocalPlayer();

  if IsValid(ply) and ply:IsLoaded() then
    posLocal=ply:EyePos();
    for k,v in ipairs(player.GetAll())do
      if not IsValid(v) or not v:IsLoaded() or v == ply or not v:Alive() then continue end

      posTarget=v:LookupBone("ValveBiped.Bip01_Neck1")

      if not posTarget then continue end

      posTarget=v:GetBonePosition(posTarget)

      if not posTarget then continue end

      if( posTarget:Distance(posLocal) > 200 and not ply:HasStatus(STATUS_WANTED) ) or not v:IsLoaded() then
        v._hud_nameFade = Lerp(FrameTime()*12,v._hud_nameFade or 0,0);
      else
        v._hud_nameFade = Lerp(FrameTime()*8,v._hud_nameFade or 0,255)
      end

      if v._hud_nameFade < 1 then continue end

      color_white.a = v._hud_nameFade;

      posTarget.z = posTarget.z + 28;

      v._hud_nameTarget = LerpVector(FrameTime()*12,v._hud_nameTarget or posTarget,posTarget)

      posTarget=v._hud_nameTarget:ToScreen();

      x,y = math.floor(posTarget.x),math.floor(posTarget.y)

      surface.SetMaterial(matGrad)
      color_black.a = v._hud_nameFade * .6;
      surface.SetDrawColor(color_black)
      surface.DrawTexturedRectRotated(x+70,y+10,48,140,90)
      surface.DrawTexturedRectRotated(x-70,y+10,48,140,-90)
      surface.DrawTexturedRectRotated(x+50,y+11-48/2,1,100,90)
      surface.DrawTexturedRectRotated(x-50,y+11-48/2,1,100,-90)
      surface.DrawTexturedRectRotated(x+50,y+10+48/2,1,100,90)
      surface.DrawTexturedRectRotated(x-50,y+10+48/2,1,100,-90)

      y=y-2

      color_black.a = v._hud_nameFade;

      local namestring = v:GetCharacter():GetFullName();
      drawText(namestring,"ERP.TargetID",x,y+1,color_black,1,1)
      drawText(namestring,"ERP.TargetID.Shadow",x,y,color_black,1,1)
      drawText(namestring,"ERP.TargetID.Shadow",x,y,color_black,1,1)
      drawText(namestring,"ERP.TargetID",x,y,color_white,1,1)

      if v:GetStatus() == 0 then
        y = y + 22

        jobstring = team.GetName(v:Team())
        color_job = table.Copy(team.GetColor(v:Team()))
        color_job.a = v._hud_nameFade;

        drawText(jobstring,"ESDefaultBold",x,y+1,color_black,1,1)
        drawText(jobstring,"ESDefaultBold.Shadow",x,y,color_black,1,1)
        drawText(jobstring,"ESDefaultBold.Shadow",x,y,color_black,1,1)
        drawText(jobstring,"ESDefaultBold",x,y,color_job,1,1)
      else
        y= y+14

        local statuses = {}
        if v:HasStatus(STATUS_ARRESTED) then
          table.insert(statuses,{color=ES.Color.Blue,text="A"})
        end
        if v:HasStatus(STATUS_WANTED) then
          table.insert(statuses,{color=ES.Color.Red,text="W"})
        end
        if v:HasStatus(STATUS_WARRANT) then
          table.insert(statuses,{color=ES.Color.Orange,text="W"})
        end

        if #statuses <= 0 then continue end

        local size=18
        local margin=4
        local xStart=x-(size*#statuses + margin*(#statuses-1))/2
        local _x,_y;
        for k,v in ipairs(statuses)do
          _x,_y=xStart + (k-1)*(size+margin),y
          draw.RoundedBox(2,_x,_y,size,size,v.color)
          draw.RoundedBox(2,_x+1,_y+1,size-2,size-2,ES.Color["#0000005F"])
          _x,_y=_x+size/2,_y+size/2
          draw.SimpleText(v.text,"ERP.TargetID-",_x,_y+1,ES.Color.Black,1,1)
          draw.SimpleText(v.text,"ERP.TargetID-.Shadow",_x,_y,ES.Color.Black,1,1)
          draw.SimpleText(v.text,"ERP.TargetID-.Shadow",_x,_y,ES.Color.Black,1,1)
          draw.SimpleText(v.text,"ERP.TargetID-",_x,_y,ES.Color.White,1,1)
        end
      end
    end
  end
end)
