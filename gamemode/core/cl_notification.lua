-- override with the ExclServer notification system.

function notification.AddLegacy(text)
	ES.Notify("generic",text)
end