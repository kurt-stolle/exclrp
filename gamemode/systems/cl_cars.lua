net.Receive("exclrp.cars.get",function()
  if not LocalPlayer():IsLoaded() then return end

  local cars=net.ReadTable();

  LocalPlayer():GetCharacter()._cars=cars

  hook.Call("ERPCarsUpdated",GAMEMODE,LocalPlayer(),LocalPlayer():GetCharacter(),cars)
end)
