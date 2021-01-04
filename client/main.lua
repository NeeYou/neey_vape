


	local IsPlayerAbleToVape = false
	local FadeIn = false
	local FadeOut = false

RegisterNetEvent("Vape:StartVaping")
RegisterNetEvent("Vape:VapeAnimFix")
RegisterNetEvent("Vape:StopVaping")
RegisterNetEvent("Vape:Drag")

AddEventHandler("Vape:StartVaping", function(source)
	local ped = GetPlayerPed(-1)
	if DoesEntityExist(ped) and not IsEntityDead(ped) then
		if IsPedOnFoot(ped) then
			if IsPlayerAbleToVape == false then
				PlayerIsAbleToVape()
				TriggerEvent("Vape:HelpFadeIn", 0)
				ShowNotification("~c~Użyłeś ~c~e-papieros'a.")
				Wait(Config.HelpTextLength)
				TriggerEvent("Vape:HelpFadeOut", 0)
			else
				ShowNotification("~r~Już używasz e-papieros'a.")
			end
		else
			ShowNotification("~r~Nie możesz użyc tego w aucie.")
		end
	end
end)
AddEventHandler("Vape:VapeAnimFix", function(source)
	local ped = GetPlayerPed(-1)
	local ad = "anim@heists@humane_labs@finale@keycards"
	local anim = "ped_a_enter_loop"
	while (not HasAnimDictLoaded(ad)) do
		RequestAnimDict(ad)
	  Wait(1)
	end
	TaskPlayAnim(ped, ad, anim, 8.00, -8.00, -1, (2 + 16 + 32), 0.00, 0, 0, 0)
end)
AddEventHandler("Vape:StopVaping", function(source)
	if IsPlayerAbleToVape == true then
		PlayerIsUnableToVape()
		ShowNotification("~c~Schowałeś e-papieros'a do kieszeni.")
	else
		ShowNotification("~r~Musisz trzymać e-papieros'a w ręce.")
	end
end)
AddEventHandler("Vape:Drag", function()
	if IsPlayerAbleToVape then
		local ped = GetPlayerPed(-1)
		local PedPos = GetEntityCoords(ped)
		local ad = "mp_player_inteat@burger"
		local anim = "mp_player_int_eat_burger"
		if (DoesEntityExist(ped) and not IsEntityDead(ped)) then
			while (not HasAnimDictLoaded(ad)) do
				RequestAnimDict(ad)
			  Wait(1)
			end
			TaskPlayAnim(ped, ad, anim, 8.00, -8.00, -1, (2 + 16 + 32), 0.00, 0, 0, 0)
			PlaySoundFrontend(-1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1)
			  	Wait(950)
			TriggerServerEvent("eff_smokes", PedToNet(ped))
			  	Wait(Config.VapeHangTime-1000)
			TriggerEvent("Vape:VapeAnimFix", 0)
		end
	else
		ShowNotification("~r~Musisz trzymać e-papieros'a w ręce.")
	end
end)

p_smoke_location = {
	20279,
}
p_smoke_particle = "exp_grd_bzgas_smoke"
p_smoke_particle_asset = "core" 
RegisterNetEvent("c_eff_smokes")
AddEventHandler("c_eff_smokes", function(c_ped)
	for _,bones in pairs(p_smoke_location) do
		if DoesEntityExist(NetToPed(c_ped)) and not IsEntityDead(NetToPed(c_ped)) then
			createdSmoke = UseParticleFxAssetNextCall(p_smoke_particle_asset)
			createdPart = StartParticleFxLoopedOnEntityBone(p_smoke_particle, NetToPed(c_ped), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, GetPedBoneIndex(NetToPed(c_ped), bones), Config.SmokeSize, 0.0, 0.0, 0.0)
			Wait(Config.VapeHangTime)
			--Wait(250)
			while DoesParticleFxLoopedExist(createdSmoke) do
				StopParticleFxLooped(createdSmoke, 1)
			  Wait(0)
			end
			while DoesParticleFxLoopedExist(createdPart) do
				StopParticleFxLooped(createdPart, 1)
			  Wait(0)
			end
			while DoesParticleFxLoopedExist(p_smoke_particle) do
				StopParticleFxLooped(p_smoke_particle, 1)
			  Wait(0)
			end
			while DoesParticleFxLoopedExist(p_smoke_particle_asset) do
				StopParticleFxLooped(p_smoke_particle_asset, 1)
			  Wait(0)
			end
			Wait(Config.VapeHangTime*3)
			RemoveParticleFxFromEntity(NetToPed(c_ped))
			break
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		local ped = GetPlayerPed(-1)
		if IsPedInAnyVehicle(ped, true) then
			PlayerIsEnteringVehicle()
		end
		if IsPlayerAbleToVape then
			if IsControlPressed(0, Config.DragControl) then
			  Wait(Config.ButtonHoldTime)
				if IsControlPressed(0, Config.DragControl) then
					TriggerEvent("Vape:Drag", 0)
				end
			  Wait(Config.VapeCoolDownTime)
			end
			if IsControlPressed(0, Config.RestingAnim) then
			  Wait(Config.ButtonHoldTime)
				if IsControlPressed(0, Config.RestingAnim) then
					TriggerEvent("Vape:VapeAnimFix", 0)
				end
			  Wait(1000)
			end
		end
	  Wait(1)
	end
end)

Citizen.CreateThread(function()
	while true do
		if IsPlayerAbleToVape then
			if DisplayText then
				local ped = GetPlayerPed(-1)
				local pedPos = GetEntityCoords(ped)
				DrawText3d(pedPos.x, pedPos.y, pedPos.z+1.20, "~c~Kliknij ~b~\"E\"~c~ aby wziąść bucha.")
			end
		end
	  Wait(1)
	end
end)

function PlayerIsAbleToVape()
	IsPlayerAbleToVape = true
	local ped = GetPlayerPed(-1)
	local ad = "anim@heists@humane_labs@finale@keycards"
	local anim = "ped_a_enter_loop"

	while (not HasAnimDictLoaded(ad)) do
		RequestAnimDict(ad)
	  Wait(1)
	end
	TaskPlayAnim(ped, ad, anim, 8.00, -8.00, -1, (2 + 16 + 32), 0.00, 0, 0, 0)

	local x,y,z = table.unpack(GetEntityCoords(ped))
	local prop_name = "ba_prop_battle_vape_01"
	VapeMod = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)
	AttachEntityToEntity(VapeMod, ped, GetPedBoneIndex(ped, 18905), 0.08, -0.00, 0.03, -150.0, 90.0, -10.0, true, true, false, true, 1, true)
end
function PlayerIsEnteringVehicle()
	IsPlayerAbleToVape = false
	local ped = GetPlayerPed(-1)
	local ad = "anim@heists@humane_labs@finale@keycards"
	DeleteObject(VapeMod)
	TaskPlayAnim(ped, ad, "exit", 8.00, -8.00, -1, (2 + 16 + 32), 0.00, 0, 0, 0)
end
function PlayerIsUnableToVape()
	IsPlayerAbleToVape = false
	local ped = GetPlayerPed(-1)
	DeleteObject(VapeMod)
	ClearPedTasksImmediately(ped)
	ClearPedSecondaryTask(ped)
end
function ShowNotification( text )
    SetNotificationTextEntry( "STRING" )
    AddTextComponentString( text )
    DrawNotification( false, false )
end

function DrawText3D(x, y, z, text)
    local onScreen,_x,_y=World3dToScreen2d(x, y, z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.37, 0.37)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 11, 11, 11, 90)
end
