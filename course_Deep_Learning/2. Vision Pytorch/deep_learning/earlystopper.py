import torch
import numpy as np

class EarlyStopper:
    # 생성함수(시도 횟수, 저장할 파일명) -> None:
    def __init__(self, trial_max_num:int=10, save_model_path:str="best_model.pt") -> None:
        # 1. 테스트 베스트 loss 초기화 = > 무한 np.inf
        self.best_loss = np.inf
        # 2-1. 최대 시도 횟수 초기화 => 하이퍼 파라미터 > 0
        self.trial_max_num = trial_max_num if trial_max_num > 0 else 1
        # 2-2. 시도 횟수 초기화 => 0
        self.current_trial = 0
        # 3. 가장 똑똑한 모델 저장할 파일명
        self.save_model_path = save_model_path

    # 멈춰(테스트 loss, 모델) -> bool:
    def is_stop(self, model, test_loss) -> bool:
        # 1. 만약 테스트 loss가 테스트 베스트 loss보다 작으면,
        if test_loss < self.best_loss:
        #  => 테스트 베스트 loss를 테스트 loss 수정
            self.best_loss = test_loss
        #  => 시도 횟수를 0으로 초기화
            self.current_trial = 0
        #  => 모델 저장
            torch.save(model, self.save_model_path)
        #  => 진행해
            return False

        #2. 만약 테스트 loss가 테스트 베스트 loss보다 크거나 같으면서,
        #&& 시도 횟수가 최대 시도 횟수보다 작은 경우
        elif test_loss >= self.best_loss and self.current_trial < self.trial_max_num:
        #  => 시도 횟수 1 증가
            self.current_trial += 1
        #  => 진행해
            return False

        #3. 그 외,
        #  => 멈춰
        return True


    def get_best_model(self):
        return torch.load(self.save_model_path, weights_only=False)
