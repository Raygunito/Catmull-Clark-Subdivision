import controlP5.*;
// Utility
float angleX = 0;
float angleY = 0;
float rotationSpeed = 0.01;
color[] colors = {
  color(255, 0, 0, 66.6), // Red
  color(0, 255, 0, 66.6), // Green
  color(0, 0, 255, 66.6), // Blue
  color(255, 255, 0, 66.6), // Yellow
  color(0, 255, 255, 66.6), // Cyan
  color(255, 0, 255, 66.6)  // Magenta
};
ControlP5 cp5;
Slider slider;
Slider sliderSize;
RadioButton formRadio;
int sliderValue;

String[] formOptions = {"Cube","Pyramid","Tetrahedron","Octahedron","Icosahedron"};
String selectedForm;
// Can be separated into Mesh class
int k_scale;
ArrayList<Face> originalPts;
ArrayList<Face> mesh;

void setup() {
  size(1280, 720, P3D);
  originalPts = getCubeFace();
  selectedForm = "Cube";
  k_scale = 100;
  mesh = originalPts;
  cp5 = new ControlP5(this);
  cp5.setFont(createFont("Arial", 14));
  slider = cp5.addSlider("sliderValue")
                 .setPosition(10, height - 50)
                 .setWidth(300)
                 .setHeight(40)
                 .setColorLabel(color(120))
                 .setRange(0, 4)
                 .setValue(0)
                 .setNumberOfTickMarks(5)
                 .snapToTickMarks(true)
                 .plugTo(this,"sliderEvent")
                 .setCaptionLabel("Number of iteration");
  sliderSize = cp5.addSlider("sliderSizeValue")
                 .setPosition(width - 300 - 50, height - 50)
                 .setWidth(300)
                 .setHeight(40)
                 .setColorLabel(color(120))
                 .setRange(25, 200)
                 .setValue(100)
                 .plugTo(this,"sliderSizeEvent")
                 .setCaptionLabel("Size");
  formRadio = cp5.addRadioButton("formRadio")
                  .setPosition(10, 10)
                  .setSize(40, 40)
                  .setColorForeground(color(120))
                  .setColorActive(color(0))
                  .setColorLabel(color(120))
                  .setItemsPerRow(1)
                  .setSpacingColumn(50);
  formRadio.addItem("Cube", 0).setCaptionLabel("Cube");
  formRadio.addItem("Pyramid", 1).setCaptionLabel("Pyramid");
  formRadio.addItem("Tetrahedron", 2).setCaptionLabel("Tetrahedron");
  formRadio.addItem("Octahedron", 3).setCaptionLabel("Octahedron");
  formRadio.addItem("Icosahedron", 4).setCaptionLabel("Icosahedron");

  formRadio.activate(0);
}


void draw() {
  background(255);
  pushMatrix();
  translate(width / 2, height / 2, 0);
  rotateX(angleX);
  rotateY(angleY);
  drawMesh();
  popMatrix();
  slider.bringToFront();
}

void sliderEvent(int value){
  sliderValue = value;
  mesh = originalPts;
  for (int i = 0; i < value; ++i) {
    iterateCMC();
  }
}

void sliderSizeEvent(int size){
  k_scale = size;
  updateMesh();
}

void controlEvent(ControlEvent theEvent) {
  if (theEvent.isFrom(formRadio)) {
    int selectedValue = (int) theEvent.getValue();
    selectedForm = formOptions[selectedValue];
    updateMesh();
  }
}

void updateMesh() {
  switch (selectedForm) {
    case "Cube":
      originalPts = getCubeFace();
      break;
    case "Pyramid":
      originalPts = getPyramidFace();
      break;
    case "Tetrahedron":
      originalPts = getTetrahedronFace();
      break;
    case "Octahedron":
      originalPts = getOctahedronFace();
      break;
    case "Icosahedron":
      originalPts = getIcosahedronFace();
      break;
  }
  mesh = originalPts;
  sliderEvent(sliderValue);
}


/*


---Here is the full algorithm for CMC---


*/
void iterateCMC() {
  ArrayList<Face> newMesh = new ArrayList<Face>();
  for (Face f : mesh) {
    ArrayList<Face> subdividedFaces = subdivideFace(f);
    newMesh.addAll(subdividedFaces);
  }
  mesh = newMesh;
}

ArrayList<Face> subdivideFace(Face face) {
  ArrayList<Face> subdividedFaces = new ArrayList<Face>();
  // Iterate over each original vertex in the face
  for (Vertex originalVertex : face.getVertices()) {
    int cpt = 0;
    for (Face f : mesh) {
      if (f.getVertices().contains(originalVertex)) {
        cpt++;
      }
    }

    /*For each original point (P), take the average (F) of all n (recently created) face points 
    for faces touching P,and take the average (R) of all n edge midpoints for original edges touching P, 
    where each edge midpoint is the average of its two endpoint vertices (not to be confused with new edge 
    points above). (Note that from the perspective of a vertex P, the number of edges neighboring P is 
    also the number of adjacent faces, hence n)*/
    Vertex avgFacePoint = calculateAverageFacePoint(originalVertex);
    Vertex avgEdgeMidpoint = calculateAverageEdgeMidpoint(originalVertex);
    Vertex newVertex = calculateNewVertex(originalVertex, avgFacePoint, avgEdgeMidpoint, cpt);

    ArrayList<Edge> edgeList = Edge.findEdgeOfVertex(originalVertex,face.getEdges());
    Edge e1 = edgeList.get(0);
    Edge e2 = edgeList.get(1);
    Vertex v1 = e1.edgePoint(Face.findNeighbours(e1,mesh));
    Vertex v2 = e2.edgePoint(Face.findNeighbours(e2,mesh));
    subdividedFaces.add(new Face(newVertex,v1,face.averageFacePoint(),v2));
  }
  return subdividedFaces;
}

//the average (F) of all n (recently created) face points for faces touching P
Vertex calculateAverageFacePoint(Vertex originalVertex) {
  Vertex sum = new Vertex();
  int cpt = 0;
  for (Face f : mesh) {
    if (f.getVertices().contains(originalVertex)) {
      sum = Vertex.add(f.averageFacePoint(), sum);
      cpt++;
    }
  }
  if (cpt>0) {
    return Vertex.mult(sum, 1.0/(float)cpt);
  }
  println("Warning value 0 when calculating AverageFacePoint");
  return sum;
}

/*
the average (R) of all n edge midpoints for original edges touching P, 
where each edge midpoint is the average of its two endpoint vertices 
NB:this function is NOT the same as Edge.edgePoint() function careful!!!
*/
Vertex calculateAverageEdgeMidpoint(Vertex originalVertex) {
  Vertex sum = new Vertex();
  int cpt = 0;
  for (Face f : mesh) {
    for (Edge e : f.getEdges()) {
      if (e.containVertex(originalVertex)) {
        Vertex tmp = Vertex.mult(Vertex.add(e.vertex1,e.vertex2),0.5);
        sum = Vertex.add(sum,tmp);
        cpt++;
      }
    }
  }
  return Vertex.mult(sum,1.0/cpt);
}

// Apply formula : newPoint = (avgFacePoint + 2*avgEdgePoint + (n-3)*oldPoint ) / n
//where n is the number of Face (or Edge) including the oldPoint 
Vertex calculateNewVertex(Vertex originalVertex, Vertex avgFacePoint, Vertex avgEdgeMidpoint, int n) {
  Vertex finalPos = new Vertex();
  finalPos = Vertex.add(avgFacePoint, Vertex.mult(avgEdgeMidpoint, 2.0), Vertex.mult(originalVertex, (float)n-3));
  finalPos = Vertex.mult(finalPos, 1.0/(float)n);
  return finalPos;
}
/*


--END of CMC--


*/


void drawMesh() {
  for (int i = 0; i < mesh.size(); i++) {
    int colorIndex = i % colors.length;
    fill(colors[colorIndex]);
    Face f = mesh.get(i);
    drawFace(f);
    // drawSphere(f.averageFacePoint(),5);
    // for (Edge e : f.getEdges()) {
    //   drawCube(e.edgePoint(Face.findNeighbours(e,mesh)),10);
    // }
  }
}

ArrayList<Face> getCubeFace(){
  ArrayList<Face> tmp = new ArrayList<Face>();
  Vertex v1 = new Vertex(-1 * k_scale, -1 * k_scale, 1 * k_scale);
  Vertex v2 = new Vertex(1 * k_scale, -1 * k_scale, 1 * k_scale);
  Vertex v3 = new Vertex(1 * k_scale, 1 * k_scale, 1 * k_scale);
  Vertex v4 = new Vertex(-1 * k_scale, 1 * k_scale, 1 * k_scale);
  Vertex v5 = new Vertex(-1 * k_scale, -1 * k_scale, -1 * k_scale);
  Vertex v6 = new Vertex(1 * k_scale, -1 * k_scale, -1 * k_scale);
  Vertex v7 = new Vertex(1 * k_scale, 1 * k_scale, -1 * k_scale);
  Vertex v8 = new Vertex(-1 * k_scale, 1 * k_scale, -1 * k_scale);
  tmp.add(new Face(v1, v2, v3, v4)); // Front face
  tmp.add(new Face(v5, v6, v7, v8)); // Back face
  tmp.add(new Face(v1, v5, v8, v4)); // Left face
  tmp.add(new Face(v2, v6, v7, v3)); // Right face
  tmp.add(new Face(v1, v2, v6, v5)); // Bottom face
  tmp.add(new Face(v4, v3, v7, v8)); // Top face
  return tmp;
}

ArrayList<Face> getPyramidFace(){
  ArrayList<Face> tmp = new ArrayList<Face>();
  Vertex v1 = new Vertex(0, -1 * k_scale, 0);
  Vertex v2 = new Vertex(1 * k_scale, 1 * k_scale, 1 * k_scale);
  Vertex v3 = new Vertex(-1 * k_scale, 1 * k_scale, 1 * k_scale);
  Vertex v4 = new Vertex(-1 * k_scale, 1 * k_scale, -1 * k_scale);
  Vertex v5 = new Vertex(1 * k_scale, 1 * k_scale, -1 * k_scale);
  tmp.add(new Face(v1, v2, v3)); // Base triangle 1
  tmp.add(new Face(v1, v3, v4)); // Base triangle 2
  tmp.add(new Face(v1, v4, v5)); // Base triangle 3
  tmp.add(new Face(v1, v2, v5)); // Base triangle 4
  tmp.add(new Face(v2, v3, v4, v5)); // Side face
  return tmp;
}

ArrayList<Face> getTetrahedronFace(){
  ArrayList<Face> tmp = new ArrayList<Face>();
  Vertex v1 = new Vertex(1 * k_scale, -1 * k_scale, -1 * k_scale);
  Vertex v2 = new Vertex(-1 * k_scale, -1 * k_scale, 1 * k_scale);
  Vertex v3 = new Vertex(-1 * k_scale, 1 * k_scale, -1 * k_scale);
  Vertex v4 = new Vertex(1 * k_scale, 1 * k_scale, 1 * k_scale);
  tmp.add(new Face(v1, v2, v3)); // Base triangle 1
  tmp.add(new Face(v1, v3, v4)); // Base triangle 2
  tmp.add(new Face(v1, v2, v4)); // Base triangle 3
  tmp.add(new Face(v2, v3, v4)); // Side face
  return tmp;
}

ArrayList<Face> getOctahedronFace(){
  ArrayList<Face> tmp = new ArrayList<Face>();
  Vertex v1 = new Vertex(1*k_scale,0,0);
  Vertex v2 = new Vertex(0,1*k_scale,0);
  Vertex v3 = new Vertex(0,0,1*k_scale);
  Vertex v4 = new Vertex(-1*k_scale,0,0);
  Vertex v5 = new Vertex(0,-1*k_scale,0);
  Vertex v6 = new Vertex(0,0,-1*k_scale);
  tmp.add(new Face(v1, v2, v3)); //Below face
  tmp.add(new Face(v1, v2, v6)); //Below face
  tmp.add(new Face(v4, v2, v3)); //Below face
  tmp.add(new Face(v4, v2, v6)); //Below face
  tmp.add(new Face(v1, v5, v3)); //Upper face
  tmp.add(new Face(v1, v5, v6)); //Upper face
  tmp.add(new Face(v4, v5, v3)); //Upper face
  tmp.add(new Face(v4, v5, v6)); //Upper face
  return tmp;
}

ArrayList<Face> getIcosahedronFace(){
  ArrayList<Face> tmp = new ArrayList<Face>();
  float goldenRatio = 1.6180339887 * k_scale;
  Vertex v1 = new Vertex(0,1*k_scale,goldenRatio);
  Vertex v2 = new Vertex(0,-1*k_scale,goldenRatio);
  Vertex v3 = new Vertex(0,1*k_scale,-goldenRatio);
  Vertex v4 = new Vertex(0,-1*k_scale,-goldenRatio);
  Vertex v5 = new Vertex(1*k_scale,goldenRatio,0);
  Vertex v6 = new Vertex(-1*k_scale,goldenRatio,0);
  Vertex v7 = new Vertex(1*k_scale,-goldenRatio,0);
  Vertex v8 = new Vertex(-1*k_scale,-goldenRatio,0);
  Vertex v9 = new Vertex(goldenRatio,0,1*k_scale);
  Vertex v10 = new Vertex(goldenRatio,0,-1*k_scale);
  Vertex v11 = new Vertex(-goldenRatio,0,1*k_scale);
  Vertex v12 = new Vertex(-goldenRatio,0,-1*k_scale);
  /*
  v1 front center 
  v2 front upper
  v3 mid center lower
  v4 back center
  v5 front lower right
  v6 front lower left
  v7 mid upper right
  v8 mid upper left
  v9 front upper right
  v10 mid lower right
  v11 front upper left
  v12 mid left center
  */
  tmp.add(new Face(v1, v2, v9)); //Red
  tmp.add(new Face(v1, v2, v11));//green
  tmp.add(new Face(v1, v11, v6)); //blue
  tmp.add(new Face(v1, v5, v6)); //yellow
  tmp.add(new Face(v1, v5, v9)); //cyan
  tmp.add(new Face(v4, v12, v3));
  tmp.add(new Face(v4,v7,v8));
  tmp.add(new Face(v4,v12,v8));
  tmp.add(new Face(v4,v10,v7));
  tmp.add(new Face(v4,v10,v3));
  tmp.add(new Face(v9, v5, v10));
  tmp.add(new Face(v9, v7, v10));
  tmp.add(new Face(v9, v7, v2));
  tmp.add(new Face(v5, v6, v3));
  tmp.add(new Face(v12, v6, v11));
  tmp.add(new Face(v12, v6, v3));
  tmp.add(new Face(v2, v11, v8));
  tmp.add(new Face(v2,v8,v7));
  tmp.add(new Face(v5,v10,v3));
  tmp.add(new Face(v11,v8,v12));
  return tmp;
}

void drawFace(Face face) {
  beginShape();
  for (Vertex vertex : face.getVertices()) {
    vertex(vertex.x, vertex.y, vertex.z);
  }
  endShape(CLOSE);
}

void drawSphere(Vertex vect, int size) {
  pushMatrix();
  translate(vect.x, vect.y, vect.z);
  sphere(size);
  popMatrix();
}

void drawCube(Vertex vect, int size) {
  pushMatrix();
  translate(vect.x, vect.y, vect.z);
  box(size);
  popMatrix();
}

void mouseDragged() {
  angleX += (pmouseY - mouseY) * rotationSpeed;
  angleY -= (pmouseX - mouseX) * rotationSpeed;
}
