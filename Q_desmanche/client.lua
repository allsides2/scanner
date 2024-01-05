local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
oC = Tunnel.getInterface("Q_desmanche")
-------------------------------------------------------------------------------------------------
--[ LOCAL ]--------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------
local prodMachine = {
 	{ ['x'] = 174.61, ['y'] = 6382.48, ['z'] = 32.74 }, --desmanche 1
    { ['x'] = 1182.67, ['y'] = 2638.24, ['z'] = 37.8 }, -- desmanche 2

 }
-------------------------------------------------------------------------------------------------
--[ MENU ]---------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------
local menuactive = false
local onmenu = false
local checkdesmanche = false
local emservico = false

function ToggleActionMenu()
	menuactive = not menuactive
	if menuactive then
		SetNuiFocus(true,true)
		TransitionToBlurred(1000)
		SendNUIMessage({ showmenu = true })
	else
		SetNuiFocus(false)
		TransitionFromBlurred(1000)
		SendNUIMessage({ hidemenu = true })
	end
end
-------------------------------------------------------------------------------------------------
--[ BOTÕES ]-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------
RegisterNUICallback("ButtonClick",function(data,cb)
	if data == "desmanchar-simples" and not roubando and oC.checkVehicle() and oC.checkPermissao() then
		TriggerServerEvent("desmanchar-veiculo","simples")
		local ped = PlayerPedId()
		emservico = true
		roubando = true
		checkdesmanche = true
		segundos = 30
		FreezeEntityPosition(GetVehiclePedIsUsing(ped),true)

		repeat
			Citizen.Wait(10)
		until segundos == 0 and emservico

		oC.desmancheCarros()
		emservico = false
		roubando = false
		checkdesmanche = false

	elseif data == "desmanchar-medio" and not roubando and oC.checkVehicle() and oC.checkPermissao() then
		TriggerServerEvent("desmanchar-veiculo","medio")
		local ped = PlayerPedId()
				emservico = true
				roubando = true
				checkdesmanche = true
				segundos = 50
				FreezeEntityPosition(GetVehiclePedIsUsing(ped),true)

				repeat
					Citizen.Wait(10)
				until segundos == 0 and emservico
		
				oC.desmancheCarros()
				--oC.desmanchar()
				emservico = false
				roubando = false
				checkdesmanche = false

	elseif data == "desmanchar-completo" and not roubando and oC.checkVehicle() and oC.checkPermissao() then
		TriggerServerEvent("desmanchar-veiculo","completo")
		local ped = PlayerPedId()
		emservico = true
		roubando = true
		checkdesmanche = true
		segundos = 70
		FreezeEntityPosition(GetVehiclePedIsUsing(ped),true)
		DisableControlAction(0,75)

		repeat
			Citizen.Wait(10)
		until segundos == 0 and emservico

		emservico = false
		roubando = false
		checkdesmanche = false

	elseif data == "fechar" then
		ToggleActionMenu()
		onmenu = false
	end
end)

RegisterNetEvent("abrir-nui-desmanche")
AddEventHandler("abrir-nui-desmanche", function()
	local ped = PlayerPedId()
	for k,v in pairs(prodMachine) do
		local distance = #(vector3(v.x,v.y,v.z) - GetEntityCoords(ped))
		if distance <= 15 then
			if GetPedInVehicleSeat(GetVehiclePedIsUsing(ped),-1) == ped then
				ToggleActionMenu()
				onmenu = true
				return true
			else
				TriggerEvent("Notify","negado","Você precisa estar no <b>P1</b> para desmanchar veículos.")
				return false
			end
		else
			TriggerEvent("Notify","negado","Você não está em um oficina de desmanche.")
		end
	end
end)

RegisterNetEvent("fechar-nui-desmanche")
AddEventHandler("fechar-nui-desmanche", function()
	ToggleActionMenu()
	onmenu = false
end)
-------------------------------------------------------------------------------------------------
--[ AÇÃO ]---------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
 	while true do
 		wait = 1000
		if not roubando then
			local ped = PlayerPedId()
			for k,v in pairs(prodMachine) do
				local distance = #(vector3(v.x,v.y,v.z) - GetEntityCoords(ped))
				if distance <= 15 then
					wait = 5
					DrawMarker(23,v.x,v.y,v.z-2.2,0,0,0,0,0,0,5.0,5.0,0.5,255,0,0,50,0,0,0,0)	
					if distance <= 3 then
						DrawText3D(v.x,v.y,v.z-2.2, "[~p~E~w~] Para acessar o ~p~DESMANCHE DE VEÍCULOS~w~.")
						if IsControlJustPressed(0,38) and oC.checkVehicle() and oC.checkPermissao() then
							if GetPedInVehicleSeat(GetVehiclePedIsUsing(ped),-1) == ped then
								ToggleActionMenu()
								onmenu = true
							else
								TriggerEvent("Notify","negado","Você precisa estar no <b>P1</b> para desmanchar veículos.")
							end
						end
					end
				end
			end
		end
		Citizen.Wait(wait)
 	end
end)
-------------------------------------------------------------------------------------------------------------
--[ DESABILITAR TECLAS ]-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		wait = 1000
		if roubando then
			wait = 5
			if segundos > 0 then
				DisableControlAction(0,356,true)
				DisableControlAction(0,355,true)
				DisableControlAction(0,351,true)
				DisableControlAction(0,309,true)
				DisableControlAction(0,245,true)
				DisableControlAction(0,206,true)
				DisableControlAction(0,184,true)
				DisableControlAction(0,169,true)
				DisableControlAction(0,153,true)
				DisableControlAction(0,119,true)
				DisableControlAction(0,103,true)
				DisableControlAction(0,86,true)
				DisableControlAction(0,75,true)
				DisableControlAction(0,54,true)
				DisableControlAction(0,51,true)
				DisableControlAction(0,46,true)
				DisableControlAction(0,38,true)
				DisableControlAction(0,20,true)
			end
		end
		Citizen.Wait(wait)
	end
end)
-------------------------------------------------------------------------------------------------
--[ TEXTOS ]-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		wait = 1000
		local veh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
		if roubando then
			wait = 5
			if segundos >= 33 then
			
			elseif segundos > 19 and segundos < 33 then
				if GetPedInVehicleSeat(veh,-1) == GetPlayerPed(-1) then
					local running = Citizen.InvokeNative(0xAE31E7DF9B5B132E,veh)
					SetVehicleEngineOn(veh,not running,true,true)
					if running then
						SetVehicleUndriveable(vehicle,true)
					end
				end
				TriggerEvent("Notify","sucesso","Abrindo as <b>Portas do veículo</b>.",4000)
				Citizen.Wait(2000)
				SetVehicleDoorOpen(veh,0,0,0)
				Citizen.Wait(2000)	
				SetVehicleDoorOpen(veh,1,0,0)
				Citizen.Wait(2000)
				SetVehicleDoorOpen(veh,2,0,0)
				Citizen.Wait(2000)	
				SetVehicleDoorOpen(veh,3,0,0)
				Citizen.Wait(2000)
				SetVehicleDoorOpen(veh,4,0,0)
				Citizen.Wait(2000)
				SetVehicleDoorOpen(veh,5,0,0)
				Citizen.Wait(2000)
				SetVehicleDoorOpen(veh,6,0,0)
			elseif segundos <= 16 and segundos > 4 then
				TriggerEvent("Notify","sucesso","Desmontando as <b>Peças do veículo</b>.",14000)
				SetVehicleDoorBroken(veh, 0	, false)
				SetVehicleTyreBurst(veh, 0, 1)
				Citizen.Wait(2000)
				SetVehicleDoorBroken(veh, 1	, false)
				SetVehicleTyreBurst(veh, 1, 1)
				Citizen.Wait(2000)
				SetVehicleDoorBroken(veh, 2	, false)
				SetVehicleTyreBurst(veh, 2, 1)
				Citizen.Wait(2000)
				SetVehicleDoorBroken(veh, 3	, false)
				SetVehicleTyreBurst(veh, 3, 1)
				Citizen.Wait(2000)
				SetVehicleDoorBroken(veh, 4	, false)
				SetVehicleTyreBurst(veh, 4, 1)
				Citizen.Wait(2000)
				SetVehicleDoorBroken(veh, 5	, false)
				SetVehicleTyreBurst(veh, 5, 1)
				Citizen.Wait(2000)
				SetVehicleDoorBroken(veh, 6	, false)
				Citizen.Wait(2000)
			end
		end
		Citizen.Wait(wait)
	end
end)

Citizen.CreateThread(function()
	while true do
		wait = 1000
		local veh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
		if roubando then
			wait = 5
			if segundos >= 33 then
				drawTxt("AGUARDE ~p~"..segundos.." SEGUNDOS~w~, ENQUANTO O ~p~RASTREADOR ~w~DO VEÍCULO É DESATIVADO",4,0.50,0.87,0.50,255,255,255,180)
			elseif segundos > 19 and segundos < 33 then
				drawTxt("AGUARDE ~p~"..segundos.." SEGUNDOS~w~, ENQUANTO AS ~p~PEÇAS ~w~DO VEÍCULO SÃO DESPARAFUSADAS",4,0.50,0.87,0.50,255,255,255,180)
			elseif segundos < 19 and segundos > 16 then
				drawTxt("AGUARDE ~p~"..segundos.." SEGUNDOS~w~, PEÇAS DESPARAFUSADAS",4,0.50,0.87,0.50,255,255,255,180)
			elseif segundos <= 16 and segundos >= 4 then
				drawTxt("AGUARDE ~p~"..segundos.." SEGUNDOS~w~, ENQUANTO O ~p~VEÍCULO ~w~ É DESMANCHADO",4,0.50,0.87,0.50,255,255,255,180)
			elseif segundos < 4 then
				drawTxt("AGUARDE ~p~"..segundos.." SEGUNDOS~w~, FINALIZANDO DESMANCHE",4,0.50,0.87,0.50,255,255,255,180)
			end
		end
		Citizen.Wait(wait)
	end
end)

---------------------------------------------------------------------------------------------------------
--[ DIMINUIR TEMPO ]-------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if roubando then
			if segundos > 0 then
				DisableControlAction(0,356,true)
				DisableControlAction(0,355,true)
				DisableControlAction(0,351,true)
				DisableControlAction(0,309,true)
				DisableControlAction(0,245,true)
				DisableControlAction(0,206,true)
				DisableControlAction(0,184,true)
				DisableControlAction(0,169,true)
				DisableControlAction(0,153,true)
				DisableControlAction(0,119,true)
				DisableControlAction(0,103,true)
				DisableControlAction(0,86,true)
				DisableControlAction(0,75,true)
				DisableControlAction(0,54,true)
				DisableControlAction(0,51,true)
				DisableControlAction(0,46,true)
				DisableControlAction(0,38,true)
				segundos = segundos - 1
			end
		end
	end
end)
-------------------------------------------------------------------------------------------------
--[ FUNÇÃO ]-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------
function DrawText3D(x, y, z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.28, 0.28)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.005+ factor, 0.03, 41, 11, 41, 68)
end

function drawTxt(text,font,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextScale(scale,scale)
	SetTextColour(r,g,b,a)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end