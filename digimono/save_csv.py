import csv   
from datetime import datetime

def save_csv(qr, value):
    with open('document.csv','a', newline='') as f:
        writer = csv.writer(f)
        writer.writerow([qr, value, datetime.now().timestamp()])