float du = 0.095;
float dv = 0.03;

float f = 0.023;
float k = 0.074;
float fk = f + k;

float timeDelta = 1;

float neighborDist = 0.04;
float neighborDistSq = neighborDist * neighborDist;

int numRows = 256;
int numColumns = 256;

int cellWidth = 1;
int cellHeight = 1;

int clickSize = 10;

int offsetX = cellWidth / 2;
int offsetY = cellHeight / 2;

int numValues = numRows * numColumns;

float[] uValues = new float[numValues];
float[] vValues = new float[numValues];

float[] tmpValuesU = new float[numValues];
float[] tmpValuesV = new float[numValues];

void setup() {
  size(numColumns * cellWidth, numRows * cellHeight);

  initData();
  drawGrid();
}

void initData() {
  for(int i = 0; i < numValues; i++) {
    uValues[i] = 1.0; //random(1.0);
    vValues[i] = 0.0; //random(1.0);
    
    tmpValuesU[i] = 0.0;
    tmpValuesV[i] = 0.0;
  }
}

void draw() {
  background(0);
  
  if(mousePressed) {
    addFluidInput(clickSize);
  }

  //for(int i = 0; i < 16; i++) {
    solve(timeDelta);
  //}
  
  drawGrid(); 
}

void addFluidInput(int size) {
  int clickedRow = floor(mouseY / cellHeight);
  int clickedColumn = floor(mouseX / cellWidth);
  
  int minX = max(0, clickedColumn - size);
  int maxX = min(numColumns, clickedColumn + size);
  
  int minY = max(0, clickedRow - size);
  int maxY = min(numRows, clickedRow + size);
  
  for(int row = minY; row < maxY; row++) {
    for(int col = minX; col < maxX; col++) {
      int index = row * numColumns + col;
  
      uValues[index] = 0.5;
      vValues[index] = 0.25;
    }
  }
}

void drawGrid() {
  loadPixels();
  
  for(int i = 0; i < numValues; i++) {
    float uVal = uValues[i];
    float vVal = vValues[i];
    
    int uCol = 255 - (int)(min(255, uVal * 768));
    int vCol = 255 - (int)(min(255, vVal * 768));
    int outputColor = vCol << 16 | vCol << 8 | vCol | 0xff000000;
    
    pixels[i] = outputColor;
  }
  
  updatePixels();
}

void solve(float time) {
  for(int row = 1; row < numRows - 1; row++) {
    for(int col = 1; col < numColumns - 1; col++) {
      calculateGrayScottReactionDiffusion(row * numColumns + col, time);
    }
  }

  System.arraycopy(tmpValuesU, 0, uValues, 0, uValues.length);
  System.arraycopy(tmpValuesV, 0, vValues, 0, vValues.length);
}

void calculateGrayScottReactionDiffusion(int index, float time) {
  float currU = uValues[index];
  float currV = vValues[index];
  
  float laplacianU = laplacian(index, uValues);
  float laplacianV = laplacian(index, vValues);
  
  float reactionRate = currU * currV * currV;
  
  float duDt = du * laplacianU - reactionRate + f * (1 - currU);
  float dvDt = dv * laplacianV + reactionRate - ( k) * currV;
  
  tmpValuesU[index] = clamp(currU + time * duDt, 0, 1);
  tmpValuesV[index] = clamp(currV + time * dvDt, 0, 1);
}

float laplacian(int index, float[] values) {
  // -- 5-point stencil
  return values[index - 1] + values[index + 1] + values[index - numColumns] + values[index+numColumns] - 4 * values[index];
}

float clamp(float val, float min, float max) {
  if(val < min) {
    return min;
  }
  
  if(val > max) {
    return max;
  }
  
  return val;
}
