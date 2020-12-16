import scanner
if __name__ == '__main__':
    try:
        while True:
            upcnumber = scanner.barcode_reader()
            print(upcnumber)
    except KeyboardInterrupt:
        print('Keyboard interrupt')
    except Exception as err:
        print(err)
    print('done')