color backgroundColor = color(25, 25, 25);
color foregroundColor = color(50, 50, 50);
color hoveredColor = color(75, 75, 75);
PImage conditionImage, refreshImage, searchImage;

void drawTemp()
{
  float size = appHeight*0.3;
  float posX = (appWidth*0.5) - (size*0.5);
  float posY = (appHeight*0.5) - (size*1.5); // 3/2

  //Draw the main weather rectangle
  drawRect(posX, posY, size, size, foregroundColor);
  drawCenterText((int)(getTemp(selectedCity)) + "°" + (metric ? "C" : "F"), posX + size/2, posY + size/2, color(255, 255, 255), floor(size/4));
  //Temp casted to int is more accurate to OpenWeatherMap website

  //Fixes city text width so it can fit in the temperature box
  int cityTextSize = floor(size/9);
  textSize(cityTextSize);
  while (textWidth(getPlaceName(selectedCity)) >= size) textSize(cityTextSize--);
  drawCenterText(getPlaceName(selectedCity), posX + size/2, posY + size/3, color(255, 255, 255), cityTextSize);
  
  drawCenterText(getWeatherCondition(selectedCity), posX + size/2, posY + size/1.4, color(255, 255, 255), floor(size/9));
  drawCenterText(getPlaceTime(selectedCity), posX + size/2, posY + size/1.2, color(255, 255, 255), floor(size/11));
  conditionImage.resize(floor(size/2.7), floor(size/2.7));
  image(conditionImage, posX + size/2 - (conditionImage.width/2), posY);

  //Draw the elements that are attached to the main temperature box
  drawRefreshButton(size, posX, posY);
  drawCityTabs(size, posX, posY);
  drawUnitButton(size, posX, posY);
  drawSearchButton(size, posX, posY);
}

void drawRefreshButton(float size, float posX, float posY)
{
  if (button("", posX, (posY + size) - size*0.20, size*0.20, size*0.20, color(50, 255, 50), color(100, 255, 100), 1))
  {
    refresh();
  }
  refreshImage.resize(floor(size*0.14), floor(size*0.14));
  image(refreshImage, posX + size*0.03, (posY + size) - size*0.16);
}

void drawCityTabs(float size, float posX, float posY)
{
  if (button("Edmonton", posX, posY + size, size/3, size*0.15, foregroundColor, hoveredColor, floor(size/20)))
  {
    selectedCity = getPlace(edmontonId);
    currentForecast = getPlaceForecast(edmontonId);
    refresh();
  }
  if (button("Toronto", posX + (size/3), posY + size, size/3, size*0.15, foregroundColor, hoveredColor, floor(size/20)))
  {
    selectedCity = getPlace(torontoId);
    currentForecast = getPlaceForecast(torontoId);
    refresh();
  }
  if (button("New York City", posX + (size/3)*2, posY + size, size/3, size*0.15, foregroundColor, hoveredColor, floor(size/20)))
  {
    selectedCity = getPlace(nycId);
    currentForecast = getPlaceForecast(nycId);
    refresh();
  }
}

void drawUnitButton(float size, float posX, float posY)
{
  if (button(metric ? "F" : "C", (posX + size) - size*0.20, (posY + size) - size*0.20, size*0.20, size*0.20, color(150, 150, 150), color(190, 190, 190), floor(size/10)))
  {
    metric = !metric;
    refresh();
  }
}

void drawSearchButton(float size, float posX, float posY)
{
  float newY = (posY + size) + size*0.15;
  if (button("Search for Place", posX, newY, size, size/7, color(100, 100, 255), color(150, 150, 255), floor(size/15)))
  {
    scrollPos = 0; //Reset the scroll
    searchIndex = 0;
    searchQuery = ""; // Reset the search box
    searchResults = new JSONObject[0]; // Clears the results by replacing searchResults with an empty array
    /*while (searchResults.length > 0)
     {
     searchResults = (JSONObject[])shorten(searchResults); // Remove every search result in the array until it is empty
     }*/
    page = 1;
  }
}

void drawExitButton()
{
  float size = appHeight/15;
  if (button("X", appWidth - size, 0, size, size, color(255, 0, 0), color(255, 100, 100), floor(size/3)))
  {
    exit();
  }
}
