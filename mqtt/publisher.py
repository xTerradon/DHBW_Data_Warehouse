import paho.mqtt.client as mqtt
import time
import numpy as np
import json

# Define the broker and topic
broker_address = "broker.hivemq.com"
topic = "DataMgmt"

# Create an MQTT client
client = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2, "piuabsdfuwaeg4wq98thqb3pfdgdfhg43gq8b9ur0vb97", clean_session=False, )
client.loop_start()

# Connect to the broker
client.connect(broker_address, 1883, 60)

message = json.dumps({
    "fin":"FEFEFEFEFEFEF6969",
    "zeit":int(time.time()),
    "geschwindigkeit":int(np.random.rand()*50)
})

# Publish a message to the topic (json)
while True:
    print("Sending Topic")
    client.publish(topic, message)
    time.sleep(5)

# Disconnect from the broker
client.disconnect()

