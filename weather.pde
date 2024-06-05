import java.util.Date;

float appWidth, appHeight;
JSONObject selectedCity;
JSONArray cityList;
JSONArray currentForecast;
PFont mainFont;
int edmontonId = 5946768;
int torontoId = 6167865;
int nycId = 5128581;
int page = 0; //Page 0 is weather/forecast, 1 is search

void loadImages()
{
  conditionImage = loadImage("https://openweathermap.org/img/wn/" + selectedCity.getJSONArray("weather").getJSONObject(0).getString("icon") + "@2x.png");
  refreshImage = loadImage("data/refresh-icon.png");
  searchImage = loadImage("data/search-icon.png");
  backImage = loadImage("data/back-icon.png");
}

void setup()
{
  size(700, 600); //width, height //700, 900
  //fullScreen(); //displayWidth, displayHeight
  //Swap Key Variables
  appWidth = width;
  appHeight = height;
  mainFont = createFont("Arial", 16, true);
  selectedCity = getPlace(edmontonId);
  cityList = loadJSONArray("data/city.list.json");

  loadImages();

  println(getWeatherCondition(selectedCity));
  currentForecast = getPlaceForecast(selectedCity.getInt("id"));
  println(currentForecast.size());
  refresh();
}

void draw()
{
  getMouseStatus();
  background(backgroundColor);
  //println(frameRate);
  if (page == 0)
  {
    drawTemp();
    drawForecast();
  }
  if (page == 1)
  {
    drawSearchBar();
    drawBackButton();
  }
  drawExitButton();
}

void keyPressed()
{
  if (page == 1)
  {
    if (key == BACKSPACE && !searchQuery.isEmpty())
    {
      searchQuery = searchQuery.substring(0, searchQuery.length() - 1);
    }
    if (Character.isLetterOrDigit(key) || key == ' ')
    {
      searchQuery += key;
    }
  }
}

void mouseWheel(MouseEvent event)
{
  if (page == 1)
  {
    float amount = event.getCount();
    if (scrollPos > 0 && amount < 0) scrollPos--;
    if (scrollPos < searchResults.length - maxResults && amount > 0) scrollPos++;
  }
}
