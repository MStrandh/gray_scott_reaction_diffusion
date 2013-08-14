import nervoussystem.obj.*;

int clickSize = 3;
float timeDelta = 1;

PImage testImage;

GrayScottReactionDiffusion grayScottModel;
GrayScottView grayScottView;

void setup() {
  frameRate(60);

  //testImage = loadImage("images/test_image.png");
  testImage = loadImage("images/logo.png");

  grayScottModel = new GrayScottReactionDiffusion(testImage.width, testImage.height);

  //grayScottView = new GrayScott2DView(grayScottModel);
  grayScottView = new GrayScott3DView(grayScottModel);

  initializePixelValues();
}

int randomIndexGuy = 0;
boolean isRecording = false;

void keyPressed() {
  if (key == ' ') {
    isRecording = true;
    //updateAndRender();
  }
}

void initializePixelValues() {
  int pixelValue = 0;

  for (int i = 0; i < testImage.pixels.length; i++) {
    pixelValue = testImage.pixels[i] & 0xFF;

    if (pixelValue == 0) {
      int row = floor(i / grayScottModel.numColumns);
      int col = floor(i % grayScottModel.numColumns);

      grayScottModel.uValues[i] = 0.0;
      grayScottModel.vValues[i] = 1.0;
    }
  }
}

int levelCount = 0;
boolean updatingReactionDiffusion = true;

void draw() {
  updateAndRender();
}

void updateAndRender() {
  background(255);

  if (mousePressed) {
    addFluidInput(clickSize);
  }

  if (updatingReactionDiffusion) {
    update();
  }

  render();

  randomIndexGuy++;
}

void update() {
  if (updatingReactionDiffusion) {
    for (int i = 0; i < 8; i++) {
      grayScottModel.update(timeDelta);
    }

    if (randomIndexGuy > 10) {
      if(randomIndexGuy == 0) {
        if(levelCount >= 2) {
          grayScottView.update();
        }
      } else {
        grayScottView.update();
      }
      
      levelCount++;

      randomIndexGuy = 0;
    }
  }

  if (levelCount > 20) {
    println("DONE");
    updatingReactionDiffusion = false;
  }
}

void render() {
  if (isRecording) {
    beginRecord("nervoussystem.obj.OBJExport", "obj/filename.obj");
  }

  grayScottView.render();

  if (isRecording) {
    isRecording = false;
    endRecord();
  }
}

void addFluidInput(int size) {
  int clickedRow = grayScottView.getClickedRow(mouseY);
  int clickedColumn = grayScottView.getClickedColumn(mouseX);

  addFluidAt(size, clickedColumn, clickedRow);
}

void addFluidAt(int size, int x, int y) {
  int minX = max(0, x - size);
  int maxX = min(grayScottModel.numColumns, x + size);

  int minY = max(0, y - size);
  int maxY = min(grayScottModel.numRows, y + size);

  for (int row = minY; row < maxY; row++) {
    for (int col = minX; col < maxX; col++) {
      int index = row * grayScottModel.numColumns + col;

      grayScottModel.uValues[index] = 0.5;
      grayScottModel.vValues[index] = 0.25;
    }
  }
}

