variable "do_token" {}

provider "digitalocean" {
    token = "${var.do_token}"
}

resource "digitalocean_tag" "web" {
    name = "web"
}

resource "digitalocean_droplet" "web" {
    name = "web"
    size = "512mb"
    image = "22259497"
    region = "nyc1"
    ssh_keys = ["09:01:ba:ed:b2:84:d6:41:5c:00:98:5b:d2:60:0f:e1"]
    tags = ["${digitalocean_tag.web.id}"]
    resize_disk = false
}

resource "digitalocean_floating_ip" "web" {
    droplet_id = "${digitalocean_droplet.web.id}"
    region = "${digitalocean_droplet.web.region}"
}

resource "digitalocean_domain" "vasyharan" {
    name = "vasyharan.com"
    ip_address = "${digitalocean_floating_ip.web.ip_address}"
}
