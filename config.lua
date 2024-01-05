Config = {
  label = {
    checking="CHECANDO...",
    inService="EM SERVIÇO",
    noService="SEM SERVIÇO",
    timeJob="HORAS TRABALHADAS: ",
  },
  police = {
    roles={
      [1] = {roleName = "Comandante", initialWage = 25000 },
      [2] = {roleName = "Tenente", initialWage = 17000 },
      [3] = {roleName = "Sargento", initialWage = 12000 },
      [4] = {roleName = "Cabo", initialWage = 7000 },
      [5] = {roleName = "Soldado", initialWage = 5000 },
    },


    promotionTime = 25, -- horas para o jogador ganhar aumento de salario.
    promotionBuff= 15, -- porcentagem de aumento de salario. ex: 10 = 10% de salario quando o jogador bater o promotiontime
 
  },
}