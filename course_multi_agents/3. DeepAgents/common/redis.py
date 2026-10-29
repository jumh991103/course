from redis import Redis 

def get_redis_client():
    redis_client = Redis(
        host="127.0.0.1", 
        port=6379, 
        db=0, 
        decode_responses=True, 
        protocol=3
    )

    try:
        modules = redis_client.execute_command("MODULE LIST")
        has_json = any(m.get('name') == b'ReJSON' or m.get('name') == 'ReJSON' for m in modules)
        if has_json:
            print("RedisJSON 모듈 확인 완료!")
        else:
            print("RedisJSON 모듈이 없습니다. 이미지를 확인하세요.")
    except Exception as e:
        print(f"명령어 실행 실패: {e}")

    return redis_client

