import logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

import warnings
warnings.filterwarnings(action='ignore')

import json
import pandas as pd
from common.aws_s3 import mk_path_csv_of_s3, upload_csv_to_s3

def lambda_handler(event:dict, context:str) -> None:
  logging.info("lambda_handler START")
  path_csv = mk_path_csv_of_s3("lambda_test")
  path_csv = "raw/"+path_csv
  bucket_name = "lambda-good593"

  upload_csv_to_s3(df=pd.DataFrame([event])
                    , bucket=bucket_name, path=path_csv)
  return {
    'statusCode': 200,
    'body': json.dumps(event)
  }

