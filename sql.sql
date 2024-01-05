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