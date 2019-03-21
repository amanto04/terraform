# Create a new instance of the latest Ubuntu 14.04 on an
# t2.micro node with an AWS Tag naming it "HelloWorld"
provider "aws" {
  region = "us-east-2"
  profile = "personal"
}

resource "aws_security_group" "allow_tls" {
   name = "allow_tls"
   description = " allow tls traffic"

   ingress {
     from_port = 443
     to_port = 443
     protocol = "tcp"
     cidr_blocks = [
        "0.0.0.0/0"
     ]
   }
   tags = {
     Name = "allow_tls"
   }
}

resource "aws_security_group" "allow_ssh" {
   name = "allow_ssh"
   description = " allow ssh traffic"

   ingress {
     from_port = 22
     to_port = 22
     protocol = "tcp"
     cidr_blocks = [
        "0.0.0.0/0"
     ]
   }
   tags = {
     Name = "allow_ssh"
   }
}

resource "aws_key_pair" "keypair" {
   key_name = "keypair"
   #public_key = "${file("webserver.pub")}"
   public_key = "${file(var.webserver_ssh_key_public)}"
}

resource "aws_instance" "web" {
  ami           = "ami-0d6684ba3de2bc693"
  instance_type = "t2.micro"
  tags = {
    Name = "webserver"
  }
  key_name = "${aws_key_pair.keypair.id}"
  security_groups = [
  "allow_ssh",
  "allow_tls"
  ]

}

resource "null_resource" "provisioner" {
  triggers {
    public_ip = "${aws_instance.web.public_ip}"
  }

  provisioner "remote-exec" {
  inline = [
      "ls"
    ]
  connection {
    host        = "${aws_instance.web.public_ip}"
    type        = "ssh"
    user        = "ubuntu"
    private_key = "${file(var.webserver_ssh_key_private)}"
   }
  }

  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u  ubuntu --private-key ${var.webserver_ssh_key_private} -i '${aws_instance.web.public_ip},' ./ansible/provision.yml"
  }
}
