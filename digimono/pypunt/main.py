from pynput.keyboard import Key, Listener
global qr_data
def on_press():
    global qr_data
    # 1文字ずつqr_dataに
    if str(key) != 'Key.enter':
        try:
            qr_data += key.char[0:1]
            return
        except AttributeError:
            return
    # 最後はenter入力になる
    else:
        raise AttributeError
    

def get_qr_value():
    with Listener(
        on_press=on_press
    ) as listener:
        listener.join()

def main():
    print("boot")
    get_qr_value()
    print('done')



if __name__ == '__main__':
    main()