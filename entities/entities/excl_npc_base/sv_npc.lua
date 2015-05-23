-- NOTE: Nextbot is documented at https://github.com/garrynewman/garrysmod/blob/master/garrysmod/gamemodes/base/entities/entities/base_nextbot/sv_nextbot.lua

ENT.Model = "models/Humans/Group02/male_06.mdl";

function ENT:Initialize()
	self:SetModel( self.Model );
  self.Player = NULL; -- the player we're interacting with

  self:SetUseType(SIMPLE_USE);
end

function ENT:RunBehaviour()

	while ( true ) do

    -- set spped
    self.loco:SetDesiredSpeed( 100 )						-- walk speed

		-- go idle, wait for interaction.
		self:StartActivity( ACT_IDLE )							-- walk anims

    -- are we interacting with somebody?
    if IsValid(self.Player) and self.Player:EyePos():Distance(self:GetPos()+Vector(0,0,50)) < 100 then
      self.loco:FaceTowards( self.Player:EyePos() )
    else
      self.Player = NULL;
    end

		coroutine.yield()

	end


end

util.AddNetworkString("ERP.NPC.Interact")
function ENT:Use( ply )
  if not IsValid(ply) or not ply:IsPlayer() or not ply:IsLoaded() then return end

  ES.DebugPrint(ply:Nick().." used NPC")

  self.Player = ply;

  net.Start("ERP.NPC.Interact")
  net.WriteEntity(self)
  net.Send(ply)
end
