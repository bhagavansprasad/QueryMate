import re
import json
import re
from datetime import datetime
import os

def load_whatsapp_chat(file_path):
    """
    Parses a WhatsApp chat export file, ensuring correct handling of multiline messages, 
    system messages, and attachments. Prepends the file path's base directory to attachments.
    
    Args:
        file_path (str): Path to the WhatsApp chat text file.
    
    Returns:
        list: List of parsed messages, each as a dictionary with full attachment paths.
    """
    # Extract the base path from the file path
    base_path = os.path.dirname(file_path)

    # Regex to identify the start of a new message
    message_start_pattern = r"^\d{1,2}/\d{1,2}/\d{2,4}, \d{1,2}:\d{2} ?(?:AM|PM) - "

    # Regex to parse user messages with optional attachments
    user_message_pattern = (
        r"^(\d{1,2}/\d{1,2}/\d{2,4}), (\d{1,2}:\d{2} ?(?:AM|PM)) - ([^:]+): (.*)$"
    )

    # Regex to parse system messages (e.g., "You created this group")
    system_message_pattern = r"^(\d{1,2}/\d{1,2}/\d{2,4}), (\d{1,2}:\d{2} ?(?:AM|PM)) - (.+)$"

    messages = []
    current_message = None

    with open(file_path, 'r', encoding='utf-8') as file:
        for line in file:
            line = line.rstrip()

            # Detect start of a new message
            if re.match(message_start_pattern, line):
                # Save the current message if we have one
                if current_message:
                    messages.append(current_message)

                # Match user message or system message
                user_message_match = re.match(user_message_pattern, line)
                system_message_match = re.match(system_message_pattern, line)

                if user_message_match:
                    date, time, sender, content = user_message_match.groups()
                    datetime_combined = datetime.strptime(f"{date} {time}", "%m/%d/%y %I:%M %p")
                    attachment = None
                    message = content.strip()

                    # Check for explicit attachments
                    attachment_match = re.match(r"(.*\.(jpg|jpeg|png|pdf|mp4|docx)) \((.* attached)\)$", content)
                    if attachment_match:
                        attachment_name, _, attachment_type = attachment_match.groups()
                        time = time.replace("\u202f", " ")  # Normalize time
                        datetime_combined = datetime.strptime(f"{date} {time}", "%m/%d/%y %I:%M %p")
                        datetime_str = datetime_combined.strftime("%Y-%m-%d %H:%M:%S")
                        attachment = {
                            "name": os.path.join(base_path, attachment_name.strip()),  # Prepend base path
                            "type": attachment_type.strip()
                        }
                        message = ""  # No additional text if it's purely an attachment

                    current_message = {
                        "datetime": datetime_str,
                        # "time": time,
                        "sender": sender,
                        "message": message,
                        "attachment": attachment,
                    }
                elif system_message_match:
                    date, time, content = system_message_match.groups()
                    # time = time.replace("\u202f", " ") 
                    current_message = {
                        "date": date,
                        "time": time.replace("\u202f", " "),
                        "sender": None,
                        "message": content.strip(),
                        "attachment": None,
                    }
            else:
                # Multiline message - append to the current message
                if current_message:
                    current_message["message"] += f"\n{line}"

    # Add the last message
    if current_message:
        messages.append(current_message)

    return messages

# # Re-run the function to parse the file and prepend the base path
# messages_with_paths = refine_and_prepend_path_whatsapp_chat(file_path)
# messages_with_paths

import os
import re
from datetime import datetime


def extract_base_path(file_path):
    """Extract the base path from the file path."""
    return os.path.dirname(file_path)


def normalize_time(date, time):
    """Normalize time by removing special characters and converting to datetime string."""
    time = time.replace("\u202f", " ")  # Normalize time
    datetime_combined = datetime.strptime(f"{date} {time}", "%m/%d/%y %I:%M %p")
    return datetime_combined.strftime("%Y-%m-%d %H:%M:%S")


def parse_user_message(line, base_path):
    """Parse a user message and extract its details."""
    user_message_pattern = r"^(\d{1,2}/\d{1,2}/\d{2,4}), (\d{1,2}:\d{2} ?(?:AM|PM)) - ([^:]+): (.*)$"
    match = re.match(user_message_pattern, line)
    if match:
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
    return None


def parse_system_message(line):
    """Parse a system message."""
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


def parse_attachment(content, base_path):
    """Check and extract attachment details."""
    attachment_pattern = r"(.*\.(jpg|jpeg|png|pdf|mp4|docx)) \((.* attached)\)$"
    match = re.match(attachment_pattern, content)
    if match:
        attachment_name, _, attachment_type = match.groups()
        return {
            "name": os.path.join(base_path, attachment_name.strip()),
            "type": attachment_type.strip(),
        }
    return None


def append_multiline_message(current_message, line):
    """Append multiline content to the current message."""
    if current_message:
        current_message["message"] += f"\n{line}"


def load_whatsapp_chat(file_path):
    """
    Parses a WhatsApp chat export file.
    """
    base_path = extract_base_path(file_path)
    message_start_pattern = r"^\d{1,2}/\d{1,2}/\d{2,4}, \d{1,2}:\d{2} ?(?:AM|PM) - "

    messages = []
    current_message = None

    with open(file_path, 'r', encoding='utf-8') as file:
        for line in file:
            line = line.rstrip()
            if re.match(message_start_pattern, line):
                # Save the current message before starting a new one
                if current_message:
                    messages.append(current_message)

                # Attempt to parse user or system message
                current_message = (
                    parse_user_message(line, base_path)
                    or parse_system_message(line)
                )
            else:
                # Append multiline content
                append_multiline_message(current_message, line)

    # Add the last message
    if current_message:
        messages.append(current_message)

    return messages

fname = 'data/sabarimala/chat-sabarimala.txt'
messages = load_whatsapp_chat(fname)
print(json.dumps(messages, indent=4))

wfd = open("chat-sabarimala.json", "w")
json.dump(messages, wfd, indent=4)
wfd.close()
