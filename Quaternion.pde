class Quaternion {

  float w;

  float x;
  float y;
  float z;

  Quaternion() {
    identity();
  }

  void identity() {
    w = 1.0;

    x = 0.0;
    y = 0.0;
    z = 0.0;
  }

  void rotateAboutX(float theta) {
    float thetaOver2 = theta * 0.5;

    w = cos(thetaOver2);
    x = sin(thetaOver2);
    y = 0.0;
    z = 0.0;
  }

  void rotateAboutY(float theta) {
    float thetaOver2 = theta * 0.5;

    w = cos(thetaOver2);
    x = 0.0;
    y = sin(thetaOver2);
    z = 0.0;
  }

  void rotateAboutZ(float theta) {
    float thetaOver2 = theta * 0.5;
    
    w = cos(thetaOver2);
    x = 0.0;
    y = 0.0;
    z = sin(thetaOver2);
  }
  
  void rotateAboutAxis(Vector3 axis, float theta) {
    float thetaOver2 = theta * 0.5;
    float sinThetaOver2 = sin(thetaOver2);
    
    w = cos(thetaOver2);
    x = axis.x * sinThetaOver2;
    y = axis.y * sinThetaOver2;
    z = axis.z * sinThetaOver2;
  }
}

