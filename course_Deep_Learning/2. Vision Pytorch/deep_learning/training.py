import torch
from tqdm.auto import tqdm 

def excu_training(
    model, loss_fn, optimizer, early_stopper,
    train_dataloader, test_dataloader, device
):
    lst_tr_loss = []
    lst_te_loss = []
    lst_epoch = []

    for epoch in tqdm(range(1000), desc="Training.."):
        ############################################
        # 모델학습
        ############################################
        model.train()
        tr_loss = 0.0
        for features, targets in tqdm(
            train_dataloader, desc="Train Dataset..", leave=False):
            tr_pred = model(features.to(device, dtype=torch.float32))
            loss = loss_fn(tr_pred.to('cpu'), targets)
            tr_loss += loss.detach()

            optimizer.zero_grad()
            loss.backward()
            optimizer.step()

        tr_loss = tr_loss / len(train_dataloader)

        ############################################
        # 모델평가
        ############################################
        model.eval()
        te_loss = 0.0
        with torch.inference_mode():
            for features, targets in tqdm(
                test_dataloader, desc="Test Dataset..", leave=False):
                te_pred = model(features.to(device, dtype=torch.float32))
                loss = loss_fn(te_pred.to('cpu'), targets)
                te_loss += loss.detach()

        te_loss = te_loss / len(test_dataloader)

        ############################################
        # 멈춰!!
        ############################################
        if early_stopper.is_stop(model, te_loss):
            print("Early Stopping!!")
            print(f"Best Loss: {early_stopper.best_loss}")
            break

        ############################################
        # 저장
        ############################################
        if epoch % 10 == 0:
            lst_epoch.append(epoch)
            # loss.detach() => device를 cpu로 변경
            lst_tr_loss.append(tr_loss.detach().numpy())
            lst_te_loss.append(te_loss.detach().numpy())
            print(f"Epoch: {epoch} | Train Loss: {tr_loss} | Test Loss: {te_loss}")

    return lst_epoch, lst_tr_loss, lst_te_loss
