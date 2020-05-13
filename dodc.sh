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
      g-2vcpu-8gb "General Purpose, 25 GB SSD, \$60/mo." off \
      g-4vcpu-16gb "General Purpose, 50 GB SSD, \$120/mo." off \
      g-8vcpu-32gb "General Purpose, 100 GB SSD, \$240/mo." off \
      g-16vcpu-64gb "General Purpose, 200 GB SSD, \$480/mo." off \
      g-32vcpu-128gb "General Purpose, 400 GB SSD, \$960/mo." off \
      g-40vcpu-160gb "General Purpose, 500 GB SSD, \$1200/mo." off \
      gd-2vcpu-8gb "General Purpose 2x SSD, 50 GB SSD, \$65/mo." off \
      gd-4vcpu-16gb "General Purpose 2x SSD, 100 GB SSD, \$130/mo." off \
      gd-8vcpu-32gb "General Purpose 2x SSD, 200 GB SSD, \$260/mo." off \
      gd-16vcpu-64gb "General Purpose 2x SSD, 400 GB SSD, \$520/mo." off \
      gd-32vcpu-128gb "General Purpose 2x SSD, 800 GB SSD, \$1040/mo." off \
      gd-40vcpu-160gb "General Purpose 2x SSD, 1000 GB SSD, \$1300/mo." off \
      c-1vcpu-2gb "CPU-Optimized, 25 GB SSD, \$20/mo." off \
      c-2 "CPU-Optimized, 25 GB SSD, \$40/mo." off \
      c-4 "CPU-Optimized, 50 GB SSD, \$80/mo." off \
      c-8 "CPU-Optimized, 100 GB SSD, \$160/mo." off \
      c-16 "CPU-Optimized, 200 GB SSD, \$320/mo." off \
      c-32 "CPU-Optimized, 400 GB SSD, \$640/mo." off \
      c-48 "CPU-Optimized, 20 GB SSD, \$960/mo." off \
      m-2vcpu-16gb "Memory-Optimized, 50 GB SSD, \$90/mo." off \
      m-4vcpu-32gb "Memory-Optimized, 100 GB SSD, \$180/mo." off \
      m-8vcpu-64gb "Memory-Optimized, 200 GB SSD, \$360/mo." off \
      m-16vcpu-128gb "Memory-Optimized, 400 GB SSD, \$720/mo." off \
      m-24vcpu-192gb "Memory-Optimized, 600 GB SSD, \$1080/mo." off \
      m-32vcpu-256gb "Memory-Optimized, 800 GB SSD, \$1440/mo." off \
      m3-2vcpu-16gb "Memory-Optimized 3x SSD, 150 GB SSD, \$110/mo." off \
      m3-4vcpu-32gb "Memory-Optimized 3x SSD, 300 GB SSD, \$220/mo." off \
      m3-8vcpu-64gb "Memory-Optimized 3x SSD, 600 GB SSD, \$440/mo." off \
      m3-16vcpu-128gb "Memory-Optimized 3x SSD, 1200 GB SSD, \$880/mo." off \
      m3-24vcpu-192gb "Memory-Optimized 3x SSD, 1800 GB SSD, \$1320/mo." off \
      m3-32vcpu-256gb "Memory-Optimized 3x SSD, 2400 GB SSD, \$1760/mo." off \
      m6-2vcpu-16gb "Memory-Optimized 6x SSD, 300 GB SSD, \$140/mo." off \
      m6-4vcpu-32gb "Memory-Optimized 6x SSD, 600 GB SSD, \$280/mo." off \
      m6-8vcpu-64gb "Memory-Optimized 6x SSD, 1200 GB SSD, \$560/mo." off \
      m6-16vcpu-128gb "Memory-Optimized 6x SSD, 2400 GB SSD, \$1120/mo." off \
      m6-24vcpu-192gb "Memory-Optimized 6x SSD, 3600 GB SSD, \$1680/mo." off \
      m6-32vcpu-256gb "Memory-Optimized 6x SSD, 4800 GB SSD, \$2240/mo." off \
      512mb "(legacy) Standard, 20 GB SSD, \$5/mo." off \
      1gb "(legacy) Standard, 30 GB SSD, \$10/mo." off \
      2gb "(legacy) Standard, 40 GB SSD, \$20/mo." off \
      4gb "(legacy) Standard, 60 GB SSD, \$40/mo." off \
      8gb "(legacy) Standard, 80 GB SSD, \$80/mo." off \
      16gb "(legacy) Standard, 160 GB SSD, \$160/mo." off \
      32gb "(legacy) Standard, 320 GB SSD, \$320/mo." off \
      48gb "(legacy) Standard, 480 GB SSD, \$480/mo." off \
      64gb "(legacy) Standard, 640 GB SSD, \$640/mo." off \
      m-1vcpu-8gb "(legacy) High Memory, 40 GB SSD, \$40/mo." off \
      m-16gb "(legacy) High Memory, 60 GB SSD, \$75/mo." off \
      m-32gb "(legacy) High Memory, 90 GB SSD, \$150/mo." off \
      m-64gb "(legacy) High Memory, 200 GB SSD, \$300/mo." off \
      m-128gb "(legacy) High Memory, 340 GB SSD, \$600/mo." off \
      m-224gb "(legacy) High Memory, 500 GB SSD, \$1100/mo." off 2>${DIALOG_RESPONSE_TMP}
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
      sfo3 "San Francisco 3" off \
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
image="ubuntu-18-04-x64"
size="s-1vcpu-1gb"
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
