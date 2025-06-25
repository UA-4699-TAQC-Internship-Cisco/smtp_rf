from dotenv import load_dotenv
import os
from robot.api.deco import keyword

@keyword
def load_envs():
    load_dotenv()
    os.environ['HOSTNAME'] = os.getenv('HOSTNAME')
    os.environ['SMTP_PORT'] = os.getenv('SMTP_PORT')
    os.environ['SSH_USERNAME'] = os.getenv('SSH_USERNAME')
    os.environ['PASSWORD'] = os.getenv('PASSWORD')
    return True