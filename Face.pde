public static class Face {
  ArrayList<Vertex> vertices;
  ArrayList<Edge> edges;
  public Face(Vertex... vertices) {
    this.vertices = new ArrayList<Vertex>();
    this.edges = new ArrayList<Edge>();
    for (int i = 0; i < vertices.length; i++) {
      this.vertices.add(vertices[i]);
      this.edges.add(new Edge(vertices[(i)%vertices.length], vertices[(i+1)%vertices.length]));
    }
  }
  
  // 1st step Set each face point to be the average of all original points for the respective face
  // Face point = (sum(Vertex))/sizeOf(Vertex)
  public Vertex averageFacePoint() {
    Vertex sum = new Vertex();
    for (Vertex v : vertices) {
      sum = Vertex.add(sum, v);
    }
    return Vertex.mult(sum, 1.0/vertices.size());
  }

  //Set each edge point to be the average of the two neighbouring face points (A,F)
  public static ArrayList<Face> findNeighbours(Edge edge, ArrayList<Face> mesh) {
    //Find each face that Edge touch it, i.e. Edge is included in the Face
    ArrayList<Face> neighbours = new ArrayList<Face>();
    for (Face face : mesh) {
      if (face.containEdge(edge)) {
        neighbours.add(face);
      }
    }
    return neighbours;
  }

  public boolean containEdge(Edge e) {
    if (edges.contains(e)) {
      return true;
    }
    return false;
  }

  public ArrayList<Vertex> getVertices() {
    return this.vertices;
  }

  public ArrayList<Edge> getEdges() {
    return this.edges;
  }

  @Override
    public String toString() {
    String res ="Vertices :";
    for (Vertex v : vertices) {
      res += v.toString();
    }
    res += "\nEdges :";
    for (Edge e : edges) {
      res+= e.toString();
    }
    return res;
  }
}
