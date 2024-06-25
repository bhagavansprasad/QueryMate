import re
import json
import time
import sys
import pdb
from datetime import datetime

sys.path.append("/home/bhagavan/training/aura-llm/00-utils/")
from debug_helper import whereami

import re
import pandas as pd

def parse_whatsapp_chat(file_path):
    with open(file_path, 'r', encoding='utf-8') as file:
        lines = file.readlines()

    chat_data = []
    for i, line in enumerate(lines):
        # Regular expression to match the pattern of WhatsApp messages
        # 5/8/24, 9:32 AM - +91 70057 91429: How many of you opted for Executive PG certification in AI and DS
        # print(i)
        if ((i+1) % 100 == 0):
            print(f"Parsed {i+1} lines")
            
        regex = r'^(\d{1,2}/\d{1,2}/\d{2,4}), (\d{1,2}:\d{2}\s?[APM]{2}) - ([^:]+): (.+)$'

        match = re.match(regex, line)
        if match:
            date, time, sender, message = match.groups()
            chat_data.append([date, time, sender, message])
        else:
            # If the line doesn't match, it might be a continuation of the previous message
            if chat_data:
                chat_data[-1][-1] += '\n' + line.strip()

    return chat_data

def whatsapp_to_csv(txt_file, csv_file):
    chat_data = parse_whatsapp_chat(txt_file)
    # print(chat_data)
    df = pd.DataFrame(chat_data, columns=['Date', 'Time', 'Sender', 'Message'])
    df.to_csv(csv_file, index=False)
    print(f'WhatsApp chat file {txt_file} has been converted to CSV file {csv_file}')

def main():
    fname = "./data/data.txt"
    csv_output = "./data/data.csv"
    
    whatsapp_to_csv(fname, csv_output)
    
if (__name__ == "__main__"):
    main()
