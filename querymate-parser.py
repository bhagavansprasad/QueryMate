import os
import re
from datetime import datetime
import json
from collections import defaultdict

def process_line(line, base_path, message_start_pattern, current_message):
    """Processes a single line and determines its type (new message, system, or multiline)."""
    match = re.match(message_start_pattern, line)
    if match:
        return parse_new_message(line, base_path), True
    else:
        current_message["message"] += f"\n{line}"
        return current_message, False

def parse_new_message(line, base_path):
    """Parses a new message (either user or system)."""
    user_message = parse_user_message(line, base_path)
    if user_message:
        return user_message
    return parse_system_message(line)


def parse_user_message(line, base_path):
    """Parses a user message and extracts details."""
    user_message_pattern = r"^(\d{1,2}/\d{1,2}/\d{2,4}), (\d{1,2}:\d{2} ?(?:AM|PM)) - ([^:]+): (.*)$"
    match = re.match(user_message_pattern, line)

    if not match:
        return None
    
    date, time, sender, content = match.groups()
    datetime_str = normalize_time(date, time)
    attachment = parse_attachment(content, base_path)
    message = content.strip() if not attachment else ""
    return {
        "datetime": datetime_str,
        "sender": sender,
        "message": message,
        "attachment": attachment,
    }

def parse_system_message(line):
    """Parses a system message."""
    system_message_pattern = r"^(\d{1,2}/\d{1,2}/\d{2,4}), (\d{1,2}:\d{2} ?(?:AM|PM)) - (.+)$"
    match = re.match(system_message_pattern, line)
    if match:
        date, time, content = match.groups()
        datetime_str = normalize_time(date, time)
        return {
            "datetime": datetime_str,
            "sender": None,
            "message": content.strip(),
            "attachment": None,
        }
    return None


def normalize_time(date, time):
    """Normalizes the date and time into a standard datetime string."""
    time = time.replace("\u202f", " ")  # Normalize time
    datetime_combined = datetime.strptime(f"{date} {time}", "%m/%d/%y %I:%M %p")
    return datetime_combined.strftime("%Y-%m-%d %H:%M:%S")


def parse_attachment(content, base_path):
    """Parses and extracts attachment details from the message content."""
    attachment_pattern = r"(.*\.(jpg|jpeg|png|pdf|mp4|docx)) \((.* attached)\)$"
    match = re.match(attachment_pattern, content)
    if not match:
        return None
    
    attachment_name, _, attachment_type = match.groups()
    return {
        "name": os.path.join(base_path, attachment_name.strip()),
        "type": attachment_type.strip(),
    }


def load_whatsapp_chat(file_path):
    base_path =  os.path.dirname(file_path)
    message_start_pattern = r"^\d{1,2}/\d{1,2}/\d{2,4}, \d{1,2}:\d{2} ?(?:AM|PM) - "

    messages = []
    current_message = None

    try:
        rfd = open(file_path, 'r', encoding='utf-8')
    except IOError as err:
        print(f"Source data does not exists {err}")
        exit(1)
    
    for line in rfd:
        line = line.rstrip()
        current_message, is_newmsg = process_line(line, base_path, message_start_pattern, current_message)
        if (is_newmsg):
            messages.append(current_message)

    rfd.close()
    
    # messages.append(current_message)
    return messages


# Function to remove duplicates
def remove_duplicates(data):
    seen = set()
    unique_data = []
    for d in data:
        # Serialize the dictionary to a JSON-formatted string
        json_str = json.dumps(d, sort_keys=True)
        if json_str not in seen:
            seen.add(json_str)
            unique_data.append(d)
        else:
            print(json_str)
    return unique_data

def dump_duplicates(data):
    print(type(data))
    # Group dictionaries by their items
    grouped_dicts = defaultdict(list)
    try:
        for index, d in enumerate(data):
            # Convert dictionary items to frozenset for hashing
            dict_items = frozenset((k, frozenset(v.items()) if isinstance(v, dict) else v) for k, v in d.items())
            grouped_dicts[dict_items].append(index)
    except AttributeError as err:
        print(err)
        print(d)
        print(index)
        exit(1)

    # Identify duplicates
    duplicates = {key: indices for key, indices in grouped_dicts.items() if len(indices) > 1}

    # Display duplicate entries
    print(f"Duplicates :{len(duplicates)}")
    
    for key, indices in duplicates.items():
        print(f"Duplicate dictionaries found at indices: {indices}")
        print("=====================================")
        for idx in indices:
            print(data[idx])
        print("=====================================")
        print()
        # break

def main():
    fname = 'userdata/sabarimala/chat-sabarimala.txt'
    fname = 'userdata/wa-sabarimala-short.txt'
    fname = 'userdata/wa-sabarimala.txt'
    messages = load_whatsapp_chat(fname)
    print(json.dumps(messages, indent=4))

    # dump_duplicates(messages)
    print(f"Messages len :{len(messages)}")

    # data = remove_duplicates(messages)
    # print(f"After deleting duplicates :{len(data)}")

    wfd = open("chat-sabarimala.json", "w")
    json.dump(messages, wfd, indent=4)
    wfd.close()

if __name__ == "__main__":
    main()