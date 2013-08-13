class GrayScott3DView extends GrayScottView {

  int renderDepth = 0;
  int sphereCoords;
  int cellDepth = 30;
  
  FloatList xCoords;
  FloatList yCoords;
  FloatList zCoords;

  GrayScott3DView(GrayScottReactionDiffusion model) {
    super(model, 4, 4);

    xCoords = new FloatList();
    yCoords = new FloatList();
    zCoords = new FloatList();

    size(grayScottModel.numColumns * cellWidth, grayScottModel.numRows * cellHeight, P3D);
  }

  int getClickedRow(int posY) {
    return floor(posY / cellHeight);
  }

  int getClickedColumn(int posX) {
    return floor(posX / cellWidth);
  }
  
  int numVisible;

  void update() {
    numVisible = 0;
    
    int numRows = grayScottModel.numRows;
    int numCols = grayScottModel.numColumns;

    int originX = -((numCols * cellWidth) / 2);
    int originY = -((numRows * cellHeight) / 2);

    for (int row = 0; row < numRows; row++) {
      for (int col = 0; col < numCols; col++) {
        float currValue = grayScottModel.vValues[row * numCols + col];

        if (currValue > 0.3) {
          xCoords.append(originX + (col * cellWidth));
          yCoords.append(originY + (row * cellHeight));
          zCoords.append(renderDepth * cellDepth);
          numVisible++;
        }
      }
    }
    
    println("Num visible: " + numVisible);

    renderDepth++;
  }

  void render() {
    float pX = 0.0;
    float pY = 0.0;
    
    camera(0, 0, 2000, 0, 0, 0, 0, 1, 0);    

    int numRows = grayScottModel.numRows;
    int numCols = grayScottModel.numColumns;

    int originX = -((numCols * cellWidth) / 2);
    int originY = -((numRows * cellHeight) / 2);

    int numValues = grayScottModel.numValues;
    int numLayers = ceil(xCoords.size() / numValues);

    noStroke();

    directionalLight(126, 126, 126, 0, 0, 1);
    ambientLight(102, 102, 102);

    for (int i = 0; i < xCoords.size(); i++) {
      pushMatrix();

      translate(xCoords.get(i), yCoords.get(i), zCoords.get(i));
      box(cellWidth, cellHeight, cellDepth);

      popMatrix();
    }
  }
}

