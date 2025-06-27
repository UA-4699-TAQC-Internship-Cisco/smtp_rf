# -*- coding: utf-8 -*-
import logging
import os
import smtplib
import paramiko
from base64 import b64encode
from email.MIMEText import MIMEText
from email.header import Header

from dotenv import load_dotenv

load_dotenv()

def form_letter_with_b64(subject, from_addr, to_addr):
    encoded_subj = b64encode(subject.encode('utf-8'))
    unic_subj = '=?utf-8?b?{0}?='.format(encoded_subj)
    # subj = Header(encoded_subj, 'utf-8')

    text_msg = u"Hello, this is a test brązowy message"
    msg = MIMEText(text_msg,'plain', 'utf-8') #"plain", "utf-8")
    msg["Subject"] = unic_subj
    msg["From"] = from_addr
    msg["To"] = to_addr
    return msg

def validate_hostname(hostname, smtp_srv = smtplib.SMTP()):
    return smtp_srv.docmd('ehlo', hostname)

def login_server(username, passw, smtp_srv = smtplib.SMTP()):
    return smtp_srv.login(username, passw)

def connect_server(host, port = 25):
    try:
        smtp_server = smtplib.SMTP(host)
        return smtp_server
    except smtplib.SMTPServerDisconnected:
        logging.exception("Cannot connect to Server, check the access to host")   ## Add config file

def send_message_smtp(from_addr, to_addr, message, smtp_srv = smtplib.SMTP()):
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
    _, stdout, _ = session.exec_command("recent_mail=$(ls --sort=time /home/{}/Maildir/new/ | head -n 1) && cat /home/{}/Maildir/new/$recent_mail".format(username, username))
    return stdout.read().decode()

if __name__ == "__main__":
    subj = u"Hello message"
    # encoded = b64encode(subj.encode('utf-8'))
    to_addr = os.getenv("TO_ADDR")
    from_addr = os.getenv("FROM_ADDR")
    host = os.getenv("HOST")
    password = os.getenv("password")
    usernam = os.getenv("USER")
    my_letter = form_letter_with_b64(subj, from_addr, to_addr)
    print my_letter
    # smtp_svr = smtplib.SMTP(host)
    # smtp_svr.set_debuglevel(1)
    # auth_result = login_server(usernam, password, smtp_svr)
    # # print auth_result
    #
    # send_message_smtp(from_addr, to_addr, my_letter.as_string(), smtp_svr)
    # validate_hostname("testdom", smtp_svr)
    # smtp_svr.quit()

