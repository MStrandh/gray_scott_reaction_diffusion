import nervoussystem.obj.*;

class RecordableView extends GrayScott3DView {

  boolean isRecording;
  String filename;
  
  RecordableView(GrayScottReactionDiffusion model, String filename) {
    super(model);
    
    this.filename = filename;
    
    this.isRecording = false;
  }
  
  void keyPressed() {
    if (key == ' ') {
      isRecording = true;
    }
  }
  
  void update() {
    super.update();
  }
  
  void render() {
    if (isRecording) {
      beginRecord("nervoussystem.obj.OBJExport", "obj/" + filename + ".obj");
    }
  
    super.render();
  
    if (isRecording) {
      isRecording = false;
      endRecord();
    }
  }
}
