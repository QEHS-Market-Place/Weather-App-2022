int mouseStatus = 0; // 0 is released, 1 is clicked once, 2 is held
boolean mouseClicked, mouseHeld = false;
boolean metric = true;

// There is probably a better way to do this
void getMouseStatus() // Puts mouse single clicked and mouse held into seperate variables so draw() can use single clicks
{
  if (mousePressed && mouseButton == 37) //Only check for left clicks
  {
    if (mouseStatus == 1) mouseStatus = 2;
    if (mouseStatus == 0) mouseStatus = 1;
  } else mouseStatus = 0;
  mouseClicked = (mouseStatus == 1);
  mouseHeld = (mouseStatus == 2);
}

String timeFromDt(long dt) // Gets timestamp from "dt" and turns the time into 12-hour
{
  Date timeStamp = new Date(dt*1000);
  String time = timeStamp.toString();
  int hours = parseInt(time.substring(time.indexOf(":") - 2, time.indexOf(":")));
  String minutes = time.substring(time.indexOf(":"), time.indexOf(":") + 3);
  boolean pm = (hours >= 12);
  if (hours >= 13) hours -= 12;
  if (hours == 0) hours += 12;
  return hours + minutes + (pm ? " PM" : " AM");
}

String dateFromDt(long dt)
{
  Date timeStamp = new Date(dt*1000);
  String time = timeStamp.toString();
  time = time.substring(0, time.indexOf(":") - 3);
  return time + " " + timeFromDt(dt) + " ";
}

JSONObject getPlace(int id)
{
  String base = "https://api.openweathermap.org/data/2.5/weather?"; 
  base += "id=" + id;
  base += "&units=" + (metric ? "metric" : "imperial");
  base += "&appid=38cd3e0e0727475a1a0749e1f563ed68";
  println(base);
  return loadJSONObject(base);
}

JSONArray getPlaceForecast(int id)
{
  String base = "https://api.openweathermap.org/data/2.5/forecast?";
  base += "id=" + id;
  base += "&units=" + (metric ? "metric" : "imperial");
  base += "&appid=38cd3e0e0727475a1a0749e1f563ed68";
  println(base);
  return loadJSONObject(base).getJSONArray("list");
}

String getPlaceName(JSONObject place)
{
  return place.getString("name");
}

String getWeatherCondition(JSONObject place)
{
  return place.getJSONArray("weather").getJSONObject(0).getString("main");
}

String getPlaceTime(JSONObject place)
{
  return timeFromDt(place.getInt("dt"));
}

float getTemp(JSONObject place)
{
  return place.getJSONObject("main").getFloat("temp");
}

void refresh()
{
  selectedCity = getPlace(selectedCity.getInt("id"));
  timeAdjust = 0;
  currentForecast = getPlaceForecast(selectedCity.getInt("id"));
  conditionImage = loadImage("https://openweathermap.org/img/wn/" + selectedCity.getJSONArray("weather").getJSONObject(0).getString("icon") + "@2x.png");
  /* Uncomment these for printing weather data
  println("Weather in", getPlaceName(selectedCity), "is", getTemp(selectedCity), "\nWeather condition is", getWeatherCondition(selectedCity), "\nImage name is", selectedCity.getJSONArray("weather").getJSONObject(0).getString("icon"));
  println(new Date(selectedCity.getLong("dt")*1000));*/
}
