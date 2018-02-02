#!/bin/bash

function top_menu() {
    dialog --colors --backtitle "Droplet creator" --title "Create Droplet" --menu "Choose an option or create your Droplet:" 0 0 0 \
      name "${name}" \
      image "${image}" \
      size "${size}" \
      region "${region}" \
      options "${options_summary}" \
      f5-images "Refresh images" \
      create "Create" 2>${DIALOG_RESPONSE_TMP}
    local dialog_exit_code=$?
    local dialog_input=$(cat ${DIALOG_RESPONSE_TMP})

    case ${dialog_exit_code} in
        ${DIALOG_OK})
            case ${dialog_input} in
                name)
                    set_name;;
                image)
                    choose_image;;
                size)
                    choose_size;;
                region)
                    choose_region;;
                options)
                    choose_additional_options;;
                f5-images)
                    refresh_images;;
                create)
                    create_droplet;;
            esac;;
        ${DIALOG_CANCEL})
            exit;;
        ${DIALOG_ESC})
            exit;;
    esac
}

function set_name() {
    dialog --backtitle "Droplet creator" --title "Name" --inputbox "Choose a hostname with alphanumeric characters, dashes, and periods." 0 0 2>${DIALOG_RESPONSE_TMP}
    local dialog_exit_code=$?
    local dialog_input=$(cat ${DIALOG_RESPONSE_TMP})

    case ${dialog_exit_code} in
        ${DIALOG_OK})
            name=${dialog_input};;
    esac
}

function choose_image() {
    dialog --backtitle "Droplet creator" --title "Image" --radiolist "Choose an image:" 0 0 0 --file ${SCRIPT_DIR}/images.txt 2>${DIALOG_RESPONSE_TMP}
    local dialog_exit_code=$?
    local dialog_input=$(cat ${DIALOG_RESPONSE_TMP})

    case ${dialog_exit_code} in
        ${DIALOG_OK})
            image=${dialog_input};;
    esac
}

function choose_size() {
    dialog --backtitle "Droplet creator" --title "Size" --radiolist "Choose a size:" 0 0 0 \
      s-1vcpu-1gb "Standard Droplet, 25 GB SSD, \$5/mo." off \
      s-1vcpu-2gb "Standard Droplet, 50 GB SSD, \$10/mo." off \
      s-1vcpu-3gb "Standard Droplet, 60 GB SSD, \$15/mo." off \
      s-2vcpu-2gb "Standard Droplet, 60 GB SSD, \$15/mo." off \
      s-3vcpu-1gb "Standard Droplet, 60 GB SSD, \$15/mo." off \
      s-2vcpu-4gb "Standard Droplet, 80 GB SSD, \$20/mo." off \
      s-4vcpu-8gb "Standard Droplet, 160 GB SSD, \$40/mo." off \
      s-6vcpu-16gb "Standard Droplet, 320 GB SSD, \$80/mo." off \
      s-8vcpu-32gb "Standard Droplet, 640 GB SSD, \$160/mo." off \
      s-12vcpu-48gb "Standard Droplet, 960 GB SSD, \$240/mo." off \
      s-16vcpu-64gb "Standard Droplet, 1280 GB SSD, \$320/mo." off \
      s-20vcpu-96gb "Standard Droplet, 1920 GB SSD, \$480/mo." off \
      s-24vcpu-128gb "Standard Droplet, 2560 GB SSD, \$640/mo." off \
      s-32vcpu-192gb "Standard Droplet, 3840 GB SSD, \$960/mo." off \
      c-2 "Optimized Droplet, \$40/mo." off \
      c-4 "Optimized Droplet, \$80/mo." off \
      c-8 "Optimized Droplet, \$160/mo." off \
      c-16 "Optimized Droplet, \$320/mo." off \
      c-32 "Optimized Droplet, \$640/mo." off \
      c-48 "Optimized Droplet, \$960/mo." off \
      512mb "1st generation Droplet, \$5/mo." off \
      1gb "1st generation Droplet, \$10/mo." off \
      2gb "1st generation Droplet, \$20/mo." off \
      4gb "1st generation Droplet, \$40/mo." off \
      8gb "1st generation Droplet, \$80/mo." off \
      16gb "1st generation Droplet, \$160/mo." off \
      32gb "1st generation Droplet, \$320/mo." off \
      48gb "1st generation Droplet, \$480/mo." off \
      64gb "1st generation Droplet, \$640/mo." off \
      m-16gb "High Memory Droplet, \$120/mo." off \
      m-32gb "High Memory Droplet, \$240/mo." off \
      m-64gb "High Memory Droplet, \$480/mo." off \
      m-128gb "High Memory Droplet, \$960/mo." off \
      m-224gb "High Memory Droplet, \$1680/mo." off 2>${DIALOG_RESPONSE_TMP}
    local dialog_exit_code=$?
    local dialog_input=$(cat ${DIALOG_RESPONSE_TMP})

    case ${dialog_exit_code} in
        ${DIALOG_OK})
            size=${dialog_input};;
    esac
}

function choose_region() {
    dialog --backtitle "Droplet creator" --title "Region" --radiolist "Choose a region:" 0 0 0 \
      ams2 "Amsterdam 2" off \
      ams3 "Amsterdam 3" off \
      blr1 "Bangalore 1" off \
      fra1 "Frankfurt 1" off \
      lon1 "London 1" off \
      nyc1 "New York 1" off \
      nyc2 "New York 2" off \
      nyc3 "New York 3" off \
      sfo1 "San Francisco 1" off \
      sfo2 "San Francisco 2" off \
      sgp1 "Singapore 1" off \
      tor1 "Toronto 1" off 2>${DIALOG_RESPONSE_TMP}
    local dialog_exit_code=$?
    local dialog_input=$(cat ${DIALOG_RESPONSE_TMP})

    case ${dialog_exit_code} in
        ${DIALOG_OK})
            region=${dialog_input};;
    esac
}

function choose_additional_options() {
    dialog --backtitle "Droplet creator" --checklist "Additional options" 0 0 0 \
      p "Private networking" ${private_networking} \
      i IPv6 ${ipv6} 2>${DIALOG_RESPONSE_TMP}
    local dialog_exit_code=$?
    local dialog_input=$(cat ${DIALOG_RESPONSE_TMP})

    case ${dialog_exit_code} in
        ${DIALOG_OK})
            if [[ "${dialog_input}" =~ "p" ]]; then
                private_networking="on"
            else
                private_networking="off"
            fi

            if [[ "${dialog_input}" =~ "i" ]]; then
                ipv6="on"
            else
                ipv6="off"
            fi;;
    esac

    # Create a string summarizing selected options.
    if [[ $private_networking = "on" && $ipv6 = "on" ]]; then
        options_summary="Private networking, IPv6"
    elif [[ $private_networking = "on" && $ipv6 = "off" ]]; then
        options_summary="Private networking"
    elif [[ $private_networking = "off" && $ipv6 = "on" ]]; then
        options_summary="IPv6"
    else
        options_summary="None"
    fi
}

function refresh_images() {
    hash jq 2>/dev/null || { echo >&2 "The jq package is required but not installed. Exiting."; exit 1; }

    echo "Refreshing public images... please wait."
    doctl compute image list --public -o json | jq -c '.[] | select(has("slug")) | {"\(.slug)": "\(.distribution) \(.name)"}' | sed 's/^{"//; s/":/ /; s/}$/ off/;' | sort > ${SCRIPT_DIR}/images.txt
}

function create_droplet() {
    ssh_keys=$(doctl compute ssh-key list --format ID --no-header | paste -sd "," -)
    doctl_command="doctl compute droplet create ${name} --wait --image ${image} --region ${region} --size ${size} --ssh-keys \"${ssh_keys}\""

    if [[ ${private_networking} = "on" ]]; then
        doctl_command="${doctl_command} --enable-private-networking"
    fi

    if [[ ${ipv6} = "on" ]]; then
        doctl_command="${doctl_command} --enable-ipv6"
    fi

    echo "Creating Droplet... please --wait."
    echo "${doctl_command}"
    eval "${doctl_command}"
    exit
}

# Credit: https://stackoverflow.com/a/677212
hash dialog 2>/dev/null || { echo >&2 "The dialog package is required but not installed. Exiting."; exit 1; }
hash doctl 2>/dev/null || { echo >&2 "The doctl program is required but not installed. Exiting."; exit 1; }

SCRIPT_DIR=$(dirname $(realpath $0))

DIALOG_RESPONSE_TMP=$(mktemp /tmp/dodc.XXXXXX 2>/dev/null)
DIALOG_OK=0
DIALOG_CANCEL=1
DIALOG_ESC=255

# Initialize default Droplet settings.
name="new-droplet"
image="ubuntu-16-04-x64"
size="1gb"
region="nyc1"
private_networking="off"
ipv6="off"
options_summary="None"

set_name

if [[ ! -f ${SCRIPT_DIR}/images.txt ]]; then
    refresh_images
fi
choose_image

while true; do
    top_menu
done
