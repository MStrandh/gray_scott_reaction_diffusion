class ArcBallCamera {
  float currentAngleX = 0;
  float currentAngleY = 0;
  
  float cameraDist = 750;
  
  Quaternion guy;
  
  ArcBallCamera() {
    guy = new Quaternion();
  }
  
  void update() {
    currentAngleX = -1 + (((float)mouseX) / width) * 2;
    //currentAngleX *= radians(360);
    
    currentAngleY = -1 + (((float)mouseY) / height) * 2;
    currentAngleY *= radians(360);
    
    println(currentAngleX);
    
    camera(cameraDist * cos(currentAngleX), 0, cameraDist, 0, 0, 0, 0, 1, 0);
  }
}
