import ocr
import cv2
import time
import datetime


def get_image_name():
    now = datetime.datetime.now()
    return now.strftime('%Y%m%d_%H%M%S') + '.png'


def get_count(image):
    return ocr.digital_ocr(image)


def save_image():
    n = 0
    cap = cv2.VideoCapture(0)
    th = 50
    file_path = ""
    while True:
        _, frame = cap.read()
        # cv2.imshow(window_name, frame) #画像を表示するウィンドウを開く
        if n == th:  # 一定時間安定するのを待ってから撮影する
            n = 0
            file_path = '{}_{}.{}'.format(
                './out/raw_', datetime.datetime.now().strftime('%Y%m%d%H%M%S%f'), 'jpg')
            cv2.imwrite(file_path, frame)
            break

        n += 1

    # cap.release() # ウィンドウを開放する
    # cv2.destroyAllWindows() # ウィンドウを消す
    return file_path


if __name__ == "__main__":
    image_path = save_image()
    print(image_path)
