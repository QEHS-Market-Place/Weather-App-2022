void drawText(String label, float x, float y, color col, int sz)
{
  textAlign(LEFT);
  textFont(mainFont, sz);
  fill(col);
  text(label, x, y);
}

void drawCenterText(String label, float x, float y, color col, int sz)
{
  textAlign(CENTER, CENTER);
  textFont(mainFont, sz);
  fill(col);
  text(label, x, y);
}

void drawRect(float x, float y, float w, float h, color col)
{
  fill(col);
  rect(x, y, w, h);
}

void textRect(String label, float x, float y, float w, float h, color col, color textCol, int textsz)
{
  fill(col);
  rect(x, y, w, h);
  textSize(textsz); // Reset the text size on every textRect call
  while (textWidth(label) >= w) textSize(textsz--); // If the text is too big for the rectangle decrease the size
  drawCenterText(label, x + w/2, y + h/2, textCol, textsz);
}

boolean button(String label, float x, float y, float w, float h, color col, color hoverCol, int textsz)
{
  boolean hovering = (mouseX >= x && mouseX <= x + w && mouseY >= y && mouseY <= y + h);
  textRect(label, x, y, w, h, hovering ? hoverCol : col, color(255, 255, 255), textsz);
  if (hovering && mouseClicked)
  {
    return true;
  }
  return false;
}
