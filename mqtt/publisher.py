import paho.mqtt.client as mqtt
import time
import numpy as np
import json

# Define the broker and topic
broker_address = "04a2c1f28d5f42bda4c7b64f116e683d.s1.eu.hivemq.cloud"
topic = "DataMgmt"

# Callback when the client connects to the broker
def on_connect(client, userdata, flags, rc):
    print(f"Connected with result code {rc}")

# Create an MQTT client
client = mqtt.Client(callback_api_version=mqtt.CallbackAPIVersion.VERSION2)

# Set the connection callback
client.on_connect = on_connect

# Connect to the broker
client.connect(broker_address, 8883, 60)

# Publish a message to the topic (json)
message = json.dumps(json.dumps({
    "fin":"SNTU411STM9032150",
    "zeit":int(time.time()),
    "geschwindigkeit":np.random.rand()*50
}))

while True:
    print("Sending Topic")
    client.publish(topic, message)
    time.sleep(5)
# Disconnect from the broker
client.disconnect()

# Start the MQTT loop to handle communication
client.loop_start()
