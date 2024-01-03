float angleX = 0;
float angleY = 0;
float rotationSpeed = 0.01;
color[] colors = {
  color(255, 0, 0, 66.6),   // Red
  color(0, 255, 0, 66.6),   // Green
  color(0, 0, 255, 66.6),   // Blue
  color(255, 255, 0, 66.6), // Yellow
  color(0, 255, 255, 66.6), // Cyan
  color(255, 0, 255, 66.6)  // Magenta
};


Vertex v1,v2,v3,v4,v5,v6,v7,v8;
int k_scale = 100; 
ArrayList<Face> originalPts = new ArrayList<Face>();
ArrayList<Face> mesh = originalPts;

void setup() {
  size(600, 600, P3D);
  v1 = new Vertex(-1 * k_scale, -1 * k_scale, 1 * k_scale);
  v2 = new Vertex(1 * k_scale, -1 * k_scale, 1 * k_scale);
  v3 = new Vertex(1 * k_scale, 1 * k_scale, 1 * k_scale);
  v4 = new Vertex(-1 * k_scale, 1 * k_scale, 1 * k_scale);
  v5 = new Vertex(-1 * k_scale, -1 * k_scale, -1 * k_scale);
  v6 = new Vertex(1 * k_scale, -1 * k_scale, -1 * k_scale);
  v7 = new Vertex(1 * k_scale, 1 * k_scale, -1 * k_scale);
  v8 = new Vertex(-1 * k_scale, 1 * k_scale, -1 * k_scale);
  originalPts.add(new Face(v1, v2, v3, v4)); // Front face
  originalPts.add(new Face(v5, v6, v7, v8)); // Back face
  originalPts.add(new Face(v1, v5, v8, v4)); // Left face
  originalPts.add(new Face(v2, v6, v7, v3)); // Right face
  originalPts.add(new Face(v1, v2, v6, v5)); // Bottom face
  originalPts.add(new Face(v4, v3, v7, v8)); // Top face
  updateEdge(mesh);
}


void draw() {
  background(255);
  translate(width / 2, height / 2, 0);
  rotateX(angleX);
  rotateY(angleY);
  drawMesh();
}

void keyPressed() {
  if (key == ' ') {
    iterateCMC();
  }
}

void updateEdge(ArrayList<Face> mesh){
  for (int i = 0; i < mesh.size(); i++) {
    Face faceToUpdate = mesh.get(i);
    for (Edge e : faceToUpdate.getEdges()) {
      for (int j = i; j < mesh.size(); j++) {
        if (mesh.get(j).containEdge(e)){
          e.addFace(mesh.get(j));
        }
      }
    }
  }
}

void iterateCMC(){
  for (Face f : mesh) {
    
  }
}

void drawMesh() {
  for (int i = 0; i < mesh.size(); i++) {
    int colorIndex = i % colors.length;
    fill(colors[colorIndex]);
    Face f = mesh.get(i);
    drawFace(f);
    drawSphere(f.averageFacePoint(),10);
    for (Edge e : f.getEdges()) {
      drawCube(e.edgePoint(),10);
    }
  }
}


void drawFace(Face face) {
  beginShape();
  for (Vertex vertex : face.getVertices()) {
    vertex(vertex.x, vertex.y, vertex.z);
  }
  endShape(CLOSE);
}

void drawSphere(Vertex vect, int size){
  pushMatrix();
   translate(vect.x,vect.y,vect.z);
   sphere(size);
  popMatrix();
}

void drawCube(Vertex vect, int size){
  pushMatrix();
   translate(vect.x,vect.y,vect.z);
   box(size);
  popMatrix();
}

void mouseDragged() {
  angleX += (pmouseY - mouseY) * rotationSpeed;
  angleY -= (pmouseX - mouseX) * rotationSpeed;
}