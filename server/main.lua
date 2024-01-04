


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
local Hypex = {}
Tunnel.bindInterface("calladmin", Hypex)
vCLIENT = Tunnel.getInterface("calladmin")
-----------------------------------------------------------------------------------------------------------------------------------------
-- Prepares
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare("calladmin/GetRanking", "SELECT * FROM calladminranking ORDER BY Passport")
vRP.prepare("calladmin/CheckPassport", "SELECT Passport FROM CallAdminRanking WHERE Passport = @Passport")
vRP.prepare("calladmin/AddToRanking",
    "INSERT INTO CallAdminRanking(Passport, Name,Rating, TotalTicket) VALUES (@Passport, @Name, @Rating, @TotalTicket)")
vRP.prepare("calladmin/IncrementTicket",
    "UPDATE CallAdminRanking SET TotalTicket = TotalTicket + 1 WHERE Passport = @Passport")
vRP.prepare("calladmin/ResetAll", "DELETE FROM CallAdminRanking")
-----------------------------------------------------------------------------------------------------------------------------------------
-- Variables
-----------------------------------------------------------------------------------------------------------------------------------------