# OpenCV のインポート
import cv2

# VideoCaptureのインスタンスを作成する。
# 引数でカメラを選べれる。


def returnCameraIndexes():
    # checks the first 10 indexes.
    index = 0
    arr = []
    i = 10
    while i > 0:
        cap = cv2.VideoCapture(index)
        if cap.read()[0]:
            arr.append(index)
            cap.release()
        index += 1
        i -= 1
    return arr


print(returnCameraIndexes())

cap = cv2.VideoCapture(1)

while True:
    # VideoCaptureから1フレーム読み込む
    ret, frame = cap.read()

    # スクリーンショットを撮りたい関係で1/4サイズに縮小
    frame = cv2.resize(frame, (int(frame.shape[1]/4), int(frame.shape[0]/4)))
    # 加工なし画像を表示する
    cv2.imshow('Raw Frame', frame)

    # キー入力を1ms待って、k が27（ESC）だったらBreakする
    k = cv2.waitKey(1)
    if k == 27:
        break

# キャプチャをリリースして、ウィンドウをすべて閉じる
cap.release()
cv2.destroyAllWindows()
