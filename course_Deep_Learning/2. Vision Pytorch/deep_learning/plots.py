import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

from sklearn.metrics import confusion_matrix

def plot_loss_curve(lst_epoch, lst_tr_loss, lst_te_loss):
    plt.figure(figsize=(10, 7))
    plt.plot(lst_epoch, lst_tr_loss, label="Train Loss")
    plt.plot(lst_epoch, lst_te_loss, label="Test Loss")
    plt.title("Train and Test Loss Curves")
    plt.ylabel("Loss")
    plt.xlabel("Epoch")
    plt.legend()
    plt.show();

def plot_heatmap(targets, preds, class_name):
    conf_mx = confusion_matrix(np.array(targets), np.array(preds), normalize='true')

    plt.figure(figsize=(7,5))
    sns.heatmap(
        conf_mx, annot=True, cmap="coolwarm", linewidth=0.5,
        # 컬럼명 추가하고 싶어.
        xticklabels=class_name, yticklabels=class_name
    )

    plt.xlabel('Predicted')
    plt.ylabel('Actual')
    plt.show()



