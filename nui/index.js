let isPlayerOnJob = false;
        let OPENNUI = 0;

        function startScan() {
            OPENNUI = OPENNUI + 1;
            document.querySelector('.imgdelf').disabled = true;
            document.querySelector('.imgdelf').style.transition = 'opacity 0.7s ease-in-out';
            document.querySelector('.imgdelf').style.opacity = '0';
            document.getElementById('fingerprint').style.display = 'block';
            document.getElementById('scanStatus').style.display = 'block';
            document.getElementById('fingerprint').style.animation = 'none';
            document.getElementById('fingerprint').offsetHeight;
            document.getElementById('fingerprint').style.animation = null;

            let serviceMessage, statusColor;
            if (isPlayerOnJob) {
                serviceMessage = 'Checando...';
                statusColor = '#FF0000'; // Vermelho
            } else {
                serviceMessage = 'Checando...';
                statusColor = '#0000FF'; // Azul
            }

            if (OPENNUI == 1) {
                document.getElementById('scanStatus').innerText = serviceMessage;
                document.getElementById('scanStatus').style.color = '#0000FF'; // Azul
            }

            setTimeout(() => {
                let info = {
                    name: "teste",
                    isJob: isPlayerOnJob,
                    isPolice: true,
                    horasTrabalhadas: 10,
                };

                if (isPlayerOnJob) {
                    document.querySelector('.imgdelf').src = 'https://cdn.discordapp.com/attachments/1060339950027034704/1191530794850721816/f93c94129b6b89c40b9a77c91efd4f5f_1.png?ex=65a5c687&is=65935187&hm=f4124fcb9df14c45a14975fb9b361fe766c2a17854addb4e0ebda6c4e2d78dfd&';
                } else {
                    document.querySelector('.imgdelf').src = 'https://cdn.discordapp.com/attachments/1060339950027034704/1191518553304748123/fingerprint.png?ex=65a5bb20&is=65934620&hm=b047358468d5288c19818b976b1a456a1e97b73ce4ee41bfc5edea091ed9b17a&';
                }

                if (OPENNUI == 1) {
                    // Adicione o seguinte bloco para exibir as horas trabalhadas
                    if (isPlayerOnJob) {
                        document.getElementById('horasTrabalhadas').innerText = `Horas Trabalhadas: ${info.horasTrabalhadas}`;
                        document.getElementById('horasTrabalhadas').classList.remove('hidden');
                    } else {
                        document.getElementById('horasTrabalhadas').classList.add('hidden');
                    }
                }

                let fingerprintElements = document.getElementsByClassName('fingerprint');
                for (let i = 0; i < fingerprintElements.length; i++) {
                    fingerprintElements[i].style.display = 'none';
                }

                document.querySelector('.imgdelf').disabled = false;
                document.querySelector('.imgdelf').style.opacity = '1';

                serviceMessage = isPlayerOnJob ? 'Em serviço' : 'Sem serviço';
                statusColor = isPlayerOnJob ? '#008000' : '#FF0000';
                document.getElementById('scanStatus').innerText = serviceMessage;
                document.getElementById('scanStatus').style.color = statusColor;
                document.getElementById('scanStatus').style.filter = `drop-shadow(0 0 20px ${statusColor}) drop-shadow(0 0 60px ${statusColor})`;
            }, 3000);

            isPlayerOnJob = !isPlayerOnJob;
        }