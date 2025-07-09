import socket
import base64
from robot.api.deco import keyword
import ssl

sock = None

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


@keyword
def check_smtp_socket(host, port):
    s = None
    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        s.settimeout(5)
        s.connect((host, int(port)))
        banner = s.recv(1024)
        if isinstance(banner, bytes):
            banner = banner.decode('utf-8')
        print("SMTP Banner:", banner)
        return banner.startswith("220")
    except Exception as e:
        print("Socket Error:", str(e))
        return False
    finally:
        if s:
            s.close()


@keyword
def check_tls_smtp_socket(host, port):
    context = ssl.create_default_context()
    try:
        with socket.create_connection((host, int(port)), timeout=5) as sock:
            with context.wrap_socket(sock, server_hostname=host) as ssock:
                banner = ssock.recv(1024).decode('utf-8')
                print("SMTP TLS Banner:", banner)
                return banner.startswith("220")
    except Exception as e:
        print("TLS Socket Error:", str(e))
        return False


@keyword
def check_tls_smtp_socket_220(host, port):
    """Establish implicit TLS connection to SMTPS port and check 220 greeting"""
    sock = None
    try:
        context = ssl.create_default_context()
        raw_sock = socket.create_connection((host, int(port)), timeout=10)
        sock = context.wrap_socket(raw_sock, server_hostname=host)
        banner = sock.recv(1024).decode()
        print("TLS SMTP Banner:", banner)
        return banner.startswith("220")
    except Exception as e:
        print("TLS Socket Error:", str(e))
        return False
    finally:
        if sock:
            sock.close()


@keyword
def create_tls_socket(host, port):
    """Creates and returns a TLS-wrapped socket connected to the specified host and port"""
    # context = ssl.create_default_context()
    context = ssl._create_unverified_context()
    raw_sock = socket.create_connection((host, int(port)), timeout=10)
    tls_sock = context.wrap_socket(raw_sock, server_hostname=host)
    return tls_sock


@keyword
def read_tls_banner(sock):
    """Reads the initial server banner from TLS socket"""
    banner = sock.recv(1024).decode()
    return banner


@keyword
def close_smtp_connection():
    global sock
    if sock:
        sock.close()
        sock = None
