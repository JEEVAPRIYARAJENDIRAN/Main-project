# Hardware to Cloud Integration Guide

This guide explains how to connect your physical hardware (ESP32, Arduino, Raspberry Pi, etc.) to the Smart Safety Stick application and retrieve data from any device in the world.

## 1. Cloud Deployment (Mandatory for Remote Access)
To connect hardware from anywhere, your app must be live on the internet:
1. **GitHub**: Push your code to a GitHub repository.
2. **Vercel**: Link your repo to [Vercel](https://vercel.com). It will automatically deploy and give you a URL like `https://smart-safety-stick.vercel.app`.
3. **Environment Variables**: In Vercel, set `NEXT_PUBLIC_API_URL` to your domain + `/api/sensors`.

## 2. Arduino/ESP32 Connection (The "Sender")
Your hardware sends data to the cloud using a **POST** request.

### ESP32/WiFi Code (C++)
Use this code in your Arduino IDE for ESP32:

```cpp
#include <WiFi.h>
#include <HTTPClient.h>
#include <ArduinoJson.h>

const char* ssid = "YOUR_WIFI_SSID";
const char* password = "YOUR_WIFI_PASSWORD";

// REPLACE THIS with your Vercel URL
const char* serverUrl = "https://your-project.vercel.app/api/sensors";

void setup() {
  Serial.begin(115200);
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) { delay(500); Serial.print("."); }
  Serial.println("\nWiFi Connected!");
}

void loop() {
  if (WiFi.status() == WL_CONNECTED) {
    HTTPClient http;
    http.begin(serverUrl);
    http.addHeader("Content-Type", "application/json");

    StaticJsonDocument<200> doc;
    doc["ultrasonic"]["distance"] = analogRead(34); // Example sensor pin
    doc["accelerometer"]["x"] = 0.5;
    doc["battery"]["level"] = 90;
    
    String requestBody;
    serializeJson(doc, requestBody);

    int httpResponseCode = http.POST(requestBody);
    Serial.print("Data Sent. Cloud Response: ");
    Serial.println(httpResponseCode);
    
    http.end();
  }
  delay(3000); // Send every 3 seconds
}
```

## 3. Data Retrieval (The "Receiver")
Retrieving data "from the cloud" is already handled by the Dashboard:
- **API Endpoint**: `GET https://your-project.vercel.app/api/sensors`
- **Retrieval Rate**: The web dashboard polls this endpoint every 2 seconds.
- **Persistence**: Data sent from your Arduino is saved into the database and visible in the **Event Logs** and **Sensor Analytics** graphs.

## 4. Testing with Simulator
You can test the cloud retrieval right now by running:
```bash
node scripts/simulate-device.js
```
(Modify the `API_URL` in the script to match your cloud URL).

## 5. Mobile Monitoring
Because it's a web app, you can open your Vercel URL on your **Mobile Phone**. Your stick can be in one city, and you can monitor it from another city via the cloud!
