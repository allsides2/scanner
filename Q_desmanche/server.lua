local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
oC = {}
Tunnel.bindInterface("Q_desmanche",oC)
vCLIENT = Tunnel.getInterface("vrp_garages")
local idgens = Tools.newIDGenerator()

vRP._prepare("creative/set_detido","UPDATE vrp_user_vehicles SET detido = @detido, time = @time WHERE user_id = @user_id AND vehicle = @vehicle")
-----------------------------------------------------------------------------------------------------------------------------------
--[ ARRAY ]------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------
local modos = {
	{ item = "simples" },
	{ item = "medio" },
	{ item = "completo" }
}

local webhookdesmanche = "https://discord.com/api/webhooks/977575297241186345/iavmW6IutkvvROXtiiAKV624TaqWQc6ntqW_Df3_GeyRdDDRfjL1JY-bZPDjXbgZBx9a"

RegisterNetEvent('deletarveiculo')
AddEventHandler('deletarveiculo',function(vehicle)
	if IsEntityAVehicle(vehicle) then
		TriggerServerEvent("vrp_adv_garages_id",VehToNet(vehicle),GetVehicleEngineHealth(vehicle),GetVehicleBodyHealth(vehicle),GetVehicleFuelLevel(vehicle))
		TriggerServerEvent("trydeleteveh465767",VehToNet(vehicle))
	end
end)

function oC.checkVehicle()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local vehicle,vnetid,placa,vname,lock,banned,work = vRPclient.vehList(source,7)
		if vehicle and placa then
			local puser_id = vRP.getUserByRegistration(placa)
			if puser_id then
				local vehicle = vRP.query("creative/get_vehicles",{ user_id = parseInt(puser_id), vehicle = vname })
				if #vehicle <= 0 then
					TriggerClientEvent("Notify",source,"importante","Veículo não encontrado na lista do proprietário.",8000)
					return
				end
				if parseInt(vehicle[1].detido) == 1 then
					TriggerClientEvent("Notify",source,"aviso","Veículo encontra-se apreendido na seguradora.",8000)
					return
				end
				if banned then
					TriggerClientEvent("Notify",source,"negado","Veículos de serviço ou alugados não podem ser desmanchados.",8000)
					return
                end
                if user_id == puser_id then
					TriggerClientEvent("Notify",source,"aviso","Você não pode desmanchar o próprio veículo.",8000)
					return
				end	
			end
			return true			
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------
--[ EVENTOS ]----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("desmanchar-veiculo")
AddEventHandler("desmanchar-veiculo",function(item)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		--if vRP.tryGetInventoryItem(user_id,"militec",1) then
			TriggerClientEvent("fechar-nui-desmanche",source)
			local random = math.random(100)
			if random >= 55 then
				-- oC.MarcarOcorrencia()
			end
			SetTimeout(70000,function()
				desmancheCarros(source)
				-- vRP.giveInventoryItem(user_id,"roda",4)
				-- vRP.giveInventoryItem(user_id,"motor",1)
				-- vRP.giveInventoryItem(user_id,"porta",2)
				-- vRP.giveInventoryItem(user_id,"parachoque",2)
				TriggerClientEvent("Notify",source,"sucesso","Veículo desmanchado com <b>sucesso</b>!")
			end)
		-- else
		--     TriggerClientEvent("fechar-nui-desmanche",source)
		--     TriggerClientEvent("Notify",source,"negado","Você necessita de uma <b>Chave Mestra</b> para <b>desmanchar um veículo</b>.")
		-- end
	end
end)
-------------------------------------------------------------------------------------------------------------------------------------
--[ FUNÇÃO CHAMAR POLICIA ]----------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
-- local blips = {}
-- function oC.MarcarOcorrencia()
-- 	local source = source
-- 	local user_id = vRP.getUserId(source)
-- 	local x,y,z = vRPclient.getPosition(source)
-- 	local identity = vRP.getUserIdentity(user_id)
-- 	if user_id then
-- 		local soldado = vRP.getUsersByPermission("policia.permissao")
-- 		for l,w in pairs(soldado) do
-- 			local player = vRP.getUserSource(parseInt(w))
-- 			if player then
-- 				async(function()
-- 					local id = idgens:gen()
-- 					blips[id] = vRPclient.addBlip(player,x,y,z,10,84,"Ocorrência",0.5,false)
-- 					vRPclient._playSound(player,"CONFIRM_BEEP","HUD_MINI_GAME_SOUNDSET")
-- 					TriggerClientEvent('chatMessage',player,"911",{64,64,255},"Recebemos uma denuncia de desmanche, verifique o ocôrrido.")
-- 					SetTimeout(20000,function() vRPclient.removeBlip(player,blips[id]) idgens:free(id) end)
-- 				end)
-- 			end
-- 		end
-- 	end
-- end
function oC.checkPermissao()
    local source = source
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"desmanchefarm.permissao") or vRP.hasPermission(user_id,"admin.permissao") then
        return true
    else
        TriggerClientEvent("Notify",source,"negado","Você não possui permissão para utilizar o <b>desmanche</b>!")
    end
end

function desmancheCarros(source)
	local user_id = vRP.getUserId(source)
	if user_id then
		local vehicle,vnetid,placa,vname,lock,banned = vRPclient.vehList(source,7)
		if vehicle and placa then
			local puser_id = vRP.getUserByRegistration(placa)
			local pecas = 0
			if puser_id then
				vRP.execute("creative/set_detido",{ user_id = parseInt(puser_id), vehicle = vname, detido = 1, time = parseInt(os.time()) })
				
				if vRP.vehicleType(vname) == 'import' then
					pecas = math.floor(vRP.vehiclePrice(vname))
				else
					pecas = math.floor(vRP.vehiclePrice(vname)/1000)
				end
				
				if pecas >= 600 then pecas = 600 end

				vRP.giveInventoryItem(user_id,"partecarro",parseInt(pecas),true)
				
				TriggerClientEvent('deletarveiculo',source,vehicle)
				local identity = vRP.getUserIdentity(user_id)
				vRP.log(webhookdesmanche,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[DESMANCHOU]: "..vname.." [ID]: "..puser_id.." \n[PEÇAS]: "..parseInt(pecas).." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
			end
		end
	end
end

-- RegisterCommand('desmanchar',function (source)
-- 	desmancheCarros(source)
-- end)