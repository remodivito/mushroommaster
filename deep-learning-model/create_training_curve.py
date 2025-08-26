#!/usr/bin/env python3

import re
import matplotlib.pyplot as plt

# training log
log = """
Epoch 1/40
890/890 ━━━━━━━━━━━━━━━━━━━━ 718s 725ms/step - accuracy: 0.0261 - loss: 4.8467 - top_5_accuracy: 0.0951 - val_accuracy: 0.0627 - val_loss: 4.5068 - val_top_5_accuracy: 0.1853 - learning_rate: 0.0010
Epoch 2/40
890/890 ━━━━━━━━━━━━━━━━━━━━ 616s 693ms/step - accuracy: 0.0526 - loss: 4.5887 - top_5_accuracy: 0.1646 - val_accuracy: 0.0784 - val_loss: 4.3727 - val_top_5_accuracy: 0.2176 - learning_rate: 0.0010
Epoch 3/40
890/890 ━━━━━━━━━━━━━━━━━━━━ 677s 761ms/step - accuracy: 0.0618 - loss: 4.4960 - top_5_accuracy: 0.1869 - val_accuracy: 0.0833 - val_loss: 4.3193 - val_top_5_accuracy: 0.2393 - learning_rate: 0.0010
Epoch 4/40
890/890 ━━━━━━━━━━━━━━━━━━━━ 625s 703ms/step - accuracy: 0.0675 - loss: 4.4535 - top_5_accuracy: 0.2018 - val_accuracy: 0.0832 - val_loss: 4.3657 - val_top_5_accuracy: 0.2314 - learning_rate: 0.0010
Epoch 5/40
890/890 ━━━━━━━━━━━━━━━━━━━━ 622s 699ms/step - accuracy: 0.0713 - loss: 4.4153 - top_5_accuracy: 0.2108 - val_accuracy: 0.0864 - val_loss: 4.3486 - val_top_5_accuracy: 0.2360 - learning_rate: 0.0010
Epoch 6/40
890/890 ━━━━━━━━━━━━━━━━━━━━ 625s 703ms/step - accuracy: 0.0722 - loss: 4.4007 - top_5_accuracy: 0.2136 - val_accuracy: 0.0965 - val_loss: 4.2324 - val_top_5_accuracy: 0.2597 - learning_rate: 0.0010
Epoch 7/40
890/890 ━━━━━━━━━━━━━━━━━━━━ 679s 763ms/step - accuracy: 0.0769 - loss: 4.3652 - top_5_accuracy: 0.2230 - val_accuracy: 0.0920 - val_loss: 4.2876 - val_top_5_accuracy: 0.2500 - learning_rate: 0.0010
Epoch 8/40
890/890 ━━━━━━━━━━━━━━━━━━━━ 622s 700ms/step - accuracy: 0.0797 - loss: 4.3459 - top_5_accuracy: 0.2289 - val_accuracy: 0.0915 - val_loss: 4.2453 - val_top_5_accuracy: 0.2565 - learning_rate: 0.0010
Epoch 9/40
890/890 ━━━━━━━━━━━━━━━━━━━━ 625s 703ms/step - accuracy: 0.0815 - loss: 4.3185 - top_5_accuracy: 0.2345 - val_accuracy: 0.0994 - val_loss: 4.1933 - val_top_5_accuracy: 0.2699 - learning_rate: 0.0010
Epoch 10/40
890/890 ━━━━━━━━━━━━━━━━━━━━ 601s 676ms/step - accuracy: 0.0847 - loss: 4.3110 - top_5_accuracy: 0.2379 - val_accuracy: 0.1016 - val_loss: 4.2170 - val_top_5_accuracy: 0.2675 - learning_rate: 0.0010
Epoch 11/40
890/890 ━━━━━━━━━━━━━━━━━━━━ 683s 768ms/step - accuracy: 0.0858 - loss: 4.2950 - top_5_accuracy: 0.2405 - val_accuracy: 0.1026 - val_loss: 4.2079 - val_top_5_accuracy: 0.2710 - learning_rate: 0.0010
Epoch 12/40
890/890 ━━━━━━━━━━━━━━━━━━━━ 582s 655ms/step - accuracy: 0.0881 - loss: 4.2816 - top_5_accuracy: 0.2465 - val_accuracy: 0.0990 - val_loss: 4.2541 - val_top_5_accuracy: 0.2581 - learning_rate: 0.0010
Epoch 13/40
890/890 ━━━━━━━━━━━━━━━━━━━━ 635s 714ms/step - accuracy: 0.0889 - loss: 4.2711 - top_5_accuracy: 0.2469 - val_accuracy: 0.1057 - val_loss: 4.1599 - val_top_5_accuracy: 0.2789 - learning_rate: 0.0010
Epoch 14/40
890/890 ━━━━━━━━━━━━━━━━━━━━ 632s 711ms/step - accuracy: 0.0922 - loss: 4.2673 - top_5_accuracy: 0.2503 - val_accuracy: 0.1112 - val_loss: 4.1411 - val_top_5_accuracy: 0.2847 - learning_rate: 0.0010
Epoch 15/40
890/890 ━━━━━━━━━━━━━━━━━━━━ 679s 764ms/step - accuracy: 0.0912 - loss: 4.2411 - top_5_accuracy: 0.2546 - val_accuracy: 0.1079 - val_loss: 4.1733 - val_top_5_accuracy: 0.2753 - learning_rate: 0.0010
Epoch 16/40
890/890 ━━━━━━━━━━━━━━━━━━━━ 625s 703ms/step - accuracy: 0.0927 - loss: 4.2328 - top_5_accuracy: 0.2576 - val_accuracy: 0.1080 - val_loss: 4.1135 - val_top_5_accuracy: 0.2864 - learning_rate: 0.0010
Epoch 17/40
890/890 ━━━━━━━━━━━━━━━━━━━━ 619s 696ms/step - accuracy: 0.0956 - loss: 4.2383 - top_5_accuracy: 0.2561 - val_accuracy: 0.1108 - val_loss: 4.1315 - val_top_5_accuracy: 0.2866 - learning_rate: 0.0010
Epoch 18/40
890/890 ━━━━━━━━━━━━━━━━━━━━ 622s 700ms/step - accuracy: 0.0959 - loss: 4.2031 - top_5_accuracy: 0.2627 - val_accuracy: 0.1138 - val_loss: 4.1154 - val_top_5_accuracy: 0.2897 - learning_rate: 0.0010
Epoch 19/40
890/890 ━━━━━━━━━━━━━━━━━━━━ 622s 700ms/step - accuracy: 0.0963 - loss: 4.2131 - top_5_accuracy: 0.2633 - val_accuracy: 0.1138 - val_loss: 4.1137 - val_top_5_accuracy: 0.2923 - learning_rate: 0.0010
Epoch 20/40
890/890 ━━━━━━━━━━━━━━━━━━━━ 684s 770ms/step - accuracy: 0.0973 - loss: 4.1995 - top_5_accuracy: 0.2645 - val_accuracy: 0.1169 - val_loss: 4.0553 - val_top_5_accuracy: 0.3008 - learning_rate: 0.0010
Epoch 21/40
890/890 ━━━━━━━━━━━━━━━━━━━━ 573s 644ms/step - accuracy: 0.0990 - loss: 4.1898 - top_5_accuracy: 0.2684 - val_accuracy: 0.1173 - val_loss: 4.0941 - val_top_5_accuracy: 0.2924 - learning_rate: 0.0010
Epoch 22/40
890/890 ━━━━━━━━━━━━━━━━━━━━ 682s 767ms/step - accuracy: 0.0986 - loss: 4.1926 - top_5_accuracy: 0.2659 - val_accuracy: 0.1154 - val_loss: 4.1061 - val_top_5_accuracy: 0.2927 - learning_rate: 0.0010
Epoch 23/40
890/890 ━━━━━━━━━━━━━━━━━━━━ 622s 700ms/step - accuracy: 0.1012 - loss: 4.1759 - top_5_accuracy: 0.2713 - val_accuracy: 0.1165 - val_loss: 4.0978 - val_top_5_accuracy: 0.2910 - learning_rate: 0.0010
Epoch 24/40
890/890 ━━━━━━━━━━━━━━━━━━━━ 622s 699ms/step - accuracy: 0.1000 - loss: 4.1776 - top_5_accuracy: 0.2724 - val_accuracy: 0.1166 - val_loss: 4.0798 - val_top_5_accuracy: 0.3003 - learning_rate: 0.0010
Epoch 25/40
890/890 ━━━━━━━━━━━━━━━━━━━━ 625s 703ms/step - accuracy: 0.1082 - loss: 4.1307 - top_5_accuracy: 0.2847 - val_accuracy: 0.1291 - val_loss: 4.0089 - val_top_5_accuracy: 0.3154 - learning_rate: 1.0000e-04
Epoch 26/40
890/890 ━━━━━━━━━━━━━━━━━━━━ 619s 696ms/step - accuracy: 0.1131 - loss: 4.0968 - top_5_accuracy: 0.2925 - val_accuracy: 0.1271 - val_loss: 4.0317 - val_top_5_accuracy: 0.3099 - learning_rate: 1.0000e-04
Epoch 27/40
890/890 ━━━━━━━━━━━━━━━━━━━━ 685s 770ms/step - accuracy: 0.1123 - loss: 4.0915 - top_5_accuracy: 0.2961 - val_accuracy: 0.1307 - val_loss: 4.0028 - val_top_5_accuracy: 0.3184 - learning_rate: 1.0000e-04
Epoch 28/40
890/890 ━━━━━━━━━━━━━━━━━━━━ 572s 644ms/step - accuracy: 0.1127 - loss: 4.0907 - top_5_accuracy: 0.2941 - val_accuracy: 0.1301 - val_loss: 4.0135 - val_top_5_accuracy: 0.3184 - learning_rate: 1.0000e-04
Epoch 29/40
890/890 ━━━━━━━━━━━━━━━━━━━━ 682s 767ms/step - accuracy: 0.1138 - loss: 4.0800 - top_5_accuracy: 0.2949 - val_accuracy: 0.1295 - val_loss: 4.0166 - val_top_5_accuracy: 0.3134 - learning_rate: 1.0000e-04
Epoch 30/40
890/890 ━━━━━━━━━━━━━━━━━━━━ 586s 659ms/step - accuracy: 0.1148 - loss: 4.0769 - top_5_accuracy: 0.2964 - val_accuracy: 0.1313 - val_loss: 3.9991 - val_top_5_accuracy: 0.3187 - learning_rate: 1.0000e-04
Epoch 31/40
890/890 ━━━━━━━━━━━━━━━━━━━━ 679s 763ms/step - accuracy: 0.1158 - loss: 4.0802 - top_5_accuracy: 0.2963 - val_accuracy: 0.1315 - val_loss: 4.0023 - val_top_5_accuracy: 0.3200 - learning_rate: 1.0000e-04
Epoch 32/40
890/890 ━━━━━━━━━━━━━━━━━━━━ 586s 660ms/step - accuracy: 0.1164 - loss: 4.0641 - top_5_accuracy: 0.2991 - val_accuracy: 0.1315 - val_loss: 3.9973 - val_top_5_accuracy: 0.3195 - learning_rate: 1.0000e-04
Epoch 33/40
890/890 ━━━━━━━━━━━━━━━━━━━━ 679s 764ms/step - accuracy: 0.1160 - loss: 4.0774 - top_5_accuracy: 0.2970 - val_accuracy: 0.1284 - val_loss: 4.0048 - val_top_5_accuracy: 0.3202 - learning_rate: 1.0000e-04
Epoch 34/140
890/890 ━━━━━━━━━━━━━━━━━━━━ 721s 725ms/step - accuracy: 0.1145 - loss: 4.0921 - top_5_accuracy: 0.2938 - val_accuracy: 0.1410 - val_loss: 3.8852 - val_top_5_accuracy: 0.3481 - learning_rate: 1.0000e-04
Epoch 35/140
890/890 ━━━━━━━━━━━━━━━━━━━━ 667s 750ms/step - accuracy: 0.1135 - loss: 4.1013 - top_5_accuracy: 0.2933 - val_accuracy: 0.1425 - val_loss: 3.8804 - val_top_5_accuracy: 0.3482 - learning_rate: 1.0000e-04
Epoch 36/140
890/890 ━━━━━━━━━━━━━━━━━━━━ 602s 678ms/step - accuracy: 0.1126 - loss: 4.0829 - top_5_accuracy: 0.2959 - val_accuracy: 0.1418 - val_loss: 3.8832 - val_top_5_accuracy: 0.3463 - learning_rate: 1.0000e-04
Epoch 37/140
890/890 ━━━━━━━━━━━━━━━━━━━━ 682s 767ms/step - accuracy: 0.1160 - loss: 4.0838 - top_5_accuracy: 0.2985 - val_accuracy: 0.1382 - val_loss: 3.8950 - val_top_5_accuracy: 0.3463 - learning_rate: 1.0000e-04
Epoch 38/140
890/890 ━━━━━━━━━━━━━━━━━━━━ 622s 700ms/step - accuracy: 0.1157 - loss: 4.0823 - top_5_accuracy: 0.2985 - val_accuracy: 0.1417 - val_loss: 3.8826 - val_top_5_accuracy: 0.3484 - learning_rate: 1.0000e-04
Epoch 39/140
890/890 ━━━━━━━━━━━━━━━━━━━━ 593s 667ms/step - accuracy: 0.1170 - loss: 4.0864 - top_5_accuracy: 0.2972 - val_accuracy: 0.1422 - val_loss: 3.8908 - val_top_5_accuracy: 0.3468 - learning_rate: 1.0000e-04
Epoch 40/140
890/890 ━━━━━━━━━━━━━━━━━━━━ 682s 767ms/step - accuracy: 0.1153 - loss: 4.0777 - top_5_accuracy: 0.2960 - val_accuracy: 0.1405 - val_loss: 3.8890 - val_top_5_accuracy: 0.3457 - learning_rate: 1.0000e-05
Epoch 41/140
890/890 ━━━━━━━━━━━━━━━━━━━━ 622s 699ms/step - accuracy: 0.1174 - loss: 4.0764 - top_5_accuracy: 0.2968 - val_accuracy: 0.1408 - val_loss: 3.8859 - val_top_5_accuracy: 0.3455 - learning_rate: 1.0000e-05
Epoch 42/140
890/890 ━━━━━━━━━━━━━━━━━━━━ 621s 699ms/step - accuracy: 0.1164 - loss: 4.0667 - top_5_accuracy: 0.2980 - val_accuracy: 0.1409 - val_loss: 3.8874 - val_top_5_accuracy: 0.3454 - learning_rate: 1.0000e-05
Epoch 43/140
890/890 ━━━━━━━━━━━━━━━━━━━━ 602s 677ms/step - accuracy: 0.1165 - loss: 4.0710 - top_5_accuracy: 0.2980 - val_accuracy: 0.1405 - val_loss: 3.8885 - val_top_5_accuracy: 0.3470 - learning_rate: 1.0000e-05
Epoch 44/140
890/890 ━━━━━━━━━━━━━━━━━━━━ 682s 767ms/step - accuracy: 0.1171 - loss: 4.0764 - top_5_accuracy: 0.2986 - val_accuracy: 0.1425 - val_loss: 3.8842 - val_top_5_accuracy: 0.3475 - learning_rate: 1.0000e-06
Epoch 45/140
890/890 ━━━━━━━━━━━━━━━━━━━━ 622s 700ms/step - accuracy: 0.1167 - loss: 4.0783 - top_5_accuracy: 0.2996 - val_accuracy: 0.1421 - val_loss: 3.8827 - val_top_5_accuracy: 0.3466 - learning_rate: 1.0000e-06
"""



# extract relevant metrics via regex
pattern = (
    r"Epoch\s+(\d+)/\d+.*?"
    r"accuracy:\s*([0-9.]+)\s*-\s*loss:\s*([0-9.]+).*?"
    r"top_5_accuracy:\s*([0-9.]+).*?"
    r"val_accuracy:\s*([0-9.]+)\s*-\s*val_loss:\s*([0-9.]+).*?"
    r"val_top_5_accuracy:\s*([0-9.]+)"
)
matches = re.findall(pattern, log, re.DOTALL)

# 2.create a list for each metric
epochs        = [int(m[0])    for m in matches]
train_acc     = [float(m[1])  for m in matches]
train_loss    = [float(m[2])  for m in matches]
train_top5    = [float(m[3])  for m in matches]
val_acc       = [float(m[4])  for m in matches]
val_loss      = [float(m[5])  for m in matches]
val_top5      = [float(m[6])  for m in matches]

plt.figure()
plt.plot(epochs, train_acc, label="Train")
plt.plot(epochs, val_acc,   label="Validation")
plt.plot(epochs, train_top5, label="Train Top 5")
plt.plot(epochs, val_top5,   label="Val Top 5")
plt.title("Training vs Validation Accuracy")
plt.xlabel("Epoch")
plt.ylabel("Accuracy")
plt.legend()
plt.grid(True)

plt.figure()
plt.plot(epochs, train_loss, label="Train")
plt.plot(epochs, val_loss,   label="Validation")
plt.title("Training vs Validation Loss")
plt.xlabel("Epoch")
plt.ylabel("Loss")
plt.legend()
plt.grid(True)

plt.show()