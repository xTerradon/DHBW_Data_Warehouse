import paho.mqtt.client as mqtt

# Define the broker and topic
broker_address = "04a2c1f28d5f42bda4c7b64f116e683d.s1.eu.hivemq.cloud"
topic = "DataMgmt"

# Callback when a message is received from the broker
def on_message(client, userdata, msg):
    print(f"Received message: {msg.payload.decode()} on topic {msg.topic}")

# Create an MQTT client
client = mqtt.Client(callback_api_version=mqtt.CallbackAPIVersion.VERSION2)

# Set the message callback
client.on_message = on_message

# Connect to the broker
client.connect(broker_address, 8883, 60)

# Subscribe to the specified topic
client.subscribe(topic)

# Start the MQTT loop to handle communication
client.loop_start()

# Keep the script running to receive messages
try:
    while True:
        pass
except KeyboardInterrupt:
    # Disconnect from the broker on keyboard interrupt
    client.disconnect()
    print("Disconnected from the broker.")
s