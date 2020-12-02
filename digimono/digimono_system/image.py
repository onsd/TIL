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
    cap = cv2.VideoCapture(2)
    th = 50
    filename = ""
    while True:
        _, frame = cap.read()
        # cv2.imshow(window_name, frame)
        if n == th:
            n = 0
            filename = '{}_{}.{}'.format(
                './out/raw_', datetime.datetime.now().strftime('%Y%m%d%H%M%S%f'), 'jpg')
            cv2.imwrite(filename, frame)
            break

        n += 1

    # cap.release()
    # cv2.destroyAllWindows()
    return filename


if __name__ == "__main__":
    image_path = save_image()
    print(image_path)
