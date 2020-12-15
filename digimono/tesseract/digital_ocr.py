from PIL import Image
import sys
import cv2
import numpy as np

import pyocr
import pyocr.builders

def cv2pil(image):
    ''' OpenCV型 -> PIL型 '''
    new_image = image.copy()
    if new_image.ndim == 2:  # モノクロ
        pass
    elif new_image.shape[2] == 3:  # カラー
        new_image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
    elif new_image.shape[2] == 4:  # 透過
        new_image = cv2.cvtColor(image, cv2.COLOR_BGRA2RGBA)
    new_image = Image.fromarray(new_image)
    return new_image

def convertImage(img_tr):
    #グレースケール化
    img_gray = cv2.cvtColor(img_tr, cv2.COLOR_RGB2GRAY)
    cv2.imwrite("out/01_gray.png",img_gray)

    #2値化（100:２値化の閾値／画像を見て調整する）
    ret,thresh1 = cv2.threshold(img_gray,103,255,cv2.THRESH_BINARY)
    cv2.imwrite("out/02_thresh.png",thresh1)

    #ノイズ処理（モルフォロジー変換）
    kernel = np.ones((13,13),np.uint8)
    img_opening = cv2.morphologyEx(thresh1, cv2.MORPH_OPEN, kernel)
    cv2.imwrite("out/03_open.png",img_opening)

    return cv2pil(img_opening)

def digital_ocr(image_name):
    tools = pyocr.get_available_tools()
    if len(tools) == 0:
        print("No OCR tool found")
        sys.exit(1)

    tool = tools[0]
    # print("Will use tool '%s'" % (tool.get_name()))

    img = convertImage(cv2.imread(image_name))

    txt = tool.image_to_string(
        img,
        lang="eng",
        # builder=pyocr.builders.DigitBuilder(tesseract_layout=6)
        builder=pyocr.builders.TextBuilder(tesseract_layout=6)
    )
    return txt

def main():
    count = digital_ocr()

if __name__ == '__main__':
    main()