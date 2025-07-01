import logging
import smtplib

import paramiko


def validate_hostname(hostname, smtp_srv=smtplib.SMTP()):
    return smtp_srv.docmd('ehlo', hostname)


def login_server(username, passw, smtp_srv=smtplib.SMTP()):
    return smtp_srv.login(username, passw)


def connect_server(host, port=25):
    try:
        smtp_server = smtplib.SMTP(host)
        return smtp_server
    except smtplib.SMTPServerDisconnected:
        logging.exception("Cannot connect to Server, check the access to host")  ## Add config file


def make_quit(smtp_svr=smtplib.SMTP()):
    return smtp_svr.quit()


def send_message_smtp(from_addr, to_addr, message, smtp_srv=smtplib.SMTP()):
    try:
        smtp_srv.verify(to_addr)
        smtp_srv.sendmail(from_addr, to_addr, message)
    except smtplib.SMTPRecipientsRefused:
        logging.exception('Address of the destination is Not valid')
    finally:
        smtp_srv.quit()


def read_recent_mail(username, password, host):
    session = paramiko.SSHClient()
    session.load_system_host_keys()
    session.connect(host, 22, username, password)
    _, stdout, _ = session.exec_command(
        "recent_mail=$(ls --sort=time /home/{}/Maildir/new/ | head -n 1) && cat /home/{}/Maildir/new/$recent_mail".format(
            username, username))
    return stdout.read().decode()
