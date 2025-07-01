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
# SHH CONNECTION

HOSTNAME='your_server_ip'
SSH_PORT='your_ssh_port'
SSH_USERNAME='your_ssh_username'
SSH_PASSWORD='your_ssh_password'
EMAIL_DIR='/var/spool/mail/your_email_username'

# CONNECTION WITH REMOTE CENTOS

LOCAL_SENDER='python@localhost'
REMOTE_RECIPIENT='your_email@localhost'
SERVER_IP=HOSTNAME
SMTP_PORT='your_smtp_port'
WRONG_PORT='your_wrong_port'
TCP_TIMEOUT=5

# EMAIL_TEXT
EMAIL_SUBJECT='Test last email'
EMAIL_BODY='Hello! Here I am'
DOMAIN='' # domain part in addr user@{domain}
NON_EXISTING_RECIPIENT='' # non existing email addr.

```

## Run test

```shell
robot --pythonpath . --outputdir results . tests
```