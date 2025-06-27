import smtplib
import socket

from config.logger_config import setup_logger


def connect_to_invalid_port(host, port, timeout=5):
    logger = setup_logger(test_name="WrongPortTest")
    set_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    set_socket.settimeout(int(timeout))
    try:
        logger.info("Trying TCP connection to %s:%s with timeout %s" % (host, port, timeout))
        set_socket.connect((host, int(port)))
        set_socket.close()
        logger.info("TCP connection successful")
        return "CONNECTED"
    except Exception as e:
        logger.warn("TCP connection failed: %s" % str(e))
        return "CONNECTION_FAILED"


def send_email_headers_only(sender, recipient, subject, server_ip, server_port):
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
