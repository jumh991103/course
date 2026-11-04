import pandas as pd
from tqdm.auto import tqdm
import time

from common.utils import mkdir
from .youtube_info import get_video_urls, get_youtube_video_info

def main(lst_dic:list[dict]):
  """ 유튜브를 통해서 켑션(자막) 정보를 수집하는 함수 
    lst_dic = [
      {
        "playlist_title":"유튜브 플레이 리스트 제목", 
        "url":"유튜브 플레이 리스트 url"
      }
    ]
  """

  # 유튜브 플레이 리스트별 자막 추출 진행 
  for dic_data in tqdm(lst_dic, desc="downloading.."):
    # 자막을 저장할 폴더 생성 
    save_path = mkdir()

    #########################################
    # 유튜브 url 수집
    #########################################
    urls = []
    urls.extend(
      get_video_urls(dic_data['url'])
    )

    #########################################
    # 유튜브  url 별 자막 추출 
    #########################################
    lst_info = []
    for url in urls:
      try:
        video_info = get_youtube_video_info(url)
        lst_info.append(video_info)
      except:
        pass
      time.sleep(0.1) # 디도스(해킹) 공격 의심을 받지 않기 위해서.... 

    #########################################
    # 수집된 자막 저장  
    #########################################
    df = pd.DataFrame(lst_info)
    file_name = save_path+dic_data['playlist_title']+".csv"
    df.to_csv(file_name, header=True, index=False)


