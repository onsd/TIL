# coding:utf-8

import unittest
import ocr
import cv2


class FizzBuzzTest(unittest.TestCase):
    def setUp(self):
        # 初期化処理
        pass

    def tearDown(self):
        # 終了処理
        pass

    def test_normal(self):
        img = cv2.imread('./testdata/number.png')
        self.assertEqual('2502', ocr.digital_ocr(img))

    def test_204(self):
        img = cv2.imread('./testdata/204.png')
        self.assertEqual('204', ocr.digital_ocr(img))


if __name__ == "__main__":
    unittest.main()
