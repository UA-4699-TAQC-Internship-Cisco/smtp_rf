import smtplib
import os
from email.MIMEText import MIMEText
from email.mime.multipart import MIMEMultipart
from dotenv import load_dotenv
import imaplib
import sys

print sys.path

load_dotenv()

# ======= send email =======

smtp_server = os.getenv("HOSTNAME")
smtp_port = int(os.getenv("SMTP_PORT"))
local_sender = os.getenv("LOCAL_SENDER")
to_addr = os.getenv("REMOTE_RECIPIENT")


def send_email(smtp_server, smtp_port, local_sender, recipient, subject, body):
    msg = MIMEMultipart()
    msg['From'] = local_sender
    msg['To'] = recipient
    msg['Subject'] = subject

    msg.attach(MIMEText(body, 'plain'))

    try:
        server = smtplib.SMTP(smtp_server, smtp_port, timeout=10)
        server.connect(smtp_server, smtp_port)
        server.ehlo()
        server.login(local_sender, os.getenv("LOCAL_SENDER"))
        server.sendmail(local_sender, to_addr, msg.as_string())

        print("Email sent successfully!")

    except smtplib.SMTPException as e:
        print("SMTP error occurred: %s" % str(e))
    except Exception as e:
        print("Error occurred: %s" % str(e))
    finally:
        try:
            server.quit()
        except:
            pass


# ======= get email =======

imap_server = os.getenv("IMAP_SERVER")
user_email = os.getenv("EMAIL_ACCOUNT")
user_password = os.getenv("EMAIL_PASSWORD")


def get_email(server, user, password):
    """
    Connect to an IMAP server and return the count of emails in the inbox.

    Args:
        server (str): IMAP server address
        user (str): Email username
        password (str): Email password

    Returns:
        int: Number of emails in inbox, or -1 if error occurred
    """
    mail = None
    try:
        mail = imaplib.IMAP4_SSL(server, 993)
        mail.login(user, password)
        mail.select("inbox")

        status, ids = mail.search(None, "ALL")
        message_ids = ids[0].split()
        email_count = len(message_ids)
        print("Letters in box:", email_count)
        return email_count

    except Exception as e:
        print("Error:", str(e))
        return -1
    finally:
        if mail is not None:
            try:
                mail.logout()
            except:
                pass


if __name__ == "__main__":
    send_email(
        smtp_server=os.getenv("HOSTNAME"),
        smtp_port=int(os.getenv("SMTP_PORT")),
        local_sender=os.getenv("LOCAL_SENDER"),
        recipient=os.getenv("REMOTE_RECIPIENT"),
        subject="Test Subject email from PyCharm",
        body="This is a test email text sent from PyCharm. 07.27"
    )

    get_email(imap_server, user_email, user_password)
