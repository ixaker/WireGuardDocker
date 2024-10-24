# Установка wireguard сервера с веб-интерфейсом

## проект Wg-easy
https://github.com/wg-easy/wg-easy

### Установка
1. Установка докера
    ```shell
    apt install curl -y
    curl -sSL https://get.docker.com | sh
    ```
2. Запуск приложения
    ```shell
    docker run --detach \
      --name wg-easy \
      --env LANG=ua \
      --env WG_HOST=<🚨YOUR_SERVER_IP> \
      --env PASSWORD_HASH='<🚨YOUR_ADMIN_PASSWORD_HASH>' \
      --env PORT=51821 \
      --env WG_PORT=51820 \
      --volume ~/.wg-easy:/etc/wireguard \
      --publish 51820:51820/udp \
      --publish 51821:51821/tcp \
      --cap-add NET_ADMIN \
      --cap-add SYS_MODULE \
      --sysctl 'net.ipv4.conf.all.src_valid_mark=1' \
      --sysctl 'net.ipv4.ip_forward=1' \
      --restart unless-stopped \
      ghcr.io/wg-easy/wg-easy
    ```
    💡 Замените YOUR_SERVER_IP своим IP адресом, или dns именем.
    💡 Замените YOUR_ADMIN_PASSWORD на пароль для веб-админки.

    Конфигурация сохраняется в `~/.wg-easy`.

3. Зайдите в веб интерфейс по адресу `http://<ваш ip>:51821`.

4. Обновление сервера.
Для обновления надо остановить докер, скачать новую версию докера и запустить его снова.

    ```shell
    docker stop wg-easy
    docker rm wg-easy
    docker pull weejewel/wg-easy
    ```

    И снова выполните из предыдущего пункта команду `docker run -d \ ...`.
