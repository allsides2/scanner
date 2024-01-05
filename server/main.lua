
-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRPC = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
local scannerC = {}
Tunnel.bindInterface("scanner", scannerC)
vCLIENT = Tunnel.getInterface("scanner")
-----------------------------------------------------------------------------------------------------------------------------------------
-- Prepares
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare("scanner/GetRanking", "SELECT * FROM ALSD_scanner ORDER BY jobTime")

vRP.prepare("scanner/GetTimeJob", "SELECT jobTime FROM ALSD_scanner WHERE id = @id")
vRP.prepare("scanner/updateJobTime","UPDATE ALSD_scanner SET jobTime = @jobTime WHERE id = @id")

vRP.prepare("scanner/CreateHistory","INSERT INTO ALSD_scanner(id,playerId,history,jobTime,salario,created,lastUpgrade,newRole,isOnline) VALUES(@id,@playerId,@history,@jobTime,@salario,@created,@lastUpgrade,@newRole,@isOnline)")
 
--INSERT INTO ALSD_scanner (id,playerId, history, jobTime, salario, newRole, isOnline,created,lastUpgrade) 
--VALUES (1,3, '{"teste2"}', 100, 5000, 'Soldado', FALSE,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP);

-----------------------------------------------------------------------------------------------------------------------------------------
-- Variables
-----------------------------------------------------------------------------------------------------------------------------------------

function vCLIENT.getTimeJob()
    local source = source
    local id = vRP.getUserId(source)
    if id then
        local TimeJob = vRP.query("scanner/GetTimeJob",{ id = id })
        return TimeJob[1] or false
    end

end


function vCLIENT.setTimeJob(time)
    local source = source
    local time = time
    local id = vRP.getUserId(source)
    if id then
        vRP.execute("scanner/updateJobTime",{ id = id, jobTime = time })
        return
    end


end

/*

CREATE TABLE ALSD_scanner (
    id INT PRIMARY KEY,
    playerId INT,
    history LONGTEXT,
    jobTime INT,
    salario INT,
    created DATE,
    lastUpgrade DATE,
    newRole VARCHAR(255),
    isOnline BOOLEAN
);

*/
