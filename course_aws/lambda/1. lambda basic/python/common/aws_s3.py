
import boto3
import json
from common.utils import get_now

def mk_path_json_of_s3(file_name:str) -> str:
  now = get_now()
  if file_name.endswith('.json'):
    file_name = file_name[:-5]

  file_name = file_name + f"-{now.microsecond}.json"
  return f"year={now.year}/month={now.month}/day={now.day}/hour={now.hour}/minute={now.minute}/{file_name}"

def is_s3_bucket(bucket_name: str) -> bool:
  result = False
  s3 = boto3.resource('s3')
  buckets = s3.buckets.all()
  lst_names = [bucket.name for bucket in buckets]
  if bucket_name in lst_names:
    result = True
  
  return result

def upload_json_to_s3(data:json, bucket: str, path: str) -> None:
  if not is_s3_bucket(bucket):
    raise ValueError(f"Bucket {bucket} does not exist.")

  client_s3 = boto3.client('s3')
  client_s3.put_object(Bucket=bucket, Key=path, Body=json.dumps(data))

def download_json_from_s3(bucket: str, path: str) -> json:
  if not is_s3_bucket(bucket):
    raise ValueError(f"Bucket {bucket} does not exist.")

  client_s3 = boto3.client('s3')
  obj = client_s3.get_object(Bucket=bucket, Key=path)
  data = json.loads(obj['Body'].read())
  return data
