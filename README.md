Mobiauto Mautic
===========
![Mautic](.github/readme_image.png "Mautic Open Source Marketing Automation")

## Introdução

Versão modificada do [https://github.com/mautic/mautic](https://github.com/mautic/mautic)

## Passo a passo: Criando ambiente local de desenvolvimento

1. Clone este projeto
2. Instale em sua maquina o Docker e o Docker compose
3. Instale o MKCERT [https://github.com/FiloSottile/mkcert](https://github.com/FiloSottile/mkcert)
4. Gere no MKCERT certificados para o domínio mautic.test (Veja 5 e 6)
5. Rode o comando "mkcert -install"
6. Rode o comando "mkcert mautic.test"
7. Pegue os 2 arquivos gerados pelo mkcert (_wildcard.mautic.test+1.pem e _wildcard.mautic.test+1-key.pem) e cole-os na raiz do projeto
8. Edite seu arquivo /etc/hosts (Veja 9)
9. Rode o comando "sudo gedit /etc/hosts"
10. Adicione ao arquivo a seguinte linha:

```
127.0.0.1   mautic.test
```

1. Na raiz do projeto rode o comando "docker-compose up -d" 
2. Execute agora o comando "docker-compose ps"
3. Copie agora o nome do container onde roda o PHP
4. Execute o comando "docker exec -it -u www-data <NOME DO CONTAINER> /bin/bash"
5. Já dentro do container, execute o comando: "composer install"
6. No navegador acesse [https://mautic.test](https://mautic.test)
7. Pronto, seu mautic local está rodando, siga os procedimentos adicionais de configuração na tela

