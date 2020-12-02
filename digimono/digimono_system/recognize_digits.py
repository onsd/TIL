# import the necessary packages
from imutils.perspective import four_point_transform
from imutils import contours
import imutils
import cv2
import sys

import numpy as np


# define the dictionary of digit segments so we can identify
# each digit on the thermostat
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

    # 人力
    (1, 0, 1, 1, 1, 0, 1): 2,
    (1, 0, 1, 0, 1, 0, 1): 0,
    (0, 1, 1, 1, 0, 0, 0): 4,
    (1, 1, 1, 1, 0, 1, 0): 4,
    (1, 1, 1, 1, 0, 0, 0): 4,
    (0, 0, 1, 0, 1, 0, 1): 2,
    (0, 1, 0, 1, 0, 1, 1): 5,
    (1, 0, 0, 1, 0, 1, 1): 5,
    (1, 0, 1, 0, 1, 1, 1): 0,
    (0, 0, 1, 1, 1, 1, 1): 2,
    (0, 1, 0, 1, 0, 0, 0): 4
}


def adjust(img, alpha=1.0, beta=0.0):
    # 積和演算を行う。
    dst = alpha * img + beta
    # [0, 255] でクリップし、uint8 型にする。
    return np.clip(dst, 0, 255).astype(np.uint8)


def recognize_digits(image_path):
    # load the example image
    image = cv2.imread(image_path)
    if image is None:
        print('image is None')
        sys.exit(-1)

    # pre-process the image by resizing it, converting it to
    # graycale, blurring it, and computing an edge map
    image = imutils.resize(image, height=500)
    if image is None:
        print('image = imutils.resize(image, height=500) is None')
        sys.exit(-1)

    gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    blurred = cv2.GaussianBlur(gray, (5, 5), 0)
    edged = cv2.Canny(blurred, 50, 200, 255)

    # find contours in the edge map, then sort them by their
    # size in descending order
    cnts = cv2.findContours(edged.copy(), cv2.RETR_EXTERNAL,
                            cv2.CHAIN_APPROX_SIMPLE)
    cnts = imutils.grab_contours(cnts)
    cnts = sorted(cnts, key=cv2.contourArea, reverse=True)
    displayCnt = None
    # loop over the contours
    for c in cnts:
        # approximate the contour
        peri = cv2.arcLength(c, True)
        approx = cv2.approxPolyDP(c, 0.02 * peri, True)
        # if the contour has four vertices, then we have found
        # the thermostat display
        if len(approx) == 4:
            displayCnt = approx
            break

    # extract the thermostat display, apply a perspective transform
    # to it
    # warped = four_point_transform(gray, displayCnt.reshape(4, 2))
    output = four_point_transform(image, displayCnt.reshape(4, 2))

    height = output.shape[0]
    width = output.shape[1]
    print('height: {}, width: {}'.format(height, width))
    # output_resized = output[33:height-f55, 90:width-35]
    output_resized = output[32:height-50, 90:width-30]

    cv2.imwrite('./out/01_output_resized.png', output_resized)
    gray = cv2.cvtColor(output_resized, cv2.COLOR_BGR2GRAY)
    cv2.imwrite('./out/02_gray.png', gray)

    # 2値化（100:２値化の閾値／画像を見て調整する）
    # ret, thresh1 = cv2.threshold(gray, 103, 255, cv2.THRESH_BINARY)
    ret, thresh1 = cv2.threshold(gray, 50, 255, cv2.THRESH_BINARY)
    cv2.imwrite("./out/03_thresh.png", thresh1)

    # ノイズ処理（モルフォロジー変換）
    kernel = np.ones((4, 4), np.uint8)
    img_opening = cv2.morphologyEx(thresh1, cv2.MORPH_OPEN, kernel)
    cv2.imwrite("./out/04_morphology.png", img_opening)

    # ネガポジ反転
    img_bitwise = cv2.bitwise_not(img_opening)
    cv2.imwrite("./out/5_bitwise_not.png", img_bitwise)

    # find contours in the thresholded image, then initialize the
    # digit contours lists
    cnts = cv2.findContours(img_bitwise.copy(), cv2.RETR_EXTERNAL,
                            cv2.CHAIN_APPROX_SIMPLE)
    cnts = imutils.grab_contours(cnts)

    digitCnts = []
    for i, cnt in enumerate(cnts):
        img = img_bitwise.copy()
        x, y, w, h = cv2.boundingRect(cnt)
        cv2.rectangle(img, (x, y), (x + w, y + h),
                      (255, 0, 0), cv2.LINE_4)

        if 10 < w and 20 < h:
            # print('w: {}, h:{}'.format(w, h))
            cv2.imwrite('./out/result-{}.png'.format(i), img)
            digitCnts.append(cnt)

    digitCnts = contours.sort_contours(digitCnts, method="left-to-right")[0]
    digits = []

    for index, c in enumerate(digitCnts):
        # extract the digit ROI
        (x, y, w, h) = cv2.boundingRect(c)
        roi = img_bitwise[y:y + h, x:x + w]
        # print('img: {}, roi:{}'.format(img_bitwise.shape, roi.shape))

        # theta = 2.5  # 回転角
        # scale = 1.0    # 回転角度・拡大率

        # # 画像の中心座標
        # oy, ox = int(roi.shape[0]/2), int(roi.shape[1]/2)

        # # 方法2(OpenCV)
        # R = cv2.getRotationMatrix2D((ox, oy), theta, scale)    # 回転変換行列の算出
        # roi = cv2.warpAffine(roi, R, gray.shape,
        #                      flags=cv2.INTER_CUBIC)    # アフィン変換

        cv2.imwrite('./out/demo-{}.jpg'.format(x), roi)

        # compute the width and height of each of the 7 segments
        # we are going to examine
        (roiH, roiW) = roi.shape
        (dW, dH) = (int(roiW * 0.25), int(roiH * 0.15))
        dHC = int(roiH * 0.05)
        # define the set of 7 segments
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
        # loop over the segments
        for (i, ((xA, yA), (xB, yB))) in enumerate(segments):
            # extract the segment ROI, count the total number of
            # thresholded pixels in the segment, and then compute
            # the area of the segment
            segROI = roi[yA: yB, xA: xB]
            cv2.imwrite('./out/demo-{}-{}.jpg'.format(x, i), segROI)

            total = cv2.countNonZero(segROI)
            area = (xB - xA) * (yB - yA)
            # if the total number of non-zero pixels is greater than
            # 50% of the area, mark the segment as "on"
            thresould = 0.5 if index == len(digitCnts)-1 and i == 0 else 0.35
            # print('i: {}, t: {}'.format(index, thresould))
            if total / float(area) > thresould:
                on[i] = 1
        # lookup the digit and draw it on the image
        # digits.append(tuple(on))
        # print(tuple(on))
        digit = DIGITS_LOOKUP.get(tuple(on), '?')
        print('predict: {}'.format(digit))
        digits.append(digit)

        # draw rectangle to show estimated numbers
        # cv2.rectangle(output, (x, y), (x + w, y + h), (0, 255, 0), 1)
        # cv2.putText(output, str(digit), (x - 10, y - 10),
        #             cv2.FONT_HERSHEY_SIMPLEX, 0.65, (0, 255, 0), 2)
    return "".join(map(str, digits))


if __name__ == "__main__":
    image_path = './test/2502_full.jpg'
    digits = recognize_digits(image_path)
    print(digits)
