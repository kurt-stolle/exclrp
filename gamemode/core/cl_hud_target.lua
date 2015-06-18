surface.CreateFont("ERP.TargetID",{
  font="Roboto",
  size=21,
  weight=400
})
surface.CreateFont("ERP.TargetID.Shadow",{
  font="Roboto",
  size=21,
  weight=400,
  blursize=2
})

surface.CreateFont("ERP.TargetID-",{
  font="Roboto",
  size=17,
  weight=400
})
surface.CreateFont("ERP.TargetID-.Shadow",{
  font="Roboto",
  size=17,
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
      if not IsValid(v) or not v:IsLoaded() then return end

      posTarget=ply:LookupBone("ValveBiped.Bip01_Neck1")

      if not posTarget then continue end

      posTarget=ply:GetBonePosition(posTarget)

      if not posTarget then continue end

      if posTarget:Distance(posLocal) > 200 and not v:IsLoaded() then
        v._hud_nameFade = 0;
        continue
      end

      v._hud_nameFade = Lerp(FrameTime()*4,v._hud_nameFade or 0,255)

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

      color_black.a = v._hud_nameFade;

      local namestring = v:GetCharacter():GetFullName();
      drawText(namestring,"ERP.TargetID",x,y+1,color_black,1,1)
      drawText(namestring,"ERP.TargetID.Shadow",x,y,color_black,1,1)
      drawText(namestring,"ERP.TargetID.Shadow",x,y,color_black,1,1)
      drawText(namestring,"ERP.TargetID",x,y,color_white,1,1)

      y = y + 22

      if ply:GetStatus() == 0 then
        jobstring = team.GetName(v:Team())
        color_job = table.Copy(team.GetColor(v:Team()))
        color_job.a = v._hud_nameFade;
      else
        jobstring = {}
        color_job = color_white

        if bit.band(ply:GetStatus(),STATUS_ARRESTED) then
          table.insert(jobstring,"Arrested")
        end

        jobstring = table.concat(jobstring," | ",1)
      end

      drawText(jobstring,"ERP.TargetID-",x,y+1,color_black,1,1)
      drawText(jobstring,"ERP.TargetID-.Shadow",x,y,color_black,1,1)
      drawText(jobstring,"ERP.TargetID-.Shadow",x,y,color_black,1,1)
      drawText(jobstring,"ERP.TargetID-",x,y,color_job,1,1)
    end
  end
end)
