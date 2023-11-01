
import json
import glob
import csv
import os
from datetime import datetime

# Define the pattern to match the file names
file_pattern = "PT1H (*).json"

# Specify the CSV file path
csv_file_path = './XX-VM-RG_XX-NSG.csv'

# Specify the field names for the CSV
fieldnames = ['server', 'time', 'rule', 'src_ip', 'dst_ip',
              'src_port', 'dst_port', 'protocol', 'direction', 'action']

# Create the CSV file and write the header if it doesn't exist
if not os.path.exists(csv_file_path):
    with open(csv_file_path, 'w', newline='') as csvfile:
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
        writer.writeheader()

# Iterate over the matched files
for file_path in glob.glob(file_pattern):
    # Read the JSON data from the file
    with open(file_path) as file:
        json_data = file.read()

    # Parse the JSON
    data = json.loads(json_data)

    # Access the 'records' array
    records = data['records']

    for record in records:
        time = record['time']
        macAddress = record['macAddress']
        flows = record['properties']['flows']
        for flow in flows:
            rule_name = flow['rule']
            flows2 = flow['flows']

            # List to store unique IP combinations with times
            unique_ip_combinations = {}

            # Open the CSV file in append mode
            with open(csv_file_path, 'a', newline='') as csvfile:
                writer = csv.DictWriter(csvfile, fieldnames=fieldnames)

                # Iterate over the flows and flow tuples
                for flow2 in flows2:
                    flow_tuples = flow2['flowTuples']
                    for flowtuple in flow_tuples:
                        tuple_values = flowtuple.split(',')
                        src_ip = tuple_values[1]
                        dst_ip = tuple_values[2]
                        src_port = tuple_values[3]
                        dst_port = tuple_values[4]
                        time_str = datetime.utcfromtimestamp(
                            int(tuple_values[0])).strftime('%Y-%m-%dT%H:%M:%S.%fZ')

                        ip_combination = (src_ip, dst_ip, dst_port)

                        # Check if the IP combination is already encountered
                        if ip_combination in unique_ip_combinations:
                            # Check if the current timestamp is greater than the stored timestamp for the IP combination
                            if time_str > unique_ip_combinations[ip_combination]:
                                # If the current timestamp is greater, update the value in the dictionary
                                unique_ip_combinations[ip_combination] = time_str
                        else:
                            # If the IP combination is encountered for the first time, add it to the dictionary
                            unique_ip_combinations[ip_combination] = time_str

                        protocol = tuple_values[5]
                        direction = tuple_values[6]
                        action = tuple_values[7]
                        logrow_dict = {
                            'server': 'X-VM-RG_XX-NSG',
                            'time': time,
                            'rule': rule_name,
                            'src_ip': src_ip,
                            'dst_ip': dst_ip,
                            'src_port': src_port,
                            'dst_port': dst_port,
                            'protocol': protocol,
                            'direction': direction,
                            'action': action
                        }

                        # Write the logrow_dict as a row in the CSV
                        writer.writerow(logrow_dict)

# Add a pause at the end of the script
print('done')
input()
