import smtplib

import paramiko
from email.MIMEText import MIMEText
from config.logger_config import setup_logger

def validate_hostname(hostname, smtp_srv=smtplib.SMTP()):
    return smtp_srv.docmd('ehlo', hostname)

def form_letter_with_utf8(text, from_addr, to_addr, subject='Test message1'):
    msg = MIMEText(text, 'plain', 'utf-8')# 'plain', 'utf-8')
    msg['From'] = from_addr
    msg['To'] = to_addr
    msg['Subject'] = subject

    return msg.get_payload(decode=True)

def login_server(username, passw, smtp_srv=smtplib.SMTP()):
    return smtp_srv.login(username, passw)


def connect_server(host, port=25):
    logger = setup_logger('ConnectionAttempt')
    try:
        logger.info("Connection attempt to host: %s" % host)
        smtp_server = smtplib.SMTP(host)
        logger.info("Connection to %s is set" % host)
        return smtp_server
    except smtplib.SMTPServerDisconnected:
        logger.warn("Cannot connect to host %s. Verify the host is available." % host)


def make_quit(smtp_svr=smtplib.SMTP()):
    return smtp_svr.quit()

def send_message_smtp(from_addr, to_addr, message, smtp_srv=smtplib.SMTP()):
    logger = setup_logger("SendSmtpMessage")
    try:
        smtp_srv.verify(to_addr)
        smtp_srv.sendmail(from_addr, to_addr, message)
        logger.info("The message is sent from %s to %s" % (from_addr, to_addr))
    except smtplib.SMTPRecipientsRefused:
        logger.warn("Recipient address is invalid: %s" % to_addr)
    finally:
        logger.info("Quit command is executing...")
        smtp_srv.quit()


def read_recent_mail(username, password, host):
    session = paramiko.SSHClient()
    session.load_system_host_keys()
    session.connect(host, 22, username, password)
    _, stdout, _ = session.exec_command(
        "recent_mail=$(ls --sort=time /home/{}/Maildir/new/ | head -n 1) && cat /home/{}/Maildir/new/$recent_mail".format(
            username, username))
    return stdout.read()
