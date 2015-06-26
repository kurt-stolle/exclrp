local npc=ERP.NPC();
npc:SetName("Shady Sheen")
npc:SetDescription("A filthy looking nigger with a metal leg and a frowny face.")
npc:SetModel("models/Eli.mdl")

if CLIENT then
  npc:SetDialogConstructor(function(self,context,npc)
    ES.DebugPrint("Opening gangster menu")

    local lbl=context:Add("DLabel")
    lbl:SetText("WARNING: Changing your job will strip you of ALL your weapons!")
    lbl:SetColor(ES.Color.White)
    lbl:SetFont("ESDefault")
    lbl:SizeToContents()
    lbl:Dock(TOP)
    lbl:DockMargin(10,10,10,0)

    local btn=context:Add("esButton")
    btn:SetText("Become a gangster")
    btn:SetTall(30)
    btn:Dock(TOP)
    btn:DockMargin(10,10,10,10)
    btn.DoClick = function()
      npc:Interact("job")
    end
  end)
elseif SERVER then
  npc:AddInteraction("job",function(ply)
    if not IsValid(ply) or not ply:IsLoaded() then return end

    ply:GetCharacter():SetJob("Gangster")
  end)
end
npc();
