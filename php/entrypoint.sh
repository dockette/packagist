#!/bin/bash

USER_NAME=${USER_NAME:-www}
USER_WORKDIR=${USER_WORKDIR:-/var/www}
USER_SSH_DIR=${USER_WORKDIR}/.ssh
USER_SSH_TPL_DIR=/tpl/ssh
PACKAGIST_DIR=${PACKAGIST_DIR:-/srv}
CRON_LOG_FILE=${CRON_LOG_FILE:-/var/log/cron.log}

# Display variables
echo "[PACKAGIST] USER_NAME=${USER_NAME}"
echo "[PACKAGIST] USER_WORKDIR=${USER_WORKDIR}"
echo "[PACKAGIST] USER_SSH_DIR=${USER_SSH_DIR}"
echo "[PACKAGIST] USER_SSH_TPL_DIR=${USER_SSH_TPL_DIR}"

# Check if .ssh directory does not exit
if [ "$SSH_ENABLED" ]; then
    if [ ! -d "$USER_SSH_DIR" ]; then
        echo "[PACKAGIST] User SSH folder does not exist"
        mkdir -p ${USER_SSH_DIR}
        echo "[PACKAGIST] Creating user SSH folder: ${USER_SSH_DIR}"

        if [ -d "$USER_SSH_TPL_DIR" ]; then
            echo "[PACKAGIST] Copying SSH template (${USER_SSH_TPL_DIR} => ${USER_SSH_DIR})"
            # Move template folder to real folder
            cp "${USER_SSH_TPL_DIR}"/* "${USER_SSH_DIR}"

            # Ensure permissions
            chmod 700 "${USER_SSH_DIR}"
            [[ -f "${USER_SSH_DIR}"/id_rsa ]] && chmod 600 "${USER_SSH_DIR}"/id_rsa
            [[ -f "${USER_SSH_DIR}"/id_rsa.pub ]] && chmod 644 "${USER_SSH_DIR}"/id_rsa.pub
            [[ -f "${USER_SSH_DIR}"/known_hosts ]] && chmod 644 "${USER_SSH_DIR}"/known_hosts
            [[ -f "${USER_SSH_DIR}"/config ]] && chmod 644 "${USER_SSH_DIR}"/config

            # Ensure ownership
            chown "${USER_NAME}":"${USER_NAME}" -R "${USER_SSH_DIR}"
        else
            echo "[PACKAGIST] SSH template not found"
        fi
    else 
        echo "[PACKAGIST] User SSH folder exist"
    fi
fi

# Start cron deamon
if [ "$CRON_ENABLED" ]; then 
    echo "[PACKAGIST] Starting cron"
    touch /var/
    cron
fi

# Setup composer directory
if [ ! -d "${USER_WORKDIR}/.composer" ]; then
    echo "[PACKAGIST] Creating composer directory (${USER_WORKDIR}/.composer)"
    mkdir -p "${USER_WORKDIR}/.composer"
    chmod 0777 "${USER_WORKDIR}/.composer"
fi

# Setup app directories
if [ -d "${PACKAGIST_DIR}"]; then
    if [ -d "${PACKAGIST_DIR}/app/cache" ]; then
        echo "[PACKAGIST] Setup chmod 0777 for ${PACKAGIST_DIR}/app/cache"
        chmod 0777 "${PACKAGIST_DIR}/app/cache"
    fi 
    if [ -d "${PACKAGIST_DIR}/app/logs" ]; then
        echo "[PACKAGIST] Setup chmod 0777 for ${PACKAGIST_DIR}/app/logs"
        chmod 0777 "${PACKAGIST_DIR}/app/logs"
    fi 
else
    echo "[PACKAGIST] Skip setupping packagist APP directories" 
fi

# Start PHP deamon
echo "[PACKAGIST] Start PHP 7.0 FPM"
php-fpm7.0 -F

# Tailing cron log
if [ "$CRON_LOG_ENABLED" ]; then 
    echo "[PACKAGIST] Start tailing cron"
    tail -f /var/log/cron.log
fi
