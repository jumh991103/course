https://docs.aws.amazon.com/ko_kr/systems-manager/latest/userguide/systems-manager-automation.html

| 상황              | 추천                 |
| --------------- | ------------------ |
| 서버리스 워크플로우      | **Step Functions** |
| Airflow DAG 그대로 | MWAA               |
| 정기 스케줄          | EventBridge        |
| EC2 운영 자동화      | SSM Automation     |
