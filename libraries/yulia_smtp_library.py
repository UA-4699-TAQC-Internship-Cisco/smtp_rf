import os
import socket

import dotenv

from config.logger_config import setup_logger

dotenv.load_dotenv()
logger = setup_logger()


def connect_to_invalid_port(host, port, timeout=5):
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

