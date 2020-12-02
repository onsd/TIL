from datetime import datetime
import time

# local files
import counter
import image
import recognize_digits
from save_csv import save_csv


def get_qr_value():
    qr_value = input()
    return qr_value


def main():
    qr = get_qr_value()
    print("qr value: %s" % qr)
    before_cnt = 0
    cnt = 0
    while True:
        image_path = image.save_image()
        cnt = recognize_digits.recognize_digits(image_path)
        print('{} current value: {}'.format(
            int(time.mktime(time.gmtime())), cnt))
        if not cnt == before_cnt:
            save_csv(qr, cnt)

        before_cnt = cnt
        time.sleep(5)


if __name__ == '__main__':
    main()
