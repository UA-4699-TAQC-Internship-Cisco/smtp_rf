import socket
import base64
from robot.api.deco import keyword
import ssl

sock = None


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
