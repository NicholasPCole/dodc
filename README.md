# DigitalOcean Droplet creator

A doctl-based shell script to quickly create a single DigitalOcean Droplet.

![The `dodc` main menu lists options for creating and configuring a Droplet.](screenshot.png)

## Usage

Run `./dodc.sh`, enter the Droplet name at the prompt, then select the image to build the Droplet with. From there, you can review or change any other settings before creating.

## Requirements

* [doctl](https://github.com/digitalocean/doctl)
* dialog