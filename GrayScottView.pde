class GrayScottView {
  GrayScottReactionDiffusion grayScottModel;
  
  int cellWidth;
  int cellHeight;
  
  GrayScottView(GrayScottReactionDiffusion model, int cellWidth, int cellHeight) {
    grayScottModel = model;
    
    this.cellWidth = cellWidth;
    this.cellHeight = cellHeight;
  }
  
  int getClickedRow() {
    return 0;
  }
  
  int getClickedColumn() {
    return 0;
  }
  
  void update() {
  }
  
  void render() {
  }
}