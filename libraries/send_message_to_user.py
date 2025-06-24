import smtplib
import os
#import paramiko
from dotenv import load_dotenv

load_dotenv()


def send_mail(host, port, from_addr, to_addrs, body, subject=None):
    """
    :param host:
    :param port:
    :param from_addr:
    :param to_addrs:
    :param body:
    :param subject:
    :return:
    """

    lines = [
        "From: {}".format(from_addr),
        "To: {}".format(', '.join(to_addrs)),
        "Subject: {}".format(subject),
        "",
        body
    ]

    msg = "\r\n".join(lines)

    server = smtplib.SMTP(host, int(port))
    server.set_debuglevel(1)
    result = server.sendmail(from_addr, to_addrs, msg)
    server.quit()
    return result
