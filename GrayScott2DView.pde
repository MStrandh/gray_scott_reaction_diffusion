class GrayScott2DView extends GrayScottView {

  GrayScott2DView(GrayScottReactionDiffusion model) {
    super(model, 1, 1);
    
    size(grayScottModel.numColumns * cellWidth, grayScottModel.numRows * cellHeight, P2D);
  }
  
  int getClickedRow(int posY) {
    return floor(posY / grayScottView.cellHeight);
  }
  
  int getClickedColumn(int posX) {
    return floor(posX / grayScottView.cellWidth);
  }
  
  void render() {
    loadPixels();
    
    int numValues = grayScottModel.numValues;

    for (int i = 0; i < numValues; i++) {
      float uVal = grayScottModel.uValues[i];
      float vVal = grayScottModel.vValues[i];

      int uCol = 255 - (int)(min(255, uVal * 768));
      int vCol = 255 - (int)(min(255, vVal * 768));
      int outputColor = vCol << 16 | vCol << 8 | vCol | 0xff000000;

      if(vVal > 0.2) {
        pixels[i] = outputColor;
      }
    }

    updatePixels();
  }
}

