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
    export_to_file GCLOUD_PROJECT
    export_to_file CROP_AREA_MIN_BOOM_WIDTH
    export_to_file CROP_AREA_ALPHA
    export_to_file GDAL2TILES_PATH
    export_to_file MAP_TILER_MIN_ZOOM
    export_to_file MAP_TILER_MAX_ZOOM

    echo "$(get_metadata api-key)" > $(get_metadata API_PRIVATE_KEY_PATH)
}

install_system_packages()
{
    apt-get update
    DEBIAN_FRONTEND=noninteractive apt-get -y \
     -o Dpkg::Options::="--force-confdef" \
     -o Dpkg::Options::="--force-confold" dist-upgrade

    apt-get -y install python3 python3-dev python3-pip build-essential \
     gdal-bin libgdal-dev python3-gdal python-gdal\
     libboost-python-dev

    pip3 install --upgrade pip
    pip3 install --upgrade wheel
}

install_hummingbird_package()
{
    PACKAGE_NAME=$1
    PACKAGE_BRANCH=$2
    export GIT_KEY=$(get_metadata GIT_KEY)
    GIT_URL="git+https://${GIT_KEY}:x-oauth-basic@github.com/HummingbirdTechGroup/"
    pip3 install "${GIT_URL}${PACKAGE_NAME}.git@${PACKAGE_BRANCH}#egg=${PACKAGE_NAME}-999"
}

main()
{
    setup_hummingbird_environment
    install_system_packages
    install_hummingbird_package "hummingbirdtech-domain" "develop"
    install_hummingbird_package "hummingbirdtech-analysis-tools" "develop"
    install_hummingbird_package "hummingbirdtech-cli" "develop"
    install_hummingbird_package "hummingbirdtech-index-statistics" "develop"
    install_hummingbird_package "hummingbirdtech-crop-health" "develop"
    install_hummingbird_package "hummingbirdtech-crop-area" "develop"
    install_hummingbird_package "hummingbirdtech-terrain" "develop"
    install_hummingbird_package "hummingbirdtech-nitrogen-application" "develop"
    install_hummingbird_package "hummingbirdtech-green-area-index" "develop"
}

main