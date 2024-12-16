String convertDegreesToDirection(int degrees) {
  if (degrees >= 337 || degrees < 22) {
    return "N";
  } else if (degrees >= 22 && degrees < 67) {
    return "NE";
  } else if (degrees >= 67 && degrees < 112) {
    return "E";
  } else if (degrees >= 112 && degrees < 157) {
    return "SE";
  } else if (degrees >= 157 && degrees < 202) {
    return "S";
  } else if (degrees >= 202 && degrees < 247) {
    return "SW";
  } else if (degrees >= 247 && degrees < 292) {
    return "W";
  } else if (degrees >= 292 && degrees < 337) {
    return "NW";
  } else {
    return "Unknown"; // If degrees is invalid, return "Unknown"
  }
}
