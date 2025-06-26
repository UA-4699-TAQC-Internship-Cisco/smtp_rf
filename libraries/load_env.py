from dotenv import load_dotenv
import os
from robot.api.deco import keyword

@keyword
def load_envs(env_file="../.env"):
    load_dotenv(dotenv_path=env_file)