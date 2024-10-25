import re
import subprocess
import os


def parse_configuration_file(file_path):
    with open(file_path, 'r') as file:
        content = file.read()

    # Extract topic name, partition count, replication factor, and configurations
    match = re.search(r'Topic:\s(\S+)\s+PartitionCount:\s(\d+)\s+ReplicationFactor:\s(\d+)\s+Configs:\s(.+)', content)
    if match:
        topic_name = match.group(1)
        partition_count = match.group(2)
        replication_factor = match.group(3)
        configs = match.group(4).split(',')

        return topic_name, partition_count, replication_factor, configs
    else:
        raise ValueError("Configuration file format is incorrect")


def create_topic(bootstrap_server, topic_name, partition_count, replication_factor, configs):
    command = [
        'kafka-topics.sh',
        '--create',
        '--bootstrap-server', bootstrap_server,
        '--replication-factor', replication_factor,
        '--partitions', partition_count,
        '--topic', topic_name
    ]

    for config in configs:
        command.extend(['--config', config.strip()])

    # Execute the command
    result = subprocess.run(command, capture_output=True, text=True)
    if result.returncode != 0:
        print(f"Error creating topic: {result.stderr}")
    else:
        print(f"Topic '{topic_name}' created successfully")


if __name__ == "__main__":
    file_path = 'msk_utils/default_configuration.conf'
    bootstrap_server = os.environ['BOOTSTRAP_SERVER']

    topic_name, partition_count, replication_factor, configs = parse_configuration_file(file_path)
    create_topic(bootstrap_server, topic_name, partition_count, replication_factor, configs)
