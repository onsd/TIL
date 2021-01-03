from datetime import datetime
import time

# local files
import image
import recognize_digits
from save_csv import save_csv

import RPi.GPIO as GPIO
GPIO.setwarnings(False)
GPIO.setmode(GPIO.BCM)
GPIO.setup(3, GPIO.OUT)


def get_qr_value():
    qr_value = input()
    return qr_value


def main():
    # バーコードを読み取る
    qr = get_qr_value()
    print("qr value: %s" % qr)

    before_cnt = 0
    cnt = 0
    while True:
        # 画像を撮影する
        image_path = image.save_image()
        # 撮影した画像から数字を読み取る
        cnt = recognize_digits.recognize_digits(image_path)
        print('{} current value: {}'.format(
            int(time.mktime(time.gmtime())), cnt))  # 現在時間, カウントの値

        # 前の値と変更があったとき csv に保存する
        if not cnt == before_cnt:
            save_csv(qr, cnt)
            # light on GPIO2
            GPIO.output(3, GPIO.HIGH)
            time.sleep(1)

        # light off GPIO2
        GPIO.output(3, GPIO.LOW)
        before_cnt = cnt


if __name__ == '__main__':
    main()
