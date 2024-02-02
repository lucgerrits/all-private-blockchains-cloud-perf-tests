
import json
import codecs
import re

def calculate_packet_sizes(file_path):
    with open(file_path, 'r') as file:
        data = json.load(file)

    total_size_in = 0
    total_size_out = 0

    for packet in data:
        try:
            if 'websocket' in packet['_source']['layers']:
                websocket_info = packet['_source']['layers']['websocket']
                length = int(websocket_info.get('websocket.payload_length', 0))

                mask = websocket_info.get('websocket.mask', '0')
                if mask == '1':  # Outgoing
                    total_size_out += length
                else:  # Incoming
                    total_size_in += length
        except KeyError:
            continue

    return total_size_in, total_size_out


def unmask_websocket_payload(payload, masking_key):
    """
    Unmask a WebSocket payload using the given masking key.

    Args:
    payload (bytes): The masked payload as bytes.
    masking_key (bytes): The masking key as bytes.

    Returns:
    bytes: The unmasked payload.
    """
    unmasked = bytearray()
    for i in range(len(payload)):
        unmasked.append(payload[i] ^ masking_key[i % 4])
    return bytes(unmasked)

def decode_and_unmask_tcp_payloads(data):
    decoded_payloads = []

    for entry in data:
        try:
            # Navigating through the nested structure to find the TCP payload and the masking key
            layers = entry.get('_source', {}).get('layers', {})
            tcp_payload_hex = layers.get('tcp', {}).get('tcp.payload', '')
            websocket_layer = layers.get('websocket', {})
            masking_key_hex = websocket_layer.get('websocket.masking_key', '')

            if tcp_payload_hex:
                # Removing ':' from the hex string and converting it to bytes
                tcp_payload_bytes = codecs.decode(tcp_payload_hex.replace(':', ''), 'hex')
                tcp_payload_raw_bytes = tcp_payload_hex.replace(':', '')

                # Check if the payload is masked and unmask it
                if masking_key_hex:
                    masking_key = codecs.decode(masking_key_hex.replace(':', ''), 'hex')
                    tcp_payload_bytes = unmask_websocket_payload(tcp_payload_bytes, masking_key)

                try:
                    # Attempting to decode the bytes into a string
                    decoded_payload = tcp_payload_bytes.decode('utf-8')
                except UnicodeDecodeError:
                    # If decoding fails, it might be binary data
                    decoded_payload = f"Binary Data: {tcp_payload_bytes}"
                # append the decoded payload to the list with the original payload raw bytes
                decoded_payloads.append((decoded_payload, tcp_payload_raw_bytes))
        except Exception as e:
            # In case of any error, we skip that entry
            continue

    return decoded_payloads

def extract_json_from_payloads(payloads):
    json_payloads = []

    for payload, payload_bytes in payloads:
        # Searching for a JSON-like structure within the payload
        match = re.search(r'{.*}', payload)
        if match:
            json_string = match.group()

            try:
                # Attempting to load the string as JSON
                json_data = json.loads(json_string)
                # append the JSON data to the list with the original payload raw bytes
                json_payloads.append((json_data, payload_bytes))
            except json.JSONDecodeError:
                # If the string is not valid JSON, skip it
                continue
    # for payload in payloads:
    #     # Searching for a JSON-like structure within the payload
    #     match = re.search(r'{.*}', payload)
    #     if match:
    #         json_string = match.group()

    #         try:
    #             # Attempting to load the string as JSON
    #             json_data = json.loads(json_string)
    #             json_payloads.append(json_data)
    #         except json.JSONDecodeError:
    #             # If the string is not valid JSON, skip it
    #             continue

    return json_payloads

def main():
    file_path = "capture.json"
    file_path_capture_dump = file_path.replace('.json', '_dump.txt')
    total_size_in, total_size_out = calculate_packet_sizes(file_path)
    print(f"Total size of incoming packets: {total_size_in} bytes")
    print(f"Total size of outgoing packets: {total_size_out} bytes")

    with open(file_path, 'r') as file:
        capture_data = json.load(file)

    decoded_and_unmasked_payloads = decode_and_unmask_tcp_payloads(capture_data)
    json_payloads_new = extract_json_from_payloads(decoded_and_unmasked_payloads)

    # Writing the decoded JSON payloads to a text dump file with the same style as "dump" command in linux
    # Style:
    # 32 characters per line, every 2 characters we add a space and finish the line with a newline
    # The decoded payload is after the hex dump
    with open(file_path_capture_dump, 'w') as dump_file:
        for payload, payload_bytes in json_payloads_new:
            # Writing the hex dump of the original payload
            hex_dump = ' '.join([payload_bytes[i:i+2] for i in range(0, len(payload_bytes), 2)])
            hex_dump = '\n'.join([hex_dump[i:i+63].strip() for i in range(0, len(hex_dump), 63)]) + '\n'
            dump_file.write(hex_dump)

            # Writing the decoded payload, add a newline every 62 characters
            dump_file.write('\n'.join([json.dumps(payload, indent=None)[i:i+62] for i in range(0, len(json.dumps(payload, indent=None)), 62)]) + '\n')

            dump_file.write('\n\n\n')


if __name__ == "__main__":
    main()