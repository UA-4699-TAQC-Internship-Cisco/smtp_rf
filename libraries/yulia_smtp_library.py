import smtplib
import socket

from config.logger_config import setup_logger


def connect_to_invalid_port(host, port, timeout=5):
    """ Try to connect to a TCP port that is expected to be invalid."""
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


def check_helo_response(server_ip, server_port):
    """Send HELO command and verify server responds with code 250."""
    logger = setup_logger(test_name="HeloResponseTest")
    try:
        logger.info("Connecting to %s:%s" % (server_ip, server_port))
        set_socket = socket.create_connection((server_ip, int(server_port)), timeout=5)

        response = set_socket.recv(1024).decode('utf-8')
        logger.info("Server greeting: %s" % response.strip())

        helo_command = "HELO example.com\r\n"
        logger.info("Sending: %s" % helo_command.strip())
        set_socket.sendall(helo_command.encode('utf-8'))

        helo_response = set_socket.recv(1024).decode('utf-8').strip()
        logger.info("HELO response: %s" % helo_response)

        set_socket.close()

        if helo_response.startswith("250"):
            return "HELO_OK"
        else:
            return "HELO_FAILED: %s" % helo_response

    except Exception as e:
        logger.error("Error during HELO check: %s" % str(e))
        return "ERROR: %s" % str(e)
