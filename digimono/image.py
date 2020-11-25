import ocr
import cv2
import time
import datetime


def get_image_name():
    now = datetime.datetime.now()
    return now.strftime('%Y%m%d_%H%M%S') + '.png'


def get_count(image):
    return ocr.digital_ocr(image)


def get_image():
    cycle = 3
    n = 0
    cap = cv2.VideoCapture(2)

    ret, frame = cap.read()
    for i in range(10):
        # VideoCaptureから1フレーム読み込む
        ret, frame = cap.read()

        # スクリーンショットを撮りたい関係で1/4サイズに縮小
        frame = cv2.resize(
            frame, (int(frame.shape[1]/4), int(frame.shape[0]/4)))
        # 加工なし画像を表示する
        cv2.imshow('Raw Frame', frame)

        # キー入力を1ms待って、k が27（ESC）だったらBreakする
        k = cv2.waitKey(1)
        if k == 27:
            break

    cap.release()
    cv2.destroyAllWindows()
    return frame


if __name__ == "__main__":
    frame = get_image()
    print(frame)
