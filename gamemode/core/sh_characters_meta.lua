local CHARACTER=FindMetaTable("Character");

function CHARACTER:GetFirstName()
	return self.Player:ESGetNetworkedVariable("firstName","John");
end

function CHARACTER:GetLastName()
	return self.Player:ESGetNetworkedVariable("lastName","Doe");
end

function CHARACTER:GetFullName()
	return (self:GetFirstName().." "..self:GetLastName());
end
