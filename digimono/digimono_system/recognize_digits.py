# 必要なパッケージを import
from imutils.perspective import four_point_transform
from imutils import contours
import imutils
import cv2
import sys

import numpy as np


# 7 segment display のどの segment が光っているかを 0,1 で表現する
DIGITS_LOOKUP = {
    (1, 1, 1, 0, 1, 1, 1): 0,
    (0, 0, 1, 0, 0, 1, 0): 1,
    (1, 0, 1, 1, 1, 1, 0): 2,
    (1, 0, 1, 1, 0, 1, 1): 3,
    (0, 1, 1, 1, 0, 1, 0): 4,
    (1, 1, 0, 1, 0, 1, 1): 5,
    (1, 1, 0, 1, 1, 1, 1): 6,
    (1, 0, 1, 0, 0, 1, 0): 7,
    (1, 1, 1, 1, 1, 1, 1): 8,
    (1, 1, 1, 1, 0, 1, 1): 9,

    # 認識していく上でのありがちな間違いを人力で覚える
    (1, 0, 1, 1, 1, 0, 1): 2,
    (0, 1, 1, 1, 0, 0, 0): 4,
    (1, 1, 1, 1, 0, 1, 0): 4,
    (1, 1, 1, 1, 0, 0, 0): 4,
    (0, 0, 1, 0, 1, 0, 1): 2,
    (0, 1, 0, 1, 0, 1, 1): 5,
    (1, 0, 0, 1, 0, 1, 1): 5,
    (0, 0, 1, 1, 1, 1, 1): 2,
    (0, 1, 0, 1, 0, 0, 0): 4,
    (1, 1, 0, 0, 1, 1, 1): 1,
    (1, 1, 1, 0, 0, 1, 1): 1,
    (1, 1, 1, 0, 1, 0, 1): 1,
    (1, 0, 1, 0, 1, 1, 1): 1,
    (1, 0, 1, 0, 0, 1, 1): 1,
    (1, 1, 0, 1, 1, 0, 1): 1,
    (1, 1, 0, 1, 1, 0, 1): 1,
    (0, 1, 0, 1, 1, 0, 0): 1
}


def adjust(img, alpha=1.0, beta=0.0):
    # 積和演算を行う。
    dst = alpha * img + beta
    # [0, 255] でクリップし、uint8 型にする。
    return np.clip(dst, 0, 255).astype(np.uint8)


def recognize_digits(image_path):
    # image_path の写真を読み込む
    image = cv2.imread(image_path)
    if image is None:
        print('image is None')
        sys.exit(-1)

    # 前処理をする
    # リサイズ
    image = imutils.resize(image, height=500)
    if image is None:
        print('image = imutils.resize(image, height=500) is None')
        sys.exit(-1)

    # グレースケール
    gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

    # ガウシアンブラー (ぼやかす処理) をする
    blurred = cv2.GaussianBlur(gray, (5, 5), 0)
    cv2.imwrite('./out/000_bulurred.png', blurred)

    # Canny法による edge 検出
    # ガウシアンブラーをかけているので、曖昧なedge もつながっていると検出できる
    edged = cv2.Canny(blurred, 25, 200, 255)
    cv2.imwrite('./out/00_output_edged.png', edged)

    # 矩形検出を行い、大きさごとにならべる
    cnts = cv2.findContours(edged.copy(), cv2.RETR_EXTERNAL,
                            cv2.CHAIN_APPROX_SIMPLE)
    cnts = imutils.grab_contours(cnts)
    cnts = sorted(cnts, key=cv2.contourArea, reverse=True)
    displayCnt = None
    # 見つかった輪郭でループ
    for c in cnts:
        # 頂点を探す
        peri = cv2.arcLength(c, True)
        approx = cv2.approxPolyDP(c, 0.02 * peri, True)
        # 4つ頂点が見つかればそれをディスプレイとする
        if len(approx) == 4:
            displayCnt = approx
            break

    # ディスプレイだけ切り出す
    output = four_point_transform(image, displayCnt.reshape(4, 2))
    height = output.shape[0]
    width = output.shape[1]
    print('height: {}, width: {}'.format(height, width))

    # リサイズする
    output_resized = output[33:height-55, 20:width]
    cv2.imwrite('./out/01_output_resized.png', output_resized)

    # グレースケール
    gray = cv2.cvtColor(output_resized, cv2.COLOR_BGR2GRAY)
    cv2.imwrite('./out/02_gray.png', gray)

    # 2値化（100:２値化の閾値／画像を見て調整する）
    # ret, thresh1 = cv2.threshold(gray, 103, 255, cv2.THRESH_BINARY)
    ret, thresh1 = cv2.threshold(gray, 75, 255, cv2.THRESH_BINARY)
    cv2.imwrite("./out/03_thresh.png", thresh1)

    # ノイズ処理（モルフォロジー変換）
    kernel = np.ones((4, 4), np.uint8)
    img_opening = cv2.morphologyEx(thresh1, cv2.MORPH_OPEN, kernel)
    cv2.imwrite("./out/04_morphology.png", img_opening)

    # ネガポジ反転
    img_bitwise = cv2.bitwise_not(img_opening)
    cv2.imwrite("./out/5_bitwise_not.png", img_bitwise)

    # 輪郭を探す
    cnts = cv2.findContours(img_bitwise.copy(), cv2.RETR_EXTERNAL,
                            # cnts = cv2.findContours(img_opening.copy(), cv2.RETR_EXTERNAL,
                            cv2.CHAIN_APPROX_SIMPLE)
    cnts = imutils.grab_contours(cnts)

    digitCnts = []
    max_width = 0
    original_img = img_bitwise.copy()
    original_img_all = img_bitwise.copy()

    # 輪郭の数だけループ
    for i, cnt in enumerate(cnts):
        img = img_bitwise.copy()
        x, y, w, h = cv2.boundingRect(cnt)
        start_point = (x, y)
        end_point = (x + w, y + h)
        color = (255, 255, 0)
        cv2.rectangle(img, start_point, end_point, color, cv2.LINE_4)
        cv2.rectangle(original_img_all, start_point,
                      end_point, color, cv2.LINE_4)

        print('i:{}, x: {}, y:{}, w: {}, h:{}'.format(i, x, y, w, h))
        cv2.imwrite('./out/result-{}.png'.format(i), img)

        # 大きさがある程度ある => 数字だと判断
        if 5 < w and 30 < h:
            digitCnts.append(cnt)
            cv2.rectangle(original_img, start_point,
                          end_point, color, cv2.LINE_4)

        # 文字の幅を覚えておく
        if max_width < w:
            print('max_width is {}'.format(w))
            max_width = w
    cv2.imwrite('./out/result-collect-all.png', original_img)
    cv2.imwrite('./out/result-all.png', original_img_all)

    # 左から右にソートする
    digitCnts = contours.sort_contours(digitCnts, method="left-to-right")[0]

    digits = []
    for index, c in enumerate(digitCnts):
        # extract the digit ROI
        (x, y, w, h) = cv2.boundingRect(c)

        if w*2 < max_width:
            x = x - max_width + 10
            if 0 > x:
                x = 3
                w = max_width - x

        w = max_width

        print('x: {}, y: {}, h: {}, w: {}'.format(x, y, h, w))
        roi = img_bitwise[y:y + h, x:x + w]
        cv2.imwrite('./out/demo-{}.jpg'.format(x), roi)

        # 7セグの位置を計算する
        (roiH, roiW) = roi.shape
        (dW, dH) = (int(roiW * 0.25), int(roiH * 0.15))
        dHC = int(roiH * 0.05)
        # 7セグのセグメントの位置を決める
        segments = [
            ((0, 0), (w, dH)),  # top
            ((0, 0), (dW, h // 2)),  # top-left
            ((w - dW, 0), (w, h // 2)),  # top-right
            ((0, (h // 2) - dHC), (w, (h // 2) + dHC)),  # center
            ((0, h // 2), (dW, h)),  # bottom-left
            ((w - dW, h // 2), (w, h)),  # bottom-right
            ((0, h - dH), (w, h))  # bottom
        ]
        on = [0] * len(segments)
        # segmentでループ
        for (i, ((xA, yA), (xB, yB))) in enumerate(segments):
            # 各セグメントごとに占めるピクセルがしきい値を超えているか探す
            segROI = roi[yA: yB, xA: xB]
            cv2.imwrite('./out/demo-{}-{}.jpg'.format(x, i), segROI)

            total = cv2.countNonZero(segROI)
            area = (xB - xA) * (yB - yA)
            # セグメントごとに 50% を超えていたら そこにあると認識
            thresould = 0.5 if index == len(digitCnts)-1 and i == 0 else 0.35
            # print('i: {}, t: {}'.format(index, thresould))
            if total / float(area) > thresould:
                on[i] = 1

        # 数字をみつける
        digit = DIGITS_LOOKUP.get(tuple(on), '?')
        print('predict: {}'.format(digit))
        if digit == '?':
            print('recognized: {}'.format(on))
        digits.append(digit)

    # 数字を返す
    return "".join(map(str, digits))


if __name__ == "__main__":
    image_path = './test/2502_full.jpg'
    digits = recognize_digits(image_path)
    print(digits)
