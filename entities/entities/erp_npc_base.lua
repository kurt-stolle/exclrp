AddCSLuaFile()

ENT.Base = "base_ai"

ENT.PrintName		= "Unidentified NPC"
ENT.Author			= "Excl"
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""

ENT.Spawnable			= false
ENT.AdminOnly			= true

ENT.AutomaticFrameAdvance = true

ENT.Model = "models/Humans/Group02/male_06.mdl";

if SERVER then
  function ENT:Initialize()
    self:SetModel( self.Model );

	  self:SetSolid( SOLID_BBOX )
	  self:SetMoveType( MOVETYPE_STEP )

    self:SetNPCState( NPC_STATE_IDLE )

    self:SetHullType( HULL_HUMAN )
   	self:SetHullSizeNormal( )

   	self:DropToFloor()

	  self:CapabilitiesAdd( CAP_ANIMATEDFACE )
    self:CapabilitiesAdd( CAP_TURN_HEAD )

    self:SetUseType(SIMPLE_USE);

    ES.DebugPrint("Initializing NPC")
  end

  util.AddNetworkString("ERP.NPC.Interact")
  function ENT:AcceptInput( inputName, ply )
    if not IsValid(ply) or not ply:IsPlayer() or not ply:IsLoaded() or inputName ~= "Use" then return false end

    ES.DebugPrint(ply:Nick().." used NPC")

    self:SetTarget(ply)
    self:IdleSound()

    net.Start("ERP.NPC.Interact")
    net.WriteEntity(self)
    net.WriteString(self.PrintName)
    net.Send(ply)

    return false
  end

elseif CLIENT then
  net.Receive("ERP.NPC.Interact",function()
    local ent=net.ReadEntity();
    local name=net.ReadString();
    local ply=LocalPlayer()

    if not IsValid(ent) or not ERP.NPCs[name] or not ply:IsLoaded() then
      ES.DebugPrint("Invalid interaction with "..(IsValid(ent) and ent:GetClass() or "nil"))
      return;
    end

    -- Hacky stuff below, but sadly no other way to do it.
    if not ent.Interact then
      function ent:Interact(name,...)
        net.Start("ERP.NPC.Interact");
        net.WriteEntity(self)
        net.WriteString(name)
        net.WriteTable{...}
        net.SendToServer()
      end
    end

    -- Create the dialog.
    local frame=vgui.Create("esFrame");
    frame:SetTitle("NPC Interaction");
    frame:SetSize(780,500);

    local context=vgui.Create("esPanel",frame)
    context:Dock(FILL)
    context:DockMargin(10,10,10,10)
    context:DockPadding(10,10,10,10)
    context:SetColor(ES.Color["#1E1E1E"])

      ERP.NPCs[name]:GetDialogConstructor()(ent,context,ent)

    local npcInfo=vgui.Create("esPanel",frame)
    npcInfo:SetWide(200)
    npcInfo:Dock(LEFT)
    npcInfo:DockMargin(10,10,0,10)

      local modelContainer=vgui.Create("esPanel",npcInfo)
      modelContainer:SetTall(npcInfo:GetWide())
      modelContainer:Dock(TOP)
      modelContainer:SetColor(ES.Color["#000000AA"])

      local model=vgui.Create("Spawnicon",modelContainer)
      model:SetSize(modelContainer:GetTall()-2,modelContainer:GetTall()-2)
      model:Dock(FILL)
      model:DockMargin(1,1,1,1)
      model:SetModel(ent:GetModel())

      local PrintName=vgui.Create("esLabel",npcInfo)
      PrintName:SetText( ERP.NPCs[name]:GetName() )
      PrintName:SetFont("ESDefault+")
      PrintName:Dock(TOP)
      PrintName:DockMargin(10,10,10,0)
      PrintName:SizeToContents()
      PrintName:SetColor(ES.Color.White)

      local descr=vgui.Create("esLabel",npcInfo)
      descr:SetText( ES.FormatLine(ERP.NPCs[name]:GetDescription(),"ESDefault",180,0) )
      descr:SetFont("ESDefault")
      descr:Dock(TOP)
      descr:DockMargin(10,4,10,10)
      descr:SizeToContents()
      descr:SetColor(ES.Color.White)

      local close=vgui.Create("esButton",npcInfo)
      close:SetTall(30)
      close:SetText("Leave")
      close.DoClick=function()
        frame:Remove()
      end
      close:Dock(BOTTOM)
      close:DockMargin(10,10,10,10)

    frame:Center()
    frame:MakePopup()
  end)
end
