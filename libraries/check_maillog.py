import paramiko
import os

from dotenv import load_dotenv


def read_log_file(host, username, password):
    session = paramiko.SSHClient()
    session.load_system_host_keys()
    session.connect(host, 22, username, password)
    _, stdout, _ = session.exec_command(
        'echo {} | sudo -S tail -n 6 /var/log/maillog'.format(password)
    )
    return stdout.read()

if __name__ == '__main__':
    load_dotenv()
    user = os.getenv('SSH_USERNAME')
    passw = os.getenv('SSH_PASSWORD')
    host = os.getenv('HOSTNAME')
    output = read_log_file(host, user, passw)

    print host, output

