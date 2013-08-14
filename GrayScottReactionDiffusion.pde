class GrayScottReactionDiffusion {
  float du = 0.095;
  float dv = 0.03;

  float f = 0.023;
  float k = 0.079;
  float fk = f + k;

  float neighborDist = 0.04;
  float neighborDistSq = neighborDist * neighborDist;

  int numRows;
  int numColumns;

  int numValues;

  float[] uValues;
  float[] vValues;

  float[] tmpValuesU;
  float[] tmpValuesV;

  GrayScottReactionDiffusion(int cellColumns, int cellRows) {
    numColumns = cellColumns;
    numRows = cellRows;
    
    numValues = numRows * numColumns;
    
    uValues = new float[numValues];
    vValues = new float[numValues];
    
    tmpValuesU = new float[numValues];    
    tmpValuesV = new float[numValues];
    
    initData();
  }

  private void initData() {
    for (int i = 0; i < numValues; i++) {
      uValues[i] = 1.0; //random(1.0);
      vValues[i] = 0.0; //random(1.0);

      tmpValuesU[i] = 0.0;
      tmpValuesV[i] = 0.0;
    }
  }
  
  void update(float time) {
    for (int row = 1; row < numRows - 1; row++) {
      for (int col = 1; col < numColumns - 1; col++) {
        calculateGrayScottReactionDiffusion(row * numColumns + col, time);
      }
    }

    System.arraycopy(tmpValuesU, 0, uValues, 0, uValues.length);
    System.arraycopy(tmpValuesV, 0, vValues, 0, vValues.length);
  }

  private void calculateGrayScottReactionDiffusion(int index, float time) {
    float currU = uValues[index];
    float currV = vValues[index];

    float laplacianU = laplacian(index, uValues);
    float laplacianV = laplacian(index, vValues);

    float reactionRate = currU * currV * currV;

    float duDt = du * laplacianU - reactionRate + f * (1 - currU);
    float dvDt = dv * laplacianV + reactionRate - (k) * currV;

    tmpValuesU[index] = clamp(currU + time * duDt, 0, 1);
    tmpValuesV[index] = clamp(currV + time * dvDt, 0, 1);
  }

  private float laplacian(int index, float[] values) {
    // -- 5-point stencil
    return values[index - 1] + values[index + 1] + values[index - numColumns] + values[index+numColumns] - 4 * values[index];
  }

  private float clamp(float val, float min, float max) {
    if (val < min) {
      return min;
    }

    if (val > max) {
      return max;
    }

    return val;
  }
}

