import paho.mqtt.client as mqtt
import time
from dotenv import load_dotenv
import psycopg2
import os

load_dotenv()

conn = psycopg2.connect(dbname="postgres", user="postgres", password=os.environ["POSTGRES_PASSWORD"])
cur = conn.cursor()

# create table
cur.execute("""    
    create schema staging;
    
    create table staging.messung (
        messung_id serial, 
        payload JSON not null, 
        empfangen TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP, 
        CONSTRAINT pk_messung PRIMARY KEY(messung_id)
    );
""")
conn.commit()

# Define the broker and topic
broker_address = "broker.hivemq.com"
topic = "DataMgmt"

# Callback when a message is received from the broker
def on_message(client, userdata, msg):
    print(f"Received message: {msg.payload.decode()} on topic {msg.topic}")
    cur.execute("insert into staging.messung (payload) values (%s)", (msg.payload.decode(),))
    conn.commit()


# Create an MQTT client
client = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2, "piuabsdfuwaeg4wq98thqb3p4bg43gq8b9ur0vb97", clean_session=False, )

# Set the message callback
client.on_message = on_message

# Connect to the broker
client.connect(broker_address, 1883, 60)

# Subscribe to the specified topic
client.subscribe(topic, qos=1)

# Start the MQTT loop to handle communication
client.loop_start()

# Keep the script running to receive messages
try:
    while True:
        print("Receiving messages...")
        time.sleep(1)
except KeyboardInterrupt:
    # Disconnect from the broker on keyboard interrupt
    client.disconnect()
    print("Disconnected from the broker.")
