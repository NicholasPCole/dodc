# DigitalOcean Droplet creator

A dialog-based shell script to quickly create a single DigitalOcean Droplet.

![The `dodc` main menu lists options for creating and configuring a Droplet.](screenshot.png)

## Usage

Run `./dodc.sh`, enter the Droplet name at the prompt, then select the image to build the Droplet with. From there, you can review or change any other settings before creating.

All SSH keys in an account are automatically added to each Droplet created.

## Requirements

* **[dialog](http://invisible-island.net/dialog/dialog.html)**, for prompting the user for input.
* **[doctl](https://github.com/digitalocean/doctl)**, for creating the resulting Droplet and other DigitalOcean API interactions.
* **[jq](https://stedolan.github.io/jq/)**, for parsing the list of public images.
