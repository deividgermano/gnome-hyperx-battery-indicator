#!/usr/bin/env python3

import hid
import time

def find_supported_device():
    # List all connected HID devices
    for device_dict in hid.enumerate():
        vendor_id = device_dict['vendor_id']
        product_id = device_dict['product_id']
        manufacturer = device_dict.get('manufacturer_string', '')
        product = device_dict.get('product_string', '')

        # You can customize these strings to match your target devices
        if manufacturer and "HP" in manufacturer or "HyperX" in manufacturer or "Kingston" in manufacturer:
            if any(keyword in product for keyword in [
                "Cloud II Core", 
                "Cloud II Wireless", 
                "Cloud Stinger 2 Wireless", 
                "Cloud Alpha Wireless"
            ]):
                return vendor_id, product_id, manufacturer, product
    return None, None, None, None

def get_battery_level():
    vendor_id, product_id, manufacturer, product = find_supported_device()
    
    if not vendor_id:
        return None,None,None

    device = hid.device()
    device.open(vendor_id, product_id)


    write_buffer = [0x00] * 52
    battery_byte_index = 7

    if "HP" in manufacturer:
        if "Cloud II Core" in product:
            write_buffer[0] = 0x66
            write_buffer[1] = 0x89
            battery_byte_index = 4
        elif "Cloud II Wireless" in product or "Cloud Stinger 2 Wireless" in product:
            write_buffer[0] = 0x06
            write_buffer[1] = 0xff
            write_buffer[2] = 0xbb
            write_buffer[3] = 0x02
        elif "Cloud Alpha Wireless" in product:
            write_buffer[0] = 0x21
            write_buffer[1] = 0xbb
            write_buffer[2] = 0x0b
            battery_byte_index = 3
    else:
        # Kingston / HyperX variant
        input_report = [0] * 160
        input_report[0] = 6
        try:
            device.get_input_report(6, 160)
        except Exception as e:
            return None,None,None

        write_buffer[0] = 0x06
        write_buffer[2] = 0x02
        write_buffer[4] = 0x9a
        write_buffer[7] = 0x68
        write_buffer[8] = 0x4a
        write_buffer[9] = 0x8e
        write_buffer[10] = 0x0a
        write_buffer[14] = 0xbb
        write_buffer[15] = 0x02

    # Write command to device
    device.write(write_buffer)

    # Set device to non-blocking read mode
    device.set_nonblocking(True)

    # Attempt to read response with manual timeout
    response = []
    timeout_ms = 1000
    start_time = time.time()

    while True:
        response = device.read(20)
        if response:
            break
        if (time.time() - start_time) * 1000 > timeout_ms:
            break
        time.sleep(0.01)

    device.close()

    if response and len(response) > battery_byte_index:
        return response[battery_byte_index], product_id, product
    else:
        return None, product_id, product

# --- Main Execution ---
battery, product_id, product = get_battery_level()
if product_id and battery:
    print(f'[{{ "icon":"audio-headphones-symbolic", "serial": "{product_id}", "model": "{product}", "percentage": "{battery}%" }}]')
elif product_id:
    print(f'[{{ "icon":"audio-headphones-symbolic", "serial": "{product_id}", "model": "{product}", "percentage": "" }}]')
else:
    print(f'[{{ "percentage": "-1" }}]')
