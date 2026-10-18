import sqlite3

# 싱글톤 패턴으로 SQLite 연결 관리
_sqlite_connection = None

def get_db_connection():
    """SQLite 연결을 싱글톤으로 관리하는 함수"""
    global _sqlite_connection
    
    # 기존 연결이 없으면 새로 생성
    if _sqlite_connection is None:
        # check_same_thread=False 옵션으로 멀티스레드 환경에서 사용 가능하게 설정
        _sqlite_connection = sqlite3.connect(
            "chatbot_memory.db", check_same_thread=False)
        print("✓ 새로운 SQLite 연결 생성!")
    else:
        print("✓ 기존 SQLite 연결 재사용!")
    
    return _sqlite_connection