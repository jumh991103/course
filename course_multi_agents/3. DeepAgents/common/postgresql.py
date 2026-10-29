import psycopg

class Singleton(type):
	_instances = {}

	def __call__(cls, *args, **kwargs):
		if cls not in cls._instances:
			cls._instances[cls] = super(Singleton, cls)\
				.__call__(*args, **kwargs)
		return cls._instances[cls]	

class PostgreDB(metaclass=Singleton):
    def __init__(self, DB_CONFIG:dict):
        # PostgreSQL 연결 설정
        DB_URI = f"postgresql://{DB_CONFIG['user']}:{DB_CONFIG['password']}@{DB_CONFIG['host']}:{DB_CONFIG['port']}/{DB_CONFIG['database']}"

        self.conn = psycopg.connect(DB_URI, autocommit=True)

    def get_conn(self):
        return self.conn
