#include <Arduino.h>
#include <WiFi.h>
#include <FirebaseESP32.h>
#include <time.h>
#include <NTPClient.h>
#include <WiFiUdp.h>

#include <ESP32Time.h>

ESP32Time rtc;

#define WIFI_SSID "vivo 1718"
#define WIFI_PASSWORD "12345678"
#define FIREBASE_HOST "https://plant-2f39d-default-rtdb.firebaseio.com/"
#define FIREBASE_AUTH "SL0CT3kjZhTdtuFrbzaea6RTzlJLGWQiNBii7wBV"

WiFiUDP ntpUDP;
NTPClient timeClient(ntpUDP);

FirebaseData fbdo;

FirebaseData fbdo1;

FirebaseData fbdoforchange;

FirebaseJson json1;

FirebaseJson json_main;

FirebaseJsonData jsonObj;

int idx = -1;

String path = "/IOT";

String jsonStr = "";

int priority = (uint16_t)(ESP.getEfuseMac() >> 32);

String Path = path + "/plants/idacc_Hieu_0/pr_" + String(priority) + "/";

unsigned long sendDataPrevMillis = 0;

int float_time_counter;

FirebaseJsonArray pump_water_h;
FirebaseJsonArray pump_water_m;
int float_time;
String water_state;
int water_level;

int timeoutwifi = 0;

int soil_measure = random(38, 48);

int soilmearsu()
{
    soil_measure = random(40, 60);
    //Firebase.set(fbdo, Path + "/soil_measure", soil_measure);
}
int waterlevel()
{
}

void streamCallback(StreamData data)
{
  /*Serial.println("Stream Data1 available...");
  Serial.println("STREAM PATH: " + data.streamPath());
  Serial.println("EVENT PATH: " + data.dataPath());
  Serial.println("DATA TYPE: " + data.dataType());
  Serial.println("EVENT TYPE: " + data.eventType());
  Serial.print("VALUE: ");
  printResult(data);
  Serial.println();*/
  /*if (data.dataPath() != "/soil_measure"){
  Serial.println("Stream Data...");
  Serial.println(data.streamPath());
  Serial.println(data.dataPath());
  Serial.println(data.dataType());
  }*/
  if (Firebase.get(fbdo, Path + "/water_state"))
        {
          water_state = fbdo.stringData();
          //Serial.println("water state " + water_state);
        }
  
  if (Firebase.get(fbdo, Path + "pump_water_h"))
    {
      pump_water_h = fbdo.jsonArray();
      /*for (size_t i = 0; i < pump_water_h.size(); i++)
      {
        pump_water_h.get(fbdo.jsonData(), i);
        //Serial.println(fbdo.jsonData().intValue);
      }*/
    }
    if (Firebase.get(fbdo, Path + "pump_water_m"))
    {
      pump_water_m = fbdo.jsonArray();
      /*for (size_t i = 0; i < pump_water_m.size(); i++)
      {
        pump_water_m.get(fbdo.jsonData(), i);
        //Serial.println(fbdo.jsonData().intValue);
      }*/
    }

  if (data.dataPath().indexOf("/pump_water_h") != -1)
  {
    if (Firebase.get(fbdo, Path + "/pump_water_h"))
    {
      pump_water_h = fbdo.jsonArray();
      
    }
    if (Firebase.get(fbdo, Path + "/pump_water_m"))
    {
      pump_water_m = fbdo.jsonArray();
      
    }
  }
  if (data.dataPath().indexOf("/pump_water_m") != -1)
  {
    if (Firebase.get(fbdo, Path + "/pump_water_h"))
    {
      pump_water_h = fbdo.jsonArray();
      
    }
    if (Firebase.get(fbdo, Path + "/pump_water_m"))
    {
      pump_water_m = fbdo.jsonArray();
      
    }
  }
  if (data.dataPath().indexOf("/water_state")!= -1)
  {
    water_state = data.stringData();
    //Serial.println("read from database " + data.stringData());
  }
  if (data.dataPath().indexOf("/float_time") != -1)
  {
    float_time = data.intData();
    //Serial.println("read int from database " + data.intData());
  }
  if (data.dataPath().indexOf("/water_level") != -1)
  {
    water_level = data.intData();
    //Serial.println("read level from database " + data.intData());
  }
  if (data.dataPath().indexOf("/float_time_counter") != -1)
  {
    float_time_counter = data.intData();
  }
}

void streamTimeoutCallback(bool timeout)
{
  if (timeout)
  {
    Serial.println();
    Serial.println("Stream timeout, resume streaming...");
    Serial.println();
  }
}

void addnewnodeplant()
{
  FirebaseJson json;
  String nameplant = "plant_" + String((uint16_t)(ESP.getEfuseMac() >> 32));
  json.add("name", nameplant);
  json.add("id", String((uint16_t)(ESP.getEfuseMac() >> 32)));
  json.add("soil_mearsure", soil_measure);
  json.add("water_level", 0);

  json.add("water_state", "idle");
  water_state = "idle";

  FirebaseJsonArray arr_h, arr_m;
  arr_h.clear();
  arr_m.clear();
  arr_h.add(0);
  arr_m.add(0);
  json.add("pump_water_h", arr_h);
  pump_water_h = arr_h;

  json.add("pump_water_m", arr_m);
  pump_water_m = arr_m;

  json.add("float_time", 2); // 60 second
  float_time = 2;

  json.add("float_time_counter", 0);
  float_time_counter = 0;
  String dd = "a" + String(random(0, 12)) + ".png";
  json.add("avt", dd);
  json.add("des", "Some Text");
  json.add("group", "flower");
  json.add("like", 0);
  json.add("index_pump", -1);

  if (Firebase.setJSON(fbdo, Path, json, priority))
  {
    Serial.println("ADDED");
  }
  else
  {
    Serial.println("FAILED");
  }
}

void wifisetup()
{
  Serial.begin(115200);
  Serial.println();
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to Wi-Fi");
  while (WiFi.status() != WL_CONNECTED)
  {
    timeoutwifi++;
    Serial.print(".");
    delay(300);
    if (timeoutwifi >= 10) // 3 second
    {
      timeoutwifi = 0;
      WiFi.reconnect();
    }
  }
  Serial.println();
  Serial.print("Connected with IP: ");
  Serial.println(WiFi.localIP());
  Serial.println();
  WiFi.setAutoReconnect(true);
  WiFi.persistent(true);
}

void firebasesetup()
{
  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);
  Firebase.reconnectWiFi(true);

  Firebase.get(fbdo, path);
  FirebaseJson &json = fbdo.jsonObject();
  String jsonStr;
  json.toString(jsonStr, true);
  if (jsonStr != "{}")
  {
    QueryFilter query;
    query.orderBy("$priority").equalTo((uint16_t)(ESP.getEfuseMac() >> 32));
    if (Firebase.getJSON(fbdo, path + "/plants/idacc_Hieu_0/", query))
    {
      FirebaseJson &json = fbdo.jsonObject();
      String jsonStr;
      json.toString(jsonStr, true);
      if (jsonStr != "{}")
      {
        if (Firebase.get(fbdo, Path + "/water_state"))
        {
          water_state = fbdo.stringData();
          //Serial.println("water state " + water_state);
        }
        if (Firebase.get(fbdo, Path + "/pump_water_h"))
        {
          pump_water_h = fbdo.jsonArray();
          /*for (size_t i = 0; i < pump_water_h.size(); i++)
          {
            pump_water_h.get(fbdo.jsonData(), i);
            Serial.println(fbdo.jsonData().intValue);
          }*/
        }
        if (Firebase.get(fbdo, Path + "/pump_water_m"))
        {
          pump_water_m = fbdo.jsonArray();
        }
        if (Firebase.get(fbdo, Path + "/float_time"))
        {
          float_time = fbdo.intData();
        }
        if (Firebase.get(fbdo, Path + "/water_level"))
        {
          water_level = fbdo.intData();
        }
        if (Firebase.get(fbdo, Path + "/float_time_counter"))
        {
          float_time_counter = fbdo.intData();
        }
      }
      else
      {
        //addnewnodeplant();
      }
    }
  }
  else
  {
    //addnewnodeplant();
  }

  if (!Firebase.beginStream(fbdo1, Path))
  {
    Serial.println("------------------------------------");
    Serial.println("Can't begin stream connection...");
    Serial.println("REASON: " + fbdo1.errorReason());
    Serial.println("------------------------------------");
    Serial.println();
  }
  Firebase.setStreamCallback(fbdo1, streamCallback, streamTimeoutCallback, 8192);
}

void rtcntpsetup()
{
  timeClient.begin();
  timeClient.setTimeOffset(25200);
  timeClient.update();
  
  rtc.setTime(timeClient.getSeconds(), timeClient.getMinutes(), timeClient.getHours(),25,1,2021);
}

FirebaseJson jsons;

void setup()
{
  // put your setup code here, to run once:
  wifisetup();
  firebasesetup();
  rtcntpsetup();

 
  jsons.add("water_state", water_state);
  jsons.add("soil_measure", soil_measure);
  jsons.add("water_level", water_level);
  jsons.add("float_time_counter", float_time_counter);
  jsons.add("index_pump", idx);

  //Firebase.updateNode(fbdo, Path, jsons);
}

int intialtimefloat;
void loop()
{
  Serial.print(rtc.getHour());
  Serial.print(" ");
  Serial.print(rtc.getMinute());
  Serial.print(" ");
  Serial.println(rtc.getSecond());
  //Serial.print(water_state);

  soilmearsu();
  //jsons.update("soil_mearsure", soil_measure);

  if (water_state == "idle")
  {
    float_time_counter = 0;
    //Firebase.set(fbdo, Path + "/float_time_counter", float_time_counter);
    
    for (int i = 0; i < pump_water_h.size(); i++)
    {
      FirebaseJsonData temp_h;
      pump_water_h.get(temp_h, i);
      FirebaseJsonData temp_m;
      pump_water_m.get(temp_m, i);
      if ((temp_h.intValue ==  rtc.getHour()) && (temp_m.intValue ==  rtc.getMinute()))
      {
        if (water_state == "idle")
        {
          water_state = "pump";
          idx = i;
          
          /*jsons.set("index_pump", idx);
          jsons.set("water_state", water_state);
          Firebase.updateNode(fbdo, Path, jsons)*/
          /*if(Firebase.set(fbdo, Path + "/water_state", water_state));
            Firebase.set(fbdo, Path + "/index_pump", i);*/
        }
      }
    }
  }
  if (water_state == "pump")
  {
    water_level += 2;

    //Firebase.set(fbdo, Path + "/water_level", water_level);

    if (water_level == 100)
    {
      intialtimefloat = rtc.getMinute();
      float_time_counter = 0;
      //Firebase.set(fbdo, Path + "/float_time_counter", float_time_counter);

      water_state = "float";
      //Firebase.set(fbdo, Path + "/water_state", water_state);
      
      //Firebase.set(fbdo, Path + "/index_pump", -1);

      idx = -1;
    }
  }
  if (water_state == "float")
  {
    if (rtc.getMinute() == intialtimefloat + (float_time)){
      water_state = "release";
      float_time_counter =0;
    }
    else 
      float_time_counter += 1;
    /*//Firebase.set(fbdo, Path + "/float_time_counter", float_time_counter);

    if ((float_time)*60 <= float_time_counter)
    {
      water_state = "release";
      //Firebase.set(fbdo, Path + "/water_state", water_state);
      float_time_counter =0;
      //Firebase.set(fbdo, Path + "/float_time_counter", float_time_counter);
    }*/
  }
  if (water_state == "release")
  {
    water_level -= random(1, 2);

    //Firebase.set(fbdo, Path + "/water_level", water_level);

    if (water_level == 0)
    {
      float_time_counter = 0;
      //Firebase.set(fbdo, Path + "/float_time_counter", float_time_counter);

      water_state = "idle";
      //Firebase.set(fbdo, Path + "/water_state", water_state);
    }
  }

  //FirebaseJson json;
  jsons.set("water_state", water_state);
  jsons.set("soil_measure", soil_measure);
  jsons.set("water_level", water_level);
  jsons.set("float_time_counter", float_time_counter);
  jsons.set("index_pump", idx);
  
  if(Firebase.updateNode(fbdo, Path, jsons)){
    //fbdo.stopWiFiClient();
    //ESP.getFreeHeap();
  }
  /*if (Firebase.updateNode(fbdo, Path, jsons)) {

  Serial.println(fbdo.dataPath());

  Serial.println(fbdo.dataType());

  Serial.println(fbdo.jsonString()); 

} */
  

  delay(1000);
}
