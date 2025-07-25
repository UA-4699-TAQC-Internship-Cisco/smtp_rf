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
# SMTP/IMAP Test Environment Setup (CentOS)

## Create Test User

```bash
sudo useradd testuser
sudo passwd testuser
mkdir -p /home/testuser/Maildir/{cur,new,tmp}
chown -R testuser:testuser /home/testuser/Maildir
```

---

## Configure Postfix

Edit `/etc/postfix/main.cf` and ensure the following lines exist:

```ini
smtpd_recipient_restrictions =
    permit_mynetworks,
    permit_sasl_authenticated,
    reject_unauth_destination

smtpd_sasl_type = dovecot
smtpd_sasl_path = private/auth
smtpd_sasl_auth_enable = yes
```

---

## Configure Dovecot

Edit `/etc/dovecot/conf.d/10-master.conf`:

```conf
service auth {
  unix_listener /var/spool/postfix/private/auth {
    mode = 0660
    user = postfix
    group = postfix
  }
}
```

Also ensure these settings are enabled in Dovecot (e.g., in `/etc/dovecot/conf.d/10-auth.conf`):

```conf
disable_plaintext_auth = no
auth_mechanisms = plain login
```

---

## Open Required Ports

```bash
sudo firewall-cmd --add-port=25/tcp --permanent
sudo firewall-cmd --add-port=465/tcp --permanent
sudo firewall-cmd --add-port=993/tcp --permanent
sudo firewall-cmd --reload
```

---

## Start and Enable Services

```bash
sudo systemctl enable postfix dovecot
sudo systemctl restart postfix dovecot
```

---

## Environment Variables / Robot Resource File

Your `.env` or Robot Framework resource file should define:

```env
HOSTNAME=your_ip
SMTP_PORT=25
TLS_PORT=465
IMAP_PORT=993

LOCAL_SENDER=testuser@example.com
REMOTE_RECIPIENT=receiver@example.com
```

---

# TC026: Accept Mail from Address on Safe List

## Preconditions

1. Install Postfix and Dovecot:
   ```bash
   sudo yum install postfix dovecot -y
   ```

2. Enable and start services:
   ```bash
   sudo systemctl enable postfix
   sudo systemctl start postfix
   sudo systemctl enable dovecot
   sudo systemctl start dovecot
   ```

3. Open necessary ports:
   ```bash
   sudo firewall-cmd --permanent --add-port=25/tcp
   sudo firewall-cmd --permanent --add-port=465/tcp
   sudo firewall-cmd --permanent --add-port=587/tcp
   sudo firewall-cmd --permanent --add-port=993/tcp
   sudo firewall-cmd --reload
   ```

4. Check firewall status:
   ```bash
   sudo firewall-cmd --list-all
   ```

---

## Postfix Configuration

1. Open the main config file:
   ```bash
   sudo nano /etc/postfix/main.cf
   ```

2. Ensure the following lines exist:
   ```ini
   myhostname = mail.example.com
   mydomain = example.com
   myorigin = $mydomain

   inet_interfaces = all
   inet_protocols = all

   mydestination = $myhostname, localhost.$mydomain, localhost, $mydomain

   mynetworks = 127.0.0.0/8, 192.168.0.0/24

   smtpd_recipient_restrictions =
       permit_mynetworks,
       permit_sasl_authenticated,
       check_sender_access hash:/etc/postfix/sender_access,
       reject_unauth_destination
   ```

3. Create sender access file:
   ```bash
   sudo nano /etc/postfix/sender_access
   ```

   Add:
   ```
   trusted@example.com    OK
   ```

4. Generate `.db` file:
   ```bash
   sudo postmap /etc/postfix/sender_access
   ```

5. Reload Postfix:
   ```bash
   sudo systemctl restart postfix
   ```
   