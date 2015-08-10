-- Function
function resourceDir(dir)
	local fils,dirs = file.Find(dir.."/*","GAME")
	for k,v in pairs(fils) do
		resource.AddSingleFile( string.gsub(string.gsub(dir,"gamemodes/exclrp/content/",""),"//","/").."/"..v )
	end
	for k,v in pairs(dirs)do
	   _G.resourceDir(dir.."/"..v)
	end
end

resourceDir("gamemodes/exclrp/content")
