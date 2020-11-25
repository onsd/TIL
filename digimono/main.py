from datetime import datetime
import time

# local files
import counter
import image
from save_csv import save_csv


def get_qr_value():
    qr_value = input()
    return qr_value


def main():
    qr = get_qr_value()
    print("qr value: %s" % qr)
    before_cnt = 49
    cnt = 50
    while True:
        img = image.get_image()
        cnt = image.get_count(img)
        print('{} current value: {}'.format(
            int(time.mktime(time.gmtime())), cnt))
        if not cnt == before_cnt:
            save_csv(qr, cnt)

        before_cnt = cnt
        time.sleep(5)


if __name__ == '__main__':
    main()
