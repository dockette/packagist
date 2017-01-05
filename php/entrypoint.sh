#!/bin/bash

USER_NAME=${USER_NAME:-www-data}
USER_WORKDIR=${USER_WORKDIR:-/var/www}
USER_SSH_DIR=${USER_WORKDIR}/.ssh
USER_SSH_TPL_DIR=/tpl/ssh
PACKAGIST_DIR=${PACKAGIST_DIR:-/srv}
CRON_LOG_FILE=${CRON_LOG_FILE:-/var/log/cron.log}

# Display variables

echo "[PACKAGIST] SSH_ENABLED=${SSH_ENABLED}"
echo "[PACKAGIST] USER_NAME=${USER_NAME}"
echo "[PACKAGIST] USER_NAME=${USER_NAME}"
echo "[PACKAGIST] USER_WORKDIR=${USER_WORKDIR}"
echo "[PACKAGIST] USER_SSH_DIR=${USER_SSH_DIR}"
echo "[PACKAGIST] USER_SSH_TPL_DIR=${USER_SSH_TPL_DIR}"
echo "[PACKAGIST] PACKAGIST_DIR=${PACKAGIST_DIR}"
echo "[PACKAGIST] CRON_ENABLED=${CRON_ENABLED}"
echo "[PACKAGIST] CRON_STDOUT=${CRON_STDOUT}"
echo "[PACKAGIST] CRON_LOG_FILE=${CRON_LOG_FILE}"

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
            [[ -f "${USER_SSH_DIR}"/id_rsa ]] && chmod 600 "${USER_SSH_DIR}"/id_rsa
            [[ -f "${USER_SSH_DIR}"/id_rsa.pub ]] && chmod 644 "${USER_SSH_DIR}"/id_rsa.pub
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
    fi
fi

# Start cron deamon
if [ "$CRON_ENABLED" ]; then 
    echo "[PACKAGIST] Starting cron"
    cron

    if [ "$CRON_STDOUT" ]; then
        # Forward cron to STDOUT
        echo "[PACKAGIST] Remove cron file (${CRON_LOG_FILE})"
        rm "${CRON_LOG_FILE}"
        echo "[PACKAGIST] Forward ${CRON_LOG_FILE} to STDOUT (/dev/stdout)"
        ln -sf /dev/stdout "${CRON_LOG_FILE}"
    else
        echo "[PACKAGIST] Touching cron log file (${CRON_LOG_FILE})"
        touch "${CRON_LOG_FILE}"
    fi

    echo "[PACKAGIST] Ensure properly ownership of (${CRON_LOG_FILE})"
    chown "${USER_NAME}":"${USER_NAME}" "${CRON_LOG_FILE}"
fi

# Setup composer directory
if [ ! -d "${USER_WORKDIR}/.composer" ]; then
    echo "[PACKAGIST] Creating composer directory (${USER_WORKDIR}/.composer)"
    mkdir -p "${USER_WORKDIR}/.composer"
    chmod 0777 "${USER_WORKDIR}/.composer"
fi

# Setup app directories
if [ -d "${PACKAGIST_DIR}" ]; then
    if [ -d "${PACKAGIST_DIR}/app/cache" ]; then
        echo "[PACKAGIST] Setup chmod 0777 for ${PACKAGIST_DIR}/app/cache"
        chmod 0777 "${PACKAGIST_DIR}/app/cache"
    fi 
    if [ -d "${PACKAGIST_DIR}/app/logs" ]; then
        echo "[PACKAGIST] Setup chmod 0777 for ${PACKAGIST_DIR}/app/logs"
        chmod 0777 "${PACKAGIST_DIR}/app/logs"
    fi 
else
    echo "[PACKAGIST] Skip setup of packagist APP directories" 
fi

# Start PHP 7.0.x with FPM
echo "[PACKAGIST] Start PHP 7.0.x FPM (nodeamonize)"
php-fpm7.0 -F
