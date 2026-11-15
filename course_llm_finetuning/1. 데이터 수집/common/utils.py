import os 

def mkdir(path=None, default="./download/"):
  if path:
    path = default+path
  else:
    path = default
  os.makedirs(path, exist_ok=True)
  return path

