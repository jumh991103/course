import torch
from torch import nn
from tqdm.auto import tqdm

def excu_inference(
    best_model, device, test_dataloader, metrics_fn
):
    best_model.to(device)

    best_model.eval()
    score = 0.0
    lst_te_pred = []
    lst_te_y = []
    with torch.inference_mode():
        for features, targets in tqdm(
            test_dataloader, desc="Test Dataset..", leave=False):
            # te_pred.shape => (batch, target_size)
            te_pred = best_model(features.to(device, dtype=torch.float32))
            # 확률 ( 0 ~ 1 )
            te_proba = nn.Softmax(dim=1)(te_pred)
            # 1 또는 0
            te_round = torch.argmax(te_proba, dim=1).to('cpu')
            # targets.shape => (batch,)
            score += metrics_fn(y_true=targets, y_pred=te_round)

            lst_te_pred.extend(te_round.numpy())
            lst_te_y.extend(targets.numpy())

    score /= len(test_dataloader)
    print(f"{metrics_fn.__name__}: {score}")

    return lst_te_y, lst_te_pred
