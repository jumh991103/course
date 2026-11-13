import boto3
import pandas as pd
from io import StringIO

from common.utils import get_now

def mk_path_csv_of_s3(file_name:str) -> str:
  now = get_now()
  if file_name.endswith('.csv'):
    file_name = file_name[:-4]

  file_name = file_name + f"-{now.microsecond}.csv"
  return f"year={now.year}/month={now.month}/day={now.day}/hour={now.hour}/minute={now.minute}/{file_name}"

def is_s3_bucket(bucket_name: str) -> bool:
  result = False
  s3 = boto3.resource('s3')
  buckets = s3.buckets.all()
  lst_names = [bucket.name for bucket in buckets]
  if bucket_name in lst_names:
    result = True
  
  return result

def upload_csv_to_s3(df: pd.DataFrame, bucket: str, path: str) -> None:
  if not is_s3_bucket(bucket):
    raise ValueError(f"Bucket {bucket} does not exist.")

  client_s3 = boto3.client('s3')
  csv_buffer = StringIO()
  df.to_csv(csv_buffer, index=False, encoding='utf-8-sig')
  client_s3.put_object(Bucket=bucket, Key=path, Body=csv_buffer.getvalue())

def download_csv_from_s3(bucket: str, path: str) -> pd.DataFrame:
  if not is_s3_bucket(bucket):
    raise ValueError(f"Bucket {bucket} does not exist.")

  client_s3 = boto3.client('s3')
  obj = client_s3.get_object(Bucket=bucket, Key=path)
  df = pd.read_csv(obj['Body'], encoding='utf-8-sig')
  return df
