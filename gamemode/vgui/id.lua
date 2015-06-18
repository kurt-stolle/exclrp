
local margin=10
local matGradient=Material("exclserver/gradient.png")

-- The container for the ID
local CONTAINER={}
function CONTAINER:Paint(w,h)
  -- Draw the border
  draw.RoundedBox(6,0,0,w,h,ES.Color["#222"])
  draw.RoundedBox(6,1,1,w-2,h-2,ES.Color["#EEE"])
  draw.RoundedBox(6,2,2,w-4,h-4,ES.Color["#CCC"])

  -- TODO: Some official looking stuff here
  draw.RoundedBoxEx(6,1,1,w-2,40,self:GetParent().color,true,true,false,false)

  surface.SetDrawColor(ES.Color["#00000033"])
  surface.SetMaterial(matGradient)
  surface.DrawTexturedRectRotated(w/2,40/2,w-2,40,180)
  draw.SimpleText("CITIZEN ID CARD","ESDefaultBold+",margin+4,margin+7,ES.Color.White)
  draw.SimpleText("EXCLRP OFFICIAL","ESDefault-",margin+4,margin-2,ES.Color.White)
end
local Container=vgui.RegisterTable( CONTAINER, "Panel" )
-- The vgui element people will use
local PNL={}
function PNL:Init()
  local w,h=180+180*(2/3),180

  self.container=vgui.CreateFromTable(Container,self,"Panel")
  self.container:SetSize(w,h);

  -- NOTE: Don't use docking here
  self.picture=self.container:Add("Spawnicon")
  self.picture:SetSize(120,120)
  self.picture:SetPos(margin,h-margin-self.picture:GetTall())
  self.picture.Paint = function(self,w,h)
    draw.RoundedBox(4,0,0,w,h,ES.Color["#0000005F"])
  end

  local xInfo = margin+self.picture:GetWide()+margin;
  local yInfo = h - margin - self.picture:GetTall();

  local lbl=self.container:Add("esLabel")
  lbl:SetPos(xInfo,yInfo)
  lbl:SetColor(ES.Color.Black)
  lbl:SetFont("ESDefaultBold")
  lbl:SetText("Name")
  lbl:SizeToContents()

  self.name=self.container:Add("esLabel")
  self.name:SetPos(xInfo+40,yInfo)
  self.name:SetColor(ES.Color.Black)
  self.name:SetFont("ESDefault")

  yInfo = yInfo + lbl:GetTall() + margin*.2

  local lbl=self.container:Add("esLabel")
  lbl:SetPos(xInfo,yInfo)
  lbl:SetColor(ES.Color.Black)
  lbl:SetFont("ESDefaultBold")
  lbl:SetText("Job")
  lbl:SizeToContents()

  self.job=self.container:Add("esLabel")
  self.job:SetPos(xInfo+40,yInfo)
  self.job:SetColor(ES.Color.Black)
  self.job:SetFont("ESDefault")

  self.color=ES.Color["#AAA"]
end
function PNL:Setup(char)
  if not char or not char.GetFullName or not IsValid(char.Player) then return end

  self.picture:SetModel(char.model)

  self.name:SetText(char:GetFullName())
  self.name:SizeToContents();

  self.job:SetText(team.GetName(char.Player:Team()));
  self.job:SizeToContents()

  self.color = team.GetColor(char.Player:Team())

end
function PNL:PerformLayout()
  self.container:Center()
end
function PNL:Paint(w,h)

end
vgui.Register("ERP.CharacterID",PNL,"Panel");
