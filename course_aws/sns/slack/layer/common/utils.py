import os 
import boto3

from .constant import SLACK_TOKENS 

def __set_environ(p_slack_token:SLACK_TOKENS):
  ssm = boto3.client('ssm')
  parameter = ssm.get_parameter(Name=p_slack_token.value[1], WithDecryption=True)
  os.environ[p_slack_token.name] = parameter['Parameter']['Value']


def init_alarm():
  SLACK_BOT_TOKEN = os.environ.get('SLACK_BOT_TOKEN', None)
  if not SLACK_BOT_TOKEN:
    __set_environ(SLACK_TOKENS.SLACK_BOT_TOKEN)


def init_event():
  SLACK_BOT_TOKEN = os.environ.get('SLACK_BOT_TOKEN', None)
  SLACK_APP_TOKEN = os.environ.get('SLACK_APP_TOKEN', None)
  SLACK_SIGNING_SECRET = os.environ.get('SLACK_SIGNING_SECRET', None)
  if not SLACK_BOT_TOKEN or not SLACK_APP_TOKEN or not SLACK_SIGNING_SECRET:
    for token in SLACK_TOKENS.__members__:
      __set_environ(SLACK_TOKENS[token])
