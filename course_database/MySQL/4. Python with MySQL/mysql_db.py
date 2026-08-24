import pymysql


# Singleton은 MySQLDB 객체가 여러 번 만들어져도 실제 인스턴스는 하나만 쓰도록 합니다.
# 수업에서는 "DB 연결을 매번 새로 만들지 않고 재사용한다"는 목적으로 이해하면 됩니다.
class Singleton(type):
    _instances = {}

    def __call__(cls, *args, **kwargs):
        # 처음 호출할 때만 객체를 만들고, 이후에는 저장된 객체를 그대로 반환합니다.
        if cls not in cls._instances:
            cls._instances[cls] = super(Singleton, cls).__call__(*args, **kwargs)
        return cls._instances[cls]


class MySQLDB(metaclass=Singleton):
    def __init__(self, db_config: dict):
        # db_config에는 host, port, database, user, password 값이 들어와야 합니다.
        # DictCursor를 사용하면 조회 결과를 튜플이 아니라 딕셔너리 형태로 받을 수 있습니다.
        self.conn = pymysql.connect(
            host=db_config["host"],
            port=int(db_config["port"]),
            database=db_config["database"],
            user=db_config["user"],
            password=db_config["password"],
            charset="utf8mb4",
            cursorclass=pymysql.cursors.DictCursor,
        )

    def get_conn(self):
        # 다른 코드에서 같은 MySQL 연결 객체를 사용할 수 있도록 반환합니다.
        return self.conn
