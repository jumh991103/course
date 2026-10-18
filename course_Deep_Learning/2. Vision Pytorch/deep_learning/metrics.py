
from sklearn.metrics import f1_score
import numpy as np

def f1_score_fn(y_true, y_pred):
    return f1_score(
        np.array(y_true), np.array(y_pred), average='weighted')

def accuracy_fn(y_true, y_pred):
    # torch.eq(A, B): A와 B가 같은면, True
    # torch.eq(y_true, y_pred).sum() => True의 수
    # torch.eq(y_true, y_pred).sum().item() => Tensor to python
    correct_cnt = torch.eq(y_true, y_pred).sum().item()
    # 정확도 = (전체 맞은 수 / 전체 수) * 100
    accuracy = (correct_cnt / len(y_pred)) * 100
    return accuracy
