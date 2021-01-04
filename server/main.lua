local active = {}


ESX                 = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent("eff_smokes")

ESX.RegisterUsableItem('vape', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if active[_source] == nil or active[_source] == false then
		Citizen.Wait(500)
		active[_source] = true
		TriggerClientEvent("Vape:StartVaping", source, 0)
	elseif active[_source] == true then
		Citizen.Wait(500)
		active[_source] = false
		TriggerClientEvent("Vape:StopVaping", source, 0)
	end
end)

AddEventHandler("eff_smokes", function(entity)
	TriggerClientEvent("c_eff_smokes", -1, entity)
end)
