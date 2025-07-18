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
=============================================================
# SMTP/IMAP Test Environment Setup (CentOS)
=============================================================
Create test user

useradd testuser
passwd testuser
mkdir -p /home/testuser/Maildir/{cur,new,tmp}
chown -R testuser:testuser /home/testuser/Maildir
=============================================================
Configure Postfix

Edit /etc/postfix/main.cf and ensure the following lines exist:

smtpd_recipient_restrictions =
    permit_mynetworks,
    permit_sasl_authenticated,
    reject_unauth_destination

smtpd_sasl_type = dovecot
smtpd_sasl_path = private/auth
smtpd_sasl_auth_enable = yes
=============================================================
Configure Dovecot

Edit /etc/dovecot/conf.d/10-master.conf:

service auth {
  unix_listener /var/spool/postfix/private/auth {
    mode = 0660
    user = postfix
    group = postfix
  }
}
Also ensure these settings are enabled in Dovecot:

disable_plaintext_auth = no
auth_mechanisms = plain login
===============================================================
Open Required Ports

firewall-cmd --add-port=25/tcp --permanent
firewall-cmd --add-port=465/tcp --permanent
firewall-cmd --add-port=993/tcp --permanent
firewall-cmd --reload
===============================================================
Start and Enable Services

systemctl enable postfix dovecot
systemctl restart postfix dovecot
===============================================================
Environment Variables / Robot Resource File
Your .env file or Robot Framework resource file should define:

HOSTNAME= your ip
SMTP_PORT=25
TLS_PORT=465
IMAP_PORT=993

LOCAL_SENDER=testuser@example.com
REMOTE_RECIPIENT=receiver@example.com
===============================================================