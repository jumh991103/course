from youtube_transcript_api import YouTubeTranscriptApi
from youtube_transcript_api.formatters import SRTFormatter, TextFormatter

import yt_dlp
import re
from pytube import Playlist

def get_video_urls(channel_url):
    playlist = Playlist(channel_url)

    # pytube의 파싱 버그로 playlist.video_urls가 비어있는 경우가 있어 정규식을 직접 교체
    playlist._video_regex = re.compile(r"\"url\":\"(/watch\?v=[\w-]*)")

    return playlist.video_urls

def get_youtube_video_transcript(video_id):
    transcript = YouTubeTranscriptApi().fetch(video_id=video_id, languages=['ko', 'ko-KR'])
    return " ".join(line.text for line in transcript.snippets)

def get_youtube_video_info(video_url):
    ydl_opts = {
        'noplaylist': True,
        'quiet': True,
        'no_warnings': True,
    }

    with yt_dlp.YoutubeDL(ydl_opts) as ydl:
        # 유튜브의 메타정보 추출 
        video_info = ydl.extract_info(video_url, download=False)
        return {
            "video_url": video_url,
            "video_id": video_info['id'],
            "title": video_info['title'],
            "channel": video_info['channel'],
            # 유튜브의 자막 추출 
            "caption": get_youtube_video_transcript(video_info['id'])
        }
    

