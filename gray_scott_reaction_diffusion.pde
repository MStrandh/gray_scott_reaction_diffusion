import nervoussystem.obj.*;

int clickSize = 10;
float timeDelta = 1;

GrayScottReactionDiffusion grayScottModel;

GrayScottView grayScottView;

void setup() {
  frameRate(60);

  grayScottModel = new GrayScottReactionDiffusion(160, 160);

  grayScottView = new GrayScott2DView(grayScottModel);
  //grayScottView = new GrayScott3DView(grayScottModel);

  grayScottModel.update(timeDelta);
}

int randomIndexGuy = 0;
boolean isRecording = false;

void keyPressed() {
  if (key == ' ') {
    isRecording = true;
  }
}

void draw() {
  background(0);

  if (mousePressed) {
    addFluidInput(clickSize);
  }

  //for (int i = 0; i < 16; i++) {
    grayScottModel.update(timeDelta);
  //}

  if (randomIndexGuy > 60) {
    grayScottView.update();
    randomIndexGuy = 0;
  }

  if (isRecording) {
    beginRecord("nervoussystem.obj.OBJExport", "obj/filename.obj");
  }

  grayScottView.render();

  if (isRecording) {
    isRecording = false;
    endRecord();
  }

  randomIndexGuy++;
}

void addFluidInput(int size) {
  int clickedRow = grayScottView.getClickedRow();
  int clickedColumn = grayScottView.getClickedColumn();

  int minX = max(0, clickedColumn - size);
  int maxX = min(grayScottModel.numColumns, clickedColumn + size);

  int minY = max(0, clickedRow - size);
  int maxY = min(grayScottModel.numRows, clickedRow + size);

  for (int row = minY; row < maxY; row++) {
    for (int col = minX; col < maxX; col++) {
      int index = row * grayScottModel.numColumns + col;

      grayScottModel.uValues[index] = 0.5;
      grayScottModel.vValues[index] = 0.25;
    }
  }
}

