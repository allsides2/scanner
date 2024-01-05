
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
local scanner = {}
Tunnel.bindInterface("scanner", scanner)
vCLIENT = Tunnel.getInterface("scanner")
-----------------------------------------------------------------------------------------------------------------------------------------
-- Prepares
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare("scanner/GetRanking", "SELECT * FROM  ALSD_scanner ORDER BY jobTime")

vRP.prepare("scanner/CreateHistory","INSERT INTO ALSD_scanner(id,playerId,history,jobTime,salario,created,lastUpgrade,newRole,isOnline) VALUES(@id,@playerId,@history,@jobTime,@salario,@created,@lastUpgrade,@newRole,@isOnline)")
 
--INSERT INTO ALSD_scanner (id,playerId, history, jobTime, salario, newRole, isOnline,created,lastUpgrade) 
--VALUES (1,3, '{"teste2"}', 100, 5000, 'Soldado', FALSE,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP);

-----------------------------------------------------------------------------------------------------------------------------------------
-- Variables
-----------------------------------------------------------------------------------------------------------------------------------------

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