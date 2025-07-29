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
TLS_PORT=465
IMAP_PORT=993

LOCAL_SENDER='python@localhost'
REMOTE_RECIPIENT='your_email@localhost'
```

## Run test

```shell
robot --pythonpath . --outputdir results . tests
```


## CentOS setup

### Installing Postfix and Dovecot
Install Postfix and Devcot on CentOS
```shell
sudo yum update -y
sudo yum install postfix dovecot -y
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


## Create Test User

```bash
sudo useradd testuser
sudo passwd testuser
mkdir -p /home/testuser/Maildir/{cur,new,tmp}
chown -R testuser:testuser /home/testuser/Maildir
```

### Configure Postfix to receive data from outside
Open the Postfix configuration file:
```shell
sudo nano /etc/postfix/main.cf
```
add the following parameters:
```text
inet_interfaces = all
inet_protocols = all
mydestination = $myhostname, localhost.$mydomain, localhost
mynetworks = 127.0.0.0/8, [IP_host]
smtpd_sender_restrictions = check_sender_access hash:/etc/postfix/sender_access, permit
smtpd_recipient_restrictions =
    permit_mynetworks,
    permit_sasl_authenticated,
    reject_unauth_destination
smtpd_sasl_type = dovecot
smtpd_sasl_path = private/auth
smtpd_sasl_auth_enable = yes
```
Create the sender_access file:
```text
If smtp_sender does not exist add: 
```
```shell
sudo postconf -e "smtpd_sender_restrictions = check_sender_access hash:/etc/postfix/sender_access, permit"
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

### Configure Dovecot for IMAP and POP3 access
Open the Dovecot configuration file:
```shell
sudo nano /etc/dovecot/dovecot.conf
```
Add or modify the following line to enable both IMAP and POP3 protocols:
```text
protocols = imap pop3
```
Set up Maildir as the mailbox format
```shell
sudo nano /etc/dovecot/conf.d/10-mail.conf
```


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

Add or modify the following line to set the mail location:
```text
mail_location = maildir:~/Maildir
```

Start and enable the Dovecot service
```shell
sudo systemctl enable dovecot
sudo systemctl start dovecot
```

Open IMAP and POP3 ports in the firewall
```shell
sudo firewall-cmd --add-service=imap --permanent
sudo firewall-cmd --add-service=pop3 --permanent
sudo firewall-cmd --reload
```


### Configuration for some tests
Configuration to TC0029(blocklist sender):
1. Create/edit file: sudo nano /etc/postfix/sender_access
2. Add blocklist address/addresses:  eg. spam@example.net REJECT
3. Create hash file:  sudo postmap /etc/postfix/sender_access
4.  Restart postfix: sudo systemctl restart postfix

Config for TC013:
smtputf8_autodetect_classes = all
smtputf8_enable = ${{compatibility_level} < {1} ? {no} : {yes}}





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
## TC022_tracking_rejected_email_due_to_spam_filters
## TC069_adding_an_address_to_the_blacklist

### Header_checks and body_checks in Postfix

### 1. Create header check file
```
sudo bash -c "cat > /etc/postfix/header_checks <<'EOF'
/^Subject:.*lottery/i          REJECT Spam detected: blocked subject
/^Subject:.*free money/i       REJECT Spam detected: suspicious subject
/^Subject:.*Suspicious offer/i REJECT Spam detected: test subject
/^From:.*@bad-domain.com/i     REJECT Blocked sender domain
EOF"
```
### 2. Create body check file
```
sudo bash -c "cat > /etc/postfix/body_checks <<'EOF'
/lottery/         REJECT Spam detected in body
/free money/      REJECT Spam phrase found
/test_spam_test/  REJECT Spam test phrase matched
EOF"
```
### 3. Register files in Postfix
```
sudo nano /etc/postfix/main.cf
```
and add this lines
```
header_checks = regexp:/etc/postfix/header_checks
body_checks = regexp:/etc/postfix/body_checks
```
### 4. Accept the changes
```
sudo postmap /etc/postfix/header_checks
sudo postmap /etc/postfix/body_checks
```
and restart Postfix
```
sudo systemctl restart postfix
```

### 5. Check the logs after spam letter sent
```
sudo tail -f /var/log/maillog
```



