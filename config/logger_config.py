import logging
import os
from datetime import datetime
from logging.handlers import TimedRotatingFileHandler

from config import LOG_DIR, LOG_FILE_FORMAT, LOG_ENCODING, LOG_BACKUP_COUNT, LOG_LEVEL


def setup_logger():
    """
    Sets up a logger that writes log messages to a rotating log file.
    """
    logger = logging.getLogger(__name__)
    logger.setLevel(getattr(logging, LOG_LEVEL.upper()))

    if not os.path.exists(LOG_DIR):
        os.makedirs(LOG_DIR)
    date_str = datetime.now().strftime(LOG_FILE_FORMAT)
    log_file = os.path.join(LOG_DIR, "{}.log".format(date_str))

    class CustomTimedRotatingFileHandler(TimedRotatingFileHandler):
        def _get_rotated_filename(self, time):
            return os.path.join(self.baseFilename, "{}.log".format(time.strftime(LOG_FILE_FORMAT)))

    handler = CustomTimedRotatingFileHandler(
        filename=log_file,
        when="midnight",
        interval=1,
        backupCount=LOG_BACKUP_COUNT,
        encoding=LOG_ENCODING,
    )
    handler.suffix = LOG_FILE_FORMAT
    handler.setFormatter(logging.Formatter("%(asctime)s - %(levelname)s - %(message)s"))

    if not logger.handlers:
        logger.addHandler(handler)

    logger.propagate = False

    return logger

    logging.basicConfig(
        level=getattr(logging, LOG_LEVEL),
        format="%(asctime)s - %(levelname)s - %(message)s",
        handlers=[handler],
    )

    return logger
