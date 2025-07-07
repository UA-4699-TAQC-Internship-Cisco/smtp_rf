# smtp_rf
main.cf main configuration:
inet_interfaces = all
inet_protocols = all
mydestination = $myhostname, localhost.$mydomain, localhost
smtpd_sender_restrictions = check_sender_access hash:/etc/postfix/sender_access, permit

If smtp_sender does not exist add: sudo postconf -e "smtpd_sender_restrictions = check_sender_access hash:/etc/postfix/sender_access, permit"


Configuration to TC0029(blocklist sender):
1. Create/edit file: sudo nano /etc/postfix/sender_access
2. Add blocklist address/addresses:  eg. spam@example.net REJECT
3. Create hash file:  sudo postmap /etc/postfix/sender_access
4.  Restart postfix: sudo systemctl restart postfix





<!--include:./test_cases.md-->