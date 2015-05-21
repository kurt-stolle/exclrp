local CHARACTER=FindMetaTable("Character");

function CHARACTER:GetFullName()
	return (self:GetFirstName() or "").." "..(self:GetLastName() or "");
end

function CHARACTER:GetJob()
	return ERP.Jobs[self.Player:Team()] or false;
end
