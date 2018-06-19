variable "do_token" {}

provider "digitalocean" {
    token = "${var.do_token}"
}

resource "digitalocean_ssh_key" "default" {
  name       = "haran@thinktank"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}

resource "digitalocean_tag" "web" {
    name = "web"
}

resource "digitalocean_droplet" "web0" {
    size = "s-1vcpu-1gb"
    image = "ubuntu-18-04-x64"
    name = "web0"
    region = "nyc1"
    monitoring = true
    ipv6 = true
    private_networking = true
    ssh_keys = ["${digitalocean_ssh_key.default.id}"]
    tags   = ["${digitalocean_tag.web.id}"]

    connection {
	type     = "ssh"
	user     = "root"
	private_key = "${file("~/.ssh/id_rsa")}"
    }

    provisioner "remote-exec" {
	inline = [
	    "apt-get update -y",
	    "apt-get upgrade -y",
	    "apt-get autoremove -y",
	    "curl -sSL https://agent.digitalocean.com/install.sh | sh",
	    "openssl dhparam -out /etc/ssl/private/dhparams.pem 2048"
	]
    }

    provisioner "local-exec" {
        command = "docker-machine create --driver generic --generic-ip-address ${digitalocean_droplet.web0.ipv4_address} --generic-ssh-key ~/.ssh/id_rsa ${digitalocean_droplet.web0.name}"
    }
}

resource "digitalocean_floating_ip" "web0" {
    droplet_id = "${digitalocean_droplet.web0.id}"
    region = "${digitalocean_droplet.web0.region}"
}

resource "digitalocean_domain" "vasyharan" {
    name = "vasyharan.com"
    ip_address = "${digitalocean_floating_ip.web0.ip_address}"
}

resource "digitalocean_record" "foobar" {
  domain = "${digitalocean_domain.vasyharan.name}"
  type   = "CNAME"
  name   = "*"
  value  = "@"
}

resource "digitalocean_firewall" "web" {
    name = "only-thinktank-docker-ssh"
    droplet_ids = ["${digitalocean_droplet.web0.id}"]
    inbound_rule = [
        {
            protocol           = "tcp"
	    port_range         = "22"
	    source_addresses   = ["76.180.3.10/32"]
	},
	{
	    protocol           = "tcp"
	    port_range         = "2376"
	    source_addresses   = ["76.180.3.10/32"]
	},
        {
	    protocol            = "tcp"
	    port_range          = "80"
	    source_addresses	= ["0.0.0.0/0", "::/0"]
	},
        {
	    protocol            = "tcp"
	    port_range          = "443"
	    source_addresses	= ["0.0.0.0/0", "::/0"]
	},
    ]

    outbound_rule = [
        {
	    protocol                = "tcp"
	    port_range              = "53"
	    destination_addresses   = ["0.0.0.0/0", "::/0"]
        },
	{
            protocol                = "udp"
            port_range              = "53"
            destination_addresses   = ["0.0.0.0/0", "::/0"]
        },
        {
	    protocol                = "tcp"
	    port_range              = "80"
	    destination_addresses   = ["0.0.0.0/0", "::/0"]
        },
        {
	    protocol                = "tcp"
	    port_range              = "443"
	    destination_addresses   = ["0.0.0.0/0", "::/0"]
        },
        {
	    protocol                = "tcp"
	    port_range              = "2376"
	    destination_addresses   = ["0.0.0.0/0", "::/0"]
        },
    ]
}