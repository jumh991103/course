from langgraph.checkpoint.sqlite import SqliteSaver

from .connection import get_db_connection

def get_checkpointer():
    return SqliteSaver(get_db_connection())

