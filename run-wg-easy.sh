#!/bin/bash

# Спросить пароль у пользователя
read -sp "Введите пароль для веб-интерфейса: " PASSWORD
echo

# Генерация bcrypt-хеша пароля и удаление лишних символов
PASSWORD_HASH=$(docker run --rm ghcr.io/wg-easy/wg-easy wgpw "$PASSWORD" | grep -o '\$2[aby]\$[0-9]*\$.*' | tr -d "'")

# Запуск контейнера wg-easy с использованием сгенерированного хеша
docker run --detach \
  --name wg-easy \
  --env LANG=ua \
  --env WG_HOST=185.233.36.112 \
  --env "PASSWORD_HASH=$PASSWORD_HASH" \
  --env PORT=51831 \
  --env WG_PORT=51830 \
  --env WG_ALLOWED_IPS='10.8.0.0/24' \
  --env WG_DEFAULT_ADDRESS='10.8.0.x' \
  --volume ~/.wg-easy:/etc/wireguard \
  --publish 51830:51830/udp \
  --publish 51831:51831/tcp \
  --cap-add NET_ADMIN \
  --cap-add SYS_MODULE \
  --sysctl 'net.ipv4.conf.all.src_valid_mark=1' \
  --sysctl 'net.ipv4.ip_forward=1' \
  --restart unless-stopped \
  ghcr.io/wg-easy/wg-easy
