surface.CreateFont("ERP.TargetID",{
  font="Roboto",
  size=20,
  weight=400
})
surface.CreateFont("ERP.TargetID.Shadow",{
  font="Roboto",
  size=20,
  weight=400,
  blursize=2
})

local ply,posLocal,posTarget;

local color_white = ES.Color.White
local color_black = ES.Color.Black
local drawText = draw.SimpleText

hook.Add("HUDPaint","ERP.HUDPaint.TargetID",function()
  ply=LocalPlayer();

  if IsValid(ply) and ply:IsLoaded() then
    posLocal=ply:EyePos();
    for k,v in ipairs(player.GetAll())do
      if not IsValid(v) or not v:IsLoaded() or v == ply then return end

      posTarget=ply:LookupBone("ValveBiped.Bip01_Neck1")

      if not posTarget then continue end

      posTarget=ply:GetBonePosition(posTarget)

      if not posTarget then continue end

      if posTarget:Distance(posLocal) > 200 and not v:IsLoaded() then continue end

      posTarget.z = posTarget.z + 20;
      posTarget=posTarget:ToScreen();
      drawText(v:GetCharacter():GetFullName(),"ERP.TargetID.Shadow",posTarget.x,posTarget.y,color_black,1,1)
      drawText(v:GetCharacter():GetFullName(),"ERP.TargetID",posTarget.x,posTarget.y,color_white,1,1)
    end
  end
end)
