#!/usr/bin/env bash

get_metadata()
{
    KEY=$1
    URL="http://metadata.google.internal/computeMetadata/v1/instance/attributes/"
    curl "${URL}${KEY}" -H "Metadata-Flavor: Google" -s
}

export_to_file()
{
    KEY=$1
    VALUE=$(get_metadata ${KEY})
    echo "export ${KEY}=${VALUE}" >> /etc/profile.d/hummingbird.sh
}

setup_hummingbird_environment()
{
    export_to_file GIT_KEY
    export_to_file API_HOST_NAME
    export_to_file DIRECTOR_INGESTION_HOST
    export_to_file API_PRIVATE_KEY_PATH
    export_to_file API_PRIVATE_KEY_PASSWORD
    export_to_file API_USER_NAME
    export_to_file API_TIMEOUT
    export_to_file MACHINE_ENVIRONMENT
    export_to_file GCLOUD_UPLOAD_BUCKET_NAME
    export_to_file GCLOUD_UPLOAD_BUCKET_DIR

    echo "$(get_metadata api-key)" > $(get_metadata API_PRIVATE_KEY_PATH)
}

install_system_packages()
{
    apt-get update
    DEBIAN_FRONTEND=noninteractive apt-get -y \
     -o Dpkg::Options::="--force-confdef" \
     -o Dpkg::Options::="--force-confold" dist-upgrade

    apt-get -y install python3 python3-dev python3-pip build-essential \
     gdal-bin libgdal-dev python3-gdal \
     libexiv2-dev libboost-python-dev \
     zstd libzstd-dev

    pip3 install --upgrade pip
    pip3 install --upgrade wheel
}

mount_buckets()
{
    GCSFUSE_REPO=gcsfuse-`lsb_release -c -s`
    echo "deb http://packages.cloud.google.com/apt ${GCSFUSE_REPO} main" \
    > /etc/apt/sources.list.d/gcsfuse.list
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg \
    | apt-key add -

    GCLOUD_UPLOAD_BUCKET_NAME=$(get_metadata GCLOUD_UPLOAD_BUCKET_NAME)
    GCLOUD_UPLOAD_BUCKET_DIR=$(get_metadata GCLOUD_UPLOAD_BUCKET_DIR)
    apt-get update
    apt-get -y install gcsfuse
    mkdir ${GCLOUD_UPLOAD_BUCKET_DIR}
    echo "user_allow_other" >> /etc/fuse.conf
    gcsfuse -o allow_other --file-mode 444 ${GCLOUD_UPLOAD_BUCKET_NAME} ${GCLOUD_UPLOAD_BUCKET_DIR}
}

install_hummingbird_packages()
{
    export GIT_KEY=$(get_metadata GIT_KEY)
    PACKAGE_NAME="hummingbirdtech-field-identifier"
    PACKAGE_BRANCH="master"
    GIT_URL="git+https://${GIT_KEY}:x-oauth-basic@github.com/HummingbirdTechGroup/"
    pip3 install "${GIT_URL}${PACKAGE_NAME}.git@${PACKAGE_BRANCH}#egg=${PACKAGE_NAME}-999"  --process-dependency-links
}

main()
{
    setup_hummingbird_environment
    install_system_packages
    install_hummingbird_packages
    mount_buckets
}

main