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

smtp_server = os.getenv("SMTP_SERVER")
smtp_port = int(os.getenv("SMTP_PORT"))
from_addr = os.getenv("FROM_ADDR")
to_addr = os.getenv("TO_ADDR")


def send_email(smtp_server, smtp_port, from_addr, to_addr, subject, body):
    msg = MIMEMultipart()
    msg['From'] = from_addr
    msg['To'] = to_addr
    msg['Subject'] = subject

    msg.attach(MIMEText(body, 'plain'))

    try:
        server = smtplib.SMTP(smtp_server, smtp_port, timeout=10)
        server.ehlo()
        server.login(from_addr, os.getenv("EMAIL_PASSWORD"))
        server.sendmail(from_addr, to_addr, msg.as_string())

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


if __name__ == "__main__":
    send_email(
        smtp_server=os.getenv("SMTP_SERVER"),
        smtp_port=int(os.getenv("SMTP_PORT")),
        from_addr=os.getenv("FROM_ADDR"),
        to_addr=os.getenv("TO_ADDR"),
        subject="Test Subject email from PyCharm",
        body="This is a test email text sent from PyCharm. 07.27"
    )


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
    get_email(imap_server, user_email, user_password)
