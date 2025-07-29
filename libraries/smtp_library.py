import base64
import paramiko
import smtplib
import socket
from email.MIMEText import MIMEText
from robot.api.deco import keyword

from config.logger_config import setup_logger

sock = None




def send_email_headers_only(sender, recipient, subject, server_ip, server_port):
    """ Send an email with only headers (without body) to test SMTP server response."""
    logger = setup_logger(test_name="SendEmailHeadersOnlyTest")
    try:
        logger.info("Connecting to SMTP server at %s:%s", server_ip, server_port)
        server = smtplib.SMTP(server_ip, server_port)
        logger.info("Sending EHLO command")
        server.ehlo()
        server.mail(sender)
        server.rcpt(recipient)
        message = "From: %s\r\nTo: %s\r\nSubject: %s\r\n\r\n.\r\n" % (sender, recipient, subject)
        server.data(message)
        logger.info("Quitting SMTP session")
        server.quit()
        logger.info("Email sent successfully from %s to %s (headers only)", sender, recipient)
        return "EMAIL_SENT"
    except Exception as e:
        logger.error("Failed to send email: %s", str(e))
        return "SEND_FAILED: %s" % str(e)


def send_data_without_rcpt(sender, server_ip, server_port):
    """ Try to send DATA command without specifying RCPT TO.
    Expect the server to reject the request."""
    logger = setup_logger(test_name="SendDataWithoutRcptTest")
    try:
        logger.info("Connecting to SMTP server %s:%s" % (server_ip, server_port))
        server = smtplib.SMTP(server_ip, server_port)
        server.ehlo()

        logger.info("Sending MAIL FROM without RCPT TO")
        code, response = server.mail(sender)

        logger.info("Sending DATA without RCPT TO")
        code, response = server.docmd("DATA")
        if code != 354:
            logger.info("Correct behavior: Server rejected DATA. Response: %s %s" % (code, response))
            server.quit()
            return "REJECTED"
        else:
            logger.warn("Unexpected success: Server allowed DATA without RCPT TO. Response: %s %s" % (code, response))
            server.quit()
            return "UNEXPECTED_SUCCESS"

    except Exception as e:
        logger.error("General error: %s" % str(e))
        return "SEND_FAILED"


def verify_recipient_domain(host, port, sender, recipient):
    logger = setup_logger('SendDataToNonExistingRcpt')
    try:
        smtp_svr = smtplib.SMTP(host, port)
        smtp_svr.mail(sender)
        code, response = smtp_svr.rcpt(recipient)
        logger.info("Reply code rcpt TO: %d, %s" % (code, response))
        if code == 250:
            try:
                smtp_svr.data('Test msg')
            except smtplib.SMTPDataError as e:
                logger.warn("Not valid recipient: %s" % recipient)
                smtp_svr.quit()
                return e.smtp_code, e.message
        else:
            smtp_svr.quit()
            return code, response
    except smtplib.SMTPRecipientsRefused as e:
        logger.warn("An invalid address for recipient: %s" % recipient)
        return e.message
    except smtplib.SMTPConnectError as e:
        logger.warn("Connection to %s is failed. Make sure that assigned port and hostname are correct" % host)
        return e.smtp_code, e.message


def validate_hostname(hostname, smtp_srv=smtplib.SMTP()):
    return smtp_srv.docmd('ehlo', hostname)


def form_letter_with_utf8(text, from_addr, to_addr, subject='Test message1'):
    msg = MIMEText(text, 'plain', 'utf-8')
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
        reply = smtp_srv.sendmail(from_addr, to_addr, message)
        logger.info("The message is sent from %s to %s" % (from_addr, to_addr))
        return reply
    except smtplib.SMTPRecipientsRefused:
        logger.warn("Recipient address is invalid: %s" % to_addr)
    except smtplib.SMTPDataError:
        logger.warn("The email was rejected")
        return 550, "5.7.1 message content rejected"
    finally:
        logger.info("Quit command is executing...")
        smtp_srv.quit()


def read_recent_mail(username, password, host):
    session = paramiko.SSHClient()
    session.load_host_keys()
    session.connect(host, 22, username, password)
    _, stdout, _ = session.exec_command(
        "recent_mail=$(ls --sort=time /home/{}/Maildir/new/ | head -n 1) && cat /home/{}/Maildir/new/$recent_mail".format(
            username, username))
    return stdout.read()

def read_log_file(host, username, password):
    """Read postfix log file that locates in /var/log/maillog.

    To connect CentOS virtual machine: hostname, username and password are used.
    tail command is used to read log file. (You can edit an argument to -n flag, so you can obtain a different log length)
    """
    session = paramiko.SSHClient()
    session.load_system_host_keys()
    session.connect(host, 22, username, password)
    _, stdout, _ = session.exec_command(
        'echo {} | sudo -S tail -n 6 /var/log/maillog'.format(password)
    )
    return stdout.read()


def read_and_check_log_for_auth(host, username, password):
    log = read_log_file(host, username, password)
    if "sasl_method=" not in log:
        raise AssertionError("AUTH log not found in maillog:\n" + log)

@keyword
def open_smtp_connection(host, port):
    global sock
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.settimeout(5)
    sock.connect((host, int(port)))


@keyword
def read_smtp_banner(expected_code):
    global sock
    if not sock:
        raise AssertionError("SMTP socket is not open.")
    data = ''
    while True:
        chunk = sock.recv(1024)
        if not chunk:
            break
        data += chunk.decode('utf-8') if isinstance(chunk, bytes) else chunk
        if str(expected_code) in data:
            break
    return data.strip()


@keyword
def send_smtp_command(command):
    global sock
    if not sock:
        raise AssertionError("SMTP socket is not open.")
    sock.sendall((command + '\r\n').encode())


@keyword
def encode_string_to_base64(string_value):
    if not isinstance(string_value, bytes):
        string_value = string_value.encode('utf-8')
    encoded = base64.b64encode(string_value)
    if isinstance(encoded, bytes):
        encoded = encoded.decode('utf-8')
    return encoded


@keyword
def close_smtp_connection():
    global sock
    if sock:
        sock.close()
        sock = None

def add_address_to_safe(host, port, user, password, address):
    """Append an address or range of addresses to /etc/postfix/sender_access as safe list.

    To execute this method successful, a specified user is required to have sudo privileges;
    Make sure the bash script has an executable permission"""
    session = paramiko.SSHClient()
    session.load_system_host_keys()
    session.connect(host, port, user, password)
    append_address = "echo {} | sudo -S /home/{}/accept_address.sh {}".format(password, user, address)
    session.exec_command(append_address)

def remove_address_from_safe(host, port, username, password, to_remove_address):
    """Remove an email address or range of addresses from /etc/postfix/sender_access

    To execute this method successful, a specified user is required to have sudo privileges;
    Make sure the bash script has an executable permission"""
    client = paramiko.SSHClient()
    client.load_system_host_keys()
    client.connect(host, port, username, password)
    remove_address = "echo {} | sudo -S /home/{}/remove_address.sh {}".format(password, username, to_remove_address)
    client.exec_command(remove_address)

def update_filter_and_reload_smtp(host, port, user, password):
    """Confirms changes in /etc/postfix/sender_access and reload service.

    To execute this method successful, a specified user is required to have sudo privileges.
    Add user to sudo (run as root)#: usermod -a -G wheel {user}"""
    client = paramiko.SSHClient()
    client.load_system_host_keys()
    client.connect(host, port, user, password)
    update_file_refresh_smtp = "echo {} | sudo -S /home/{}/update_list_and_reload.sh".format(password, user)
    _, stdout, _ = client.exec_command(update_file_refresh_smtp)
    return stdout.read()

def form_simple_letter(text, from_addr, to_addr, subject = "Test message1"):
    """Create an email with simple template that includes basic headers:
     Form (sender), To (recipient) and subject of email"""
    mail = MIMEText(text, "plain", "ascii")
    mail["From"] = from_addr
    mail["To"] = ",".join(to_addr)
    mail["Subject"] = subject
    return mail.as_string()

def connect_and_login(host, port, username, password, use_tls=True):
    try:
        if use_tls:
            server = smtplib.SMTP(host, port)
            server.ehlo()
            server.starttls()
            server.ehlo()
        else:
            server = smtplib.SMTP_SSL(host, port)

        server.login(username, password)
        server.quit()
        return "Login successful"
    except smtplib.SMTPAuthenticationError as e:
        raise Exception("Authentication failed: {e}")
    except Exception as e:
        raise Exception("Connection/Login failed: {e}")
