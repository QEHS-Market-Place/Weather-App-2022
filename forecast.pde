int timeAdjust = 0; // Forecast returns 5 3-hour intervals

void drawTimeAdjust(float posX, float posY, float sizeX, float sizeY)
{
  if (timeAdjust > 0 && button("<", posX, posY - sizeY, sizeY, sizeY, foregroundColor, hoveredColor, floor(sizeY/3)))
  {
    timeAdjust--;
  }
  if (timeAdjust < 6 && button(">", posX + sizeX - sizeY, posY - sizeY, sizeY, sizeY, foregroundColor, hoveredColor, floor(sizeY/3)))
  {
    timeAdjust++;
  }
}

void drawForecast()
{
  float posX = appWidth/4;
  float posY = appHeight/1.9;
  float sizeX = appWidth/2;
  float sizeY = appHeight/20;
  drawTimeAdjust(posX, posY, sizeX, sizeY);
  for (int i = 0; i < 5; i++)
  {
    String forecastString = "";
    JSONObject forecastObject = currentForecast.getJSONObject(timeAdjust + i*8);
    forecastString += dateFromDt(forecastObject.getLong("dt"));
    forecastString += (int)(forecastObject.getJSONObject("main").getFloat("temp"));
    forecastString += "°" +(metric ? "C" : "F") + " ";
    forecastString += forecastObject.getJSONArray("weather").getJSONObject(0).getString("main");
    textRect(forecastString, posX, posY + (i*sizeY), sizeX, sizeY, foregroundColor, color(255, 255, 255), floor(sizeY*0.4));
  }
  /*for (int i = 0; i < 5; i++) // length 39
   {
   println(currentForecast.getJSONObject(i*8).getJSONObject("main").getFloat("temp") + " " + currentForecast.getJSONObject(i*8).getString("dt_txt") + " " + currentForecast.getJSONObject(i*8).getJSONArray("weather").getJSONObject(0).getString("main"));
   }*/
}
