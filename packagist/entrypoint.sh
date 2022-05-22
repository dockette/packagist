#!/bin/bash

PACKAGIS_ROOT_DIR=/srv
PACKAGIS_APP_DIR=${PACKAGIS_ROOT_DIR}
PACKAGIS_COFING_DIR=${PACKAGIS_APP_DIR}/config
PACKAGIST_CONFIG_PARAMETERS=${PACKAGIS_COFING_DIR}/parameters.yml
PACKAGIST_ENV_PARAMETERS=${PACKAGIS_ROOT_DIR}/.env.local
PACKAGIST_CONFIG_PARAMETERS_TPL=${PACKAGIS_COFING_DIR}/parameters.yml.dist

USER_NAME=${USER_NAME:-www-data}
USER_WORKDIR=${USER_WORKDIR:-/var/www}
USER_SSH_DIR=${USER_WORKDIR}/.ssh
USER_SSH_TPL_DIR=/tpl/ssh

CRON_LOG_FILE=${CRON_LOG_FILE:-/var/log/cron.log}

echo "[PACKAGIST] SSH_ENABLED=${SSH_ENABLED}"
echo "[PACKAGIST] USER_NAME=${USER_NAME}"
echo "[PACKAGIST] USER_WORKDIR=${USER_WORKDIR}"
echo "[PACKAGIST] USER_SSH_DIR=${USER_SSH_DIR}"
echo "[PACKAGIST] USER_SSH_TPL_DIR=${USER_SSH_TPL_DIR}"
echo "[PACKAGIST] PACKAGIS_ROOT_DIR=${PACKAGIS_ROOT_DIR}"
echo "[PACKAGIST] PACKAGIS_APP_DIR=${PACKAGIS_APP_DIR}"
echo "[PACKAGIST] PACKAGIS_COFING_DIR=${PACKAGIS_COFING_DIR}"
echo "[PACKAGIST] PACKAGIST_CONFIG_PARAMETERS=${PACKAGIST_CONFIG_PARAMETERS}"
echo "[PACKAGIST] CRON_ENABLED=${CRON_ENABLED}"
echo "[PACKAGIST] CRON_LOG_FILE=${CRON_LOG_FILE}"

# ==========================================================
# ==========================================================
# ==========================================================

APP_SCHEME=${APP_SCHEME:=https}

PACKAGIST_DATABASE_HOST=${PACKAGIST_DATABASE_HOST:=mysql}
PACKAGIST_DATABASE_NAME=${PACKAGIST_DATABASE_NAME:=packagist}
PACKAGIST_DATABASE_USER=${PACKAGIST_DATABASE_USER:=packagist}
PACKAGIST_DATABASE_PASSWORD=${PACKAGIST_DATABASE_PASSWORD:=packagist}
DATABASE_URL=${DATABASE_URL:=mysqli://${PACKAGIST_DATABASE_USER}:${PACKAGIST_DATABASE_PASSWORD}@${PACKAGIST_DATABASE_HOST}:${PACKAGIST_DATABASE_PORT:=3306}/${PACKAGIST_DATABASE_NAME}?serverVersion=10.2.12}

# PACKAGIST_REDIS_DNS=${PACKAGIST_REDIS_HOST:=redis://redis/2}
# PACKAGIST_REDIS_CACHE_DNS=${PACKAGIST_REDIS_CACHE_DNS:=redis://redis/1}
# PACKAGIST_REDIS_DNS_TEST=${PACKAGIST_REDIS_DNS_TEST:=redis://redis/14}
# PACKAGIST_REDIS_DNS_SESSION=${PACKAGIST_REDIS_DNS_SESSION:=redis://redis/2}

REDIS_URL=${REDIS_URL:=redis://redis}
REDIS_CACHE_URL=${REDIS_CACHE_URL:=${REDIS_URL}}

SOLR_HOST=${SOLR_HOST:=solr}
SOLR_PORT=${SOLR_PORT:=8983}
SOLR_CORE=${SOLR_CORE:=packagist}

PACKAGIST_SECRET=${PACKAGIST_SECRET:=EAKQr17ZAGMd6kVSC49KHintVvCZAFCIjGhms3v6G4EflNoY4E}
PACKAGIST_REMEMBER_ME_SECRET=${PACKAGIST_REMEMBER_ME_SECRET:=C4OGyv6kdNoD5syhF2MRK7uAGD0JY806ciwTh0X96cMaTQr270}

# ==========================================================
# ==========================================================
# ==========================================================

# Copy & replace packagist parameters
# echo "[Packagist] Copying parameters.yml.dist to parameters.yml"
# cp ${PACKAGIST_CONFIG_PARAMETERS_TPL} ${PACKAGIST_CONFIG_PARAMETERS}

echo "[Packagist] Configure .env.local"

sed -i -- "s#APP_HOSTNAME=packagist.local#APP_HOSTNAME=${APP_HOSTNAME}#g" ${PACKAGIST_ENV_PARAMETERS}
sed -i -- "s#APP_SCHEME=https#APP_SCHEME=${APP_SCHEME}#g" ${PACKAGIST_ENV_PARAMETERS}
#sed -i -- "s#ALGOLIA_PROTOCOL=https:#ALGOLIA_PROTOCOL=${ALGOLIA_PROTOCOL}#g" ${PACKAGIST_ENV_PARAMETERS}
# sed -i -- "s#ALGOLIA_HOST=#ALGOLIA_HOST=${ALGOLIA_HOST}#g" ${PACKAGIST_ENV_PARAMETERS}
sed -i -- "s#APP_MAILER_FROM_EMAIL=#APP_MAILER_FROM_EMAIL=${APP_MAILER_SENDER}#g" ${PACKAGIST_ENV_PARAMETERS}
sed -i -- "s#MAILER_SENDER=your-email@example.org#MAILER_SENDER=${APP_MAILER_SENDER}#g" ${PACKAGIST_ENV_PARAMETERS}
sed -i -- "s#MAILER_DSN=null://null#MAILER_DSN=${APP_MAILER_DSN}#g" ${PACKAGIST_ENV_PARAMETERS}

sed -i -- "s#DATABASE_URL="mysqli://packagist:packagist@mysql:3306/packagist?serverVersion=10.2.12"#DATABASE_URL=${DATABASE_URL}#g" ${PACKAGIST_ENV_PARAMETERS}

sed -i -- "s#SOLR_HOST=solr#SOLR_HOST=${SOLR_HOST}#g" ${PACKAGIST_ENV_PARAMETERS}
sed -i -- "s#SOLR_PORT=8983#SOLR_PORT=${SOLR_PORT}#g" ${PACKAGIST_ENV_PARAMETERS}
sed -i -- "s#SOLR_CORE=solr#SOLR_CORE=${SOLR_CORE}#g" ${PACKAGIST_ENV_PARAMETERS}

# redis
sed -i -- "s#REDIS_URL=redis://redis#REDIS_URL=${REDIS_URL}#g" ${PACKAGIST_ENV_PARAMETERS}
sed -i -- "s#REDIS_CACHE_URL=\${REDIS_URL}#REDIS_CACHE_URL=${REDIS_CACHE_URL}#g" ${PACKAGIST_ENV_PARAMETERS}



# sed -i -- "s#PACKAGIST_DATABASE_USER=# ${PACKAGIST_DATABASE_USER}#g" ${PACKAGIST_ENV_PARAMETERS}
# sed -i -- "s#PACKAGIST_DATABASE_PASSWORD=# ${PACKAGIST_DATABASE_PASSWORD}#g" ${PACKAGIST_ENV_PARAMETERS}

# sed -i -- "s/database_host: localhost/database_host: ${PACKAGIST_DATABASE_HOST}/g" ${PACKAGIST_CONFIG_PARAMETERS}
# sed -i -- "s/database_user: root/database_user: ${PACKAGIST_DATABASE_USER}/g" ${PACKAGIST_CONFIG_PARAMETERS}
# sed -i -- "s/database_password:/database_password: ${PACKAGIST_DATABASE_PASSWORD}/g" ${PACKAGIST_CONFIG_PARAMETERS}

# sed -i -- "s#redis_dsn: redis://localhost/1#redis_dsn: ${PACKAGIST_REDIS_DNS}#g" ${PACKAGIST_CONFIG_PARAMETERS}
# sed -i -- "s#redis_dsn_test: redis://127.0.0.1/14#redis_dsn_test: ${PACKAGIST_REDIS_DNS_TEST}#g" ${PACKAGIST_CONFIG_PARAMETERS}
# sed -i -- "s#redis_session_dsn: redis://localhost/2#redis_session_dsn: ${PACKAGIST_REDIS_DNS_SESSION}#g" ${PACKAGIST_CONFIG_PARAMETERS}

# sed -i -- "s#solr_host: 127.0.0.1#solr_host: ${PACKAGIST_SOLR_HOST}#g" ${PACKAGIST_CONFIG_PARAMETERS}
# sed -i -- "s#solr_core: collection1#solr_core: ${PACKAGIST_SOLR_CORE}#g" ${PACKAGIST_CONFIG_PARAMETERS}

# sed -i -- "s#secret: CHANGE_ME_IN_PROD#secret: ${PACKAGIST_SECRET}#g" ${PACKAGIST_CONFIG_PARAMETERS}
# sed -i -- "s#remember_me.secret: CHANGE_ME_IN_PROD#remember_me.secret: ${PACKAGIST_REMEMBER_ME_SECRET}#g" ${PACKAGIST_CONFIG_PARAMETERS}

# ==========================================================
# ==========================================================
# ==========================================================

# Check if .ssh directory does not exit
if [ "$SSH_ENABLED" ]; then
    if [ ! -d "$USER_SSH_DIR" ]; then
        echo "[PACKAGIST] User SSH folder does not exist (${USER_SSH_DIR})"
        mkdir -p ${USER_SSH_DIR}
        echo "[PACKAGIST] Creating user SSH folder (${USER_SSH_DIR})"

        if [ -d "$USER_SSH_TPL_DIR" ]; then
            echo "[PACKAGIST] Copying SSH template (${USER_SSH_TPL_DIR} => ${USER_SSH_DIR})"
            # Move template folder to real folder
            cp "${USER_SSH_TPL_DIR}"/* "${USER_SSH_DIR}"

            # Ensure permissions
            chmod 700 "${USER_SSH_DIR}"
            chown -R "${USER_NAME}":"${USER_NAME}" "${USER_SSH_DIR}"
            [[ -f "${USER_SSH_DIR}"/id_ed25519 ]] && chmod 600 "${USER_SSH_DIR}"/id_ed25519
            [[ -f "${USER_SSH_DIR}"/id_ed25519.pub ]] && chmod 644 "${USER_SSH_DIR}"/id_ed25519.pub
            [[ -f "${USER_SSH_DIR}"/known_hosts ]] && chmod 644 "${USER_SSH_DIR}"/known_hosts
            [[ -f "${USER_SSH_DIR}"/config ]] && chmod 644 "${USER_SSH_DIR}"/config

            # Ensure ownership
            echo "[PACKAGIST] Ensure properly ownership of (${USER_SSH_DIR})"
            chown "${USER_NAME}":"${USER_NAME}" -R "${USER_SSH_DIR}"
        else
            echo "[PACKAGIST] SSH template not found (${USER_SSH_TPL_DIR})"
        fi
    else
        echo "[PACKAGIST] Taking user SSH folder (${USER_SSH_DIR})"
         # Ensure permissions
        chmod 700 "${USER_SSH_DIR}"
        chown -R "${USER_NAME}":"${USER_NAME}" "${USER_SSH_DIR}"
        [[ -f "${USER_SSH_DIR}"/id_ed25519 ]] && chmod 600 "${USER_SSH_DIR}"/id_ed25519
        [[ -f "${USER_SSH_DIR}"/id_ed25519.pub ]] && chmod 644 "${USER_SSH_DIR}"/id_ed25519.pub
        [[ -f "${USER_SSH_DIR}"/known_hosts ]] && chmod 644 "${USER_SSH_DIR}"/known_hosts
        [[ -f "${USER_SSH_DIR}"/config ]] && chmod 644 "${USER_SSH_DIR}"/config
            # Ensure ownership
        echo "[PACKAGIST] Ensure properly ownership of (${USER_SSH_DIR})"
        chown "${USER_NAME}":"${USER_NAME}" -R "${USER_SSH_DIR}"
    fi
fi

eval $(ssh-agent) && \
    echo "    IdentityFile ${USER_SSH_DIR}/id_ed25519" >> /etc/ssh/ssh_config && \
    echo "    UserKnownHostsFile ${USER_SSH_DIR}/known_hosts" >> /etc/ssh/ssh_config

# ==========================================================
# ==========================================================
# ==========================================================

# Setup cron
echo "[PACKAGIST] Touching cron log file (${CRON_LOG_FILE})"
touch "${CRON_LOG_FILE}"

echo "[PACKAGIST] Ensure properly ownership and mode (0775) of (${CRON_LOG_FILE})"
chown "${USER_NAME}":"${USER_NAME}" "${CRON_LOG_FILE}"
chmod 0775 "${CRON_LOG_FILE}"

# Setup composer directory
if [ ! -d "${USER_WORKDIR}/.composer" ]; then
    echo "[PACKAGIST] Creating composer directory (${USER_WORKDIR}/.composer)"
    mkdir -p "${USER_WORKDIR}/.composer"
    chmod 0777 "${USER_WORKDIR}/.composer"
fi

# Setup app directories
if [ -d "${PACKAGIS_ROOT_DIR}" ]; then
    mkdir -p "${PACKAGIS_ROOT_DIR}/var/cache"
    echo "[PACKAGIST] Setup chmod 0777 for ${PACKAGIS_ROOT_DIR}/var/cache"
    chmod 0777 -R "${PACKAGIS_ROOT_DIR}/var/cache"

    mkdir -p "${PACKAGIS_ROOT_DIR}/var/log"
    echo "[PACKAGIST] Setup chmod 0777 for ${PACKAGIS_ROOT_DIR}/var/log"
    chmod 0777 -R "${PACKAGIS_ROOT_DIR}/var/log"

    mkdir -p "${PACKAGIS_ROOT_DIR}/web"
    echo "[PACKAGIST] Setup owerneship for ${PACKAGIS_ROOT_DIR}/web"
    chown -R ${USER_NAME}:${USER_NAME} "${PACKAGIS_ROOT_DIR}/web"
else
    echo "[PACKAGIST] Skip setup of packagist APP directories"
fi

# ==========================================================
# ==========================================================
# ==========================================================

# Setup bootstrap
echo "[PACKAGIST] Composer post-install"
composer run post-install-cmd

# Setup assets
echo "[PACKAGIST] Setup assets"
bin/console assets:install web


# Setup assets
# echo "[PACKAGIST] Build Front App"
# npm install
# npm run-script build

# Setup owerneship
echo "[PACKAGIST] Changing ownership of cache folders"
chown -R ${USER_NAME}:${USER_NAME} ${PACKAGIS_ROOT_DIR}/var/cache
echo "[PACKAGIST] Changing ownership of logs folders"
chown -R ${USER_NAME}:${USER_NAME} ${PACKAGIS_ROOT_DIR}/var/logs

# Setup cache
echo "[PACKAGIST] Warmup cache"
su www-data -s /bin/sh -c "bin/console cache:warmup --env=prod"
# su www-data -s /bin/sh -c "bin/console cache:warmup --env=dev"

# Start supervisor
echo "[PACKAGIST] Start supervisor (php-fpm, nginx, cron)"
supervisord --nodaemon --configuration /etc/supervisord.conf
#php-fpm
#php-fpm8.0
