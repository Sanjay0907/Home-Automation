#if defined(ESP32)
#include <WiFi.h>
#include <FirebaseESP32.h>
#elif defined(ESP8266)
#include <ESP8266WiFi.h>
#include <FirebaseESP8266.h>
#endif
#include <DHT.h>

//Provide the token generation process info.
#include <addons/TokenHelper.h>

//Provide the RTDB payload printing info and other helper functions.
#include <addons/RTDBHelper.h>

#define DHTPIN D6


// Digital pin connected to the DHT sensor
#define DHTTYPE DHT11   // DHT 11

/* 1. Define the WiFi credentials */

//IoT WiFi Credentials
#define WIFI_SSID "WIFI SSID"
#define WIFI_PASSWORD "WIFI PASSWORD"

//For the following credentials, see examples/Authentications/SignInAsUser/EmailPassword/EmailPassword.ino

/* 2. Define the API Key */
#define API_KEY "YOUR API KEY"

/* 3. Define the RTDB URL */
#define DATABASE_URL "YOUR REALTIME DATABASW URL" //<databaseName>.firebaseio.com or <databaseName>.<region>.firebasedatabase.app

/* 4. Define the user Email and password that alreadey registerd or added in your project */
#define USER_EMAIL "EMAIL ID"
#define USER_PASSWORD "PASSWORD"

String switch_1_Status;
String switch_2_Status;
String switch_3_Status;
String switch_4_Status;

bool wifi_connection_status = false ;

//Define Firebase Data object
FirebaseData fbdo;

FirebaseAuth auth;
FirebaseConfig config;

unsigned long sendDataPrevMillis = 0;

DHT dht(DHTPIN, DHTTYPE);

void setup()
{

  Serial.begin(115200);
  pinMode(D1, OUTPUT);
  pinMode(D2, OUTPUT);
  pinMode(D3, OUTPUT);
  pinMode(D4, OUTPUT);
  dht.begin();
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to Wi-Fi");
  while (WiFi.status() != WL_CONNECTED)
  {
    Serial.print(".");
    delay(300);
  }
  wifi_connection_status = false;
  Serial.println();
  Serial.print("Connected with IP: ");
  Serial.println(WiFi.localIP());
  Serial.println();

  Serial.printf("Firebase Client v%s\n\n", FIREBASE_CLIENT_VERSION);

  /* Assign the api key (required) */
  config.api_key = API_KEY;

  /* Assign the user sign in credentials */
  auth.user.email = USER_EMAIL;
  auth.user.password = USER_PASSWORD;

  /* Assign the RTDB URL (required) */
  config.database_url = DATABASE_URL;

  /* Assign the callback function for the long running token generation task */
  config.token_status_callback = tokenStatusCallback; //see addons/TokenHelper.h

  //Or use legacy authenticate method
  //config.database_url = DATABASE_URL;
  //config.signer.tokens.legacy_token = "<database secret>";

  //To connect without auth in Test Mode, see Authentications/TestMode/TestMode.ino

  //////////////////////////////////////////////////////////////////////////////////////////////
  //Please make sure the device free Heap is not lower than 80 k for ESP32 and 10 k for ESP8266,
  //otherwise the SSL connection will fail.
  //////////////////////////////////////////////////////////////////////////////////////////////

  Firebase.begin(&config, &auth);

  //Comment or pass false value when WiFi reconnection will control by your code or third party library
  Firebase.reconnectWiFi(true);

  Firebase.setDoubleDigits(5);
}

void loop()
{
  float h = dht.readHumidity();
  float t = dht.readTemperature();

  switch_1_Status=Firebase.getString(fbdo, F("/Switch Status/Switch 1")) ? String(fbdo.to<String>()).c_str() : fbdo.errorReason().c_str();
  switch_2_Status=Firebase.getString(fbdo, F("/Switch Status/Switch 2")) ? String(fbdo.to<String>()).c_str() : fbdo.errorReason().c_str();
  switch_3_Status=Firebase.getString(fbdo, F("/Switch Status/Switch 3")) ? String(fbdo.to<String>()).c_str() : fbdo.errorReason().c_str();
  switch_4_Status=Firebase.getString(fbdo, F("/Switch Status/Switch 4")) ? String(fbdo.to<String>()).c_str() : fbdo.errorReason().c_str();
  Serial.println();
// Serial.println(switch_1_Status,switch_2_Status,switch_3_Status,switch_4_Status);

// Switch 1
 if(switch_1_Status=="true"){

    Serial.println("Switch 1 : HIGH");
   digitalWrite(D1,LOW);
 //be careful the pin number on nodeMcu and arduino Ide are not the same eg. The used pin 5 in nodemcu is pin D1 not D5.
 }
 else if(switch_1_Status=="false"){
  Serial.println("Switch 1 : LOW");
  digitalWrite(D1,HIGH);
 }
 else {
  Serial.println("Error");
  }

 // Switch 2
 if(switch_2_Status=="true"){
    Serial.println("Switch 2 : HIGH");
  digitalWrite(D2,LOW);

 //be careful the pin number on nodeMcu and arduino Ide are not the same eg. The used pin 5 in nodemcu is pin D1 not D5.
 }
 else if(switch_2_Status=="false"){
  Serial.println("Switch 2 : LOW");
  digitalWrite(D2,HIGH);
   
 }
 else {
  Serial.println("Error");
  }

  // Switch 3
 if(switch_3_Status=="true"){
    Serial.println("Switch 3 : HIGH");
   digitalWrite(D3,LOW);

 //be careful the pin number on nodeMcu and arduino Ide are not the same eg. The used pin 5 in nodemcu is pin D1 not D5.
 }
 else if(switch_3_Status=="false"){
  Serial.println("Switch 3 : LOW");
  digitalWrite(D3,HIGH);
 }
 else {
  Serial.println("Error");
  }

  // Switch 4
 if(switch_4_Status=="true"){
    Serial.println("Switch 4 : HIGH");
  digitalWrite(D4,LOW);

 //be careful the pin number on nodeMcu and arduino Ide are not the same eg. The used pin 5 in nodemcu is pin D1 not D5.
 }
 else if(switch_4_Status=="false"){
  Serial.println("Switch 4 : LOW");
  digitalWrite(D4,HIGH);
   
 }
 else {
  Serial.println("Error");
  }

  if (Firebase.ready() && (millis() - sendDataPrevMillis > 15000 || sendDataPrevMillis == 0))
  {
    
    
    sendDataPrevMillis = millis();
    Serial.printf("Switch 1 Status :- %s\n", Firebase.getString(fbdo, F("/Switch Status/Switch 1")) ? String(fbdo.to<String>()).c_str() : fbdo.errorReason().c_str());
    Serial.printf("Switch 2 Status :- %s\n", Firebase.getString(fbdo, F("/Switch Status/Switch 2")) ? String(fbdo.to<String>()).c_str() : fbdo.errorReason().c_str());
    Serial.printf("Switch 3 Status :- %s\n", Firebase.getString(fbdo, F("/Switch Status/Switch 3")) ? String(fbdo.to<String>()).c_str() : fbdo.errorReason().c_str());
    Serial.printf("Switch 4 Status :- %s\n", Firebase.getString(fbdo, F("/Switch Status/Switch 4")) ? String(fbdo.to<String>()).c_str() : fbdo.errorReason().c_str());
    Serial.println();
    Serial.printf("Set Temperature... %s\n", Firebase.setFloat(fbdo, F("/Data/temperature"), t) ? "ok" : fbdo.errorReason().c_str());
    Serial.printf("Get Temperature... %s\n", Firebase.getFloat(fbdo, F("/Data/temperature")) ? String(fbdo.to<float>()).c_str() : fbdo.errorReason().c_str());
    Serial.printf("Set Humidity... %s\n", Firebase.setDouble(fbdo, F("/Data/humidity"), h) ? "ok" : fbdo.errorReason().c_str());
    Serial.printf("Get Humidity... %s\n", Firebase.getDouble(fbdo, F("/Data/humidity")) ? String(fbdo.to<double>()).c_str() : fbdo.errorReason().c_str());
    Serial.println();
    Serial.println();

  }
}
