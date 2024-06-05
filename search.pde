String searchQuery = "";
JSONObject[] searchResults = {};
PImage backImage;
int scrollPos = 0;
int searchIndex = 0;
int maxResults = 0; // Global resultsToShow for scrolling
float spaceAvailableX, spaceAvailableY, resultsStartX, resultsStartY = 0.0;

void drawSearchBar()
{
  float sizeX = appWidth/2;
  float sizeY = appHeight/20;
  float posX = (appWidth/2) - sizeX/2;
  float posY = (appHeight/8);
  resultsStartX = posX;
  resultsStartY = (posY+sizeY); // Where the search results should start
  spaceAvailableX = sizeX + sizeY;
  spaceAvailableY = (appHeight - resultsStartY) - sizeY*0.2; // The height of the results box so they don't go off screen

  drawRect(posX, posY, sizeX, sizeY, color(255, 255, 255));
  int textsz = floor(sizeY/2);
  while ((textWidth(searchQuery) + sizeY*1.5) >= sizeX) textSize(textsz--); // Search box text scaling

  drawText(searchQuery, (appWidth/2) - sizeX*0.45, (appHeight/8) + sizeY*0.65, color(0, 0, 0), textsz);
  if (button("", posX + sizeX, posY, sizeY, sizeY, color(100, 100, 255), color(150, 150, 255), 1) || (keyPressed && key == ENTER))
  {
    if (searchQuery.length() > 0 && !searchQuery.equals(" "))
    {
      scrollPos = 0; //Reset the scroll
      searchIndex = 0;
      searchResults = getQuery();
    }
  }
  drawResults();
  searchImage.resize(floor(sizeY*0.9), floor(sizeY*0.9));
  image(searchImage, (posX + sizeX) + sizeY*0.05, posY + sizeY*0.06);
}

void drawBackButton()
{
  float size = appHeight/15;
  backImage.resize(floor(size), floor(size));
  if (button("", 0, 0, size, size, color(100, 255, 100), color(150, 255, 150), 1))
  {
    refresh();
    page = 0;
  }
  image(backImage, 0, 0);
}

void drawScrollButtons(int limit, float posX, float posY, float sizeX, float sizeY)
{
  if (scrollPos > 0 && button("^", posX + sizeX + sizeY, posY, sizeY, sizeY* 2, foregroundColor, hoveredColor, 16))
  {
    scrollPos--;
    println(scrollPos + " " + searchIndex + " " + searchResults.length);
  }
  if (scrollPos < limit && button("V", posX + sizeX + sizeY, posY + (sizeY*2), sizeY, sizeY*2, foregroundColor, hoveredColor, 16))
  {
    println(scrollPos + " " + searchIndex + " " + searchResults.length);
    scrollPos++;
  }
}

void drawResults()
{
  float posX = resultsStartX;
  float posY = resultsStartY;
  float resultHeight = (spaceAvailableY/20);
  int resultsToShow = floor((spaceAvailableY)/resultHeight); // How many results can be displayed on the screen
  maxResults = resultsToShow;
  drawScrollButtons(searchResults.length - resultsToShow, posX, posY, spaceAvailableX, resultHeight);

  for (int i = 0; i < searchResults.length; i++)
  {
    searchIndex = i + scrollPos;
    if (i >= resultsToShow) continue;
    if (searchIndex < searchResults.length)
    {
      String placeName = "";
      placeName += searchResults[searchIndex].getString("name") + ", ";
      if (!searchResults[searchIndex].getString("state").isEmpty()) placeName += searchResults[searchIndex].getString("state") + ", ";
      placeName += searchResults[searchIndex].getString("country");

      if (button(placeName, posX, posY + (i*resultHeight), spaceAvailableX, resultHeight, foregroundColor, hoveredColor, floor(resultHeight*0.7)))
      {
        selectedCity = getPlace(searchResults[searchIndex].getInt("id"));
        currentForecast = getPlaceForecast(searchResults[searchIndex].getInt("id"));
        refresh();
        page = 0;
      }
    }
  }
}

JSONObject[] getQuery()
{
  JSONObject[] results = {};
  for (int i = 0; i < cityList.size(); i++)
  {
    if (!cityList.getJSONObject(i).getString("name").toUpperCase().contains(searchQuery.toUpperCase())) continue; // Makes both strings upper case so city search is not case-sensitive
    results = (JSONObject[])append(results, cityList.getJSONObject(i));
  }
  return results;
}
