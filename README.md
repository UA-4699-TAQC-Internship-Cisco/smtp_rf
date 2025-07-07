# smtp_rf

## Install & Setup

### Clone the repository

```cmd
git clone https://github.com/UA-4699-TAQC-Internship-Cisco/smtp_rf.git
cd smtp_rf
```

### Create & Activate Virtual Environment

Create virtualenv:
```cmd
virtualenv .venv
```
Activate on Win:
```cmd
.\.venv\Scripts\activate
```
Activate on Linux/macOS:
```cmd
.venv/bin/activate
```

Install all dependencies
```cmd
pip install -r requirements.txt
```

### env

create in root file `.env`
```properties
HOSTNAME='your_server_ip'
TCP_TIMEOUT=5

SSH_PORT='your_ssh_port'
SSH_USERNAME='your_ssh_username'
SSH_PASSWORD='your_ssh_password'

DOMAIN='' # domain part in addr user@{domain}
SMTP_PORT='your_smtp_port'
EMAIL_DIR='/var/spool/mail/your_email_username'

LOCAL_SENDER='python@localhost'
REMOTE_RECIPIENT='your_email@localhost'
```

## Run test

```shell
robot --pythonpath . --outputdir results . tests
```


## CentOS setup

### Installing Postfix
Install Postfix on CentOS
```shell
sudo yum update -y
sudo yum install postfix -y
```
Run: 

```shell
sudo systemctl start postfix
```

or to autostart at system startup:
```shell
sudo systemctl enable postfix
sudo systemctl start postfix
```
Status check:
```shell
sudo systemctl status postfix
```

### Configure Postfix to receive data from outside
Open the Postfix configuration file:
```shell
sudo nano /etc/postfix/main.cf
```
add the following parameters:
```text
inet_interfaces = all
inet_protocols = ipv4
mydestination = $myhostname, localhost.$mydomain, localhost
mynetworks = 127.0.0.0/8, [IP_host]
```
restart 
```shell
sudo systemctl restart postfix
```
#### Open ports:

```shell
sudo firewall-cmd --add-port=25/tcp --permanent
sudo firewall-cmd --add-port=587/tcp --permanent
sudo firewall-cmd --add-port=465/tcp --permanent
sudo firewall-cmd --reload
```
restart 
```shell
sudo systemctl restart postfix
```

