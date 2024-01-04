public static class Edge {
  Vertex vertex1, vertex2;
  public Edge(Vertex v1, Vertex v2) {
    this.vertex1 = v1;
    this.vertex2 = v2;
  }

  public Vertex edgePoint(ArrayList<Face> neighbours) {
    // Set each edge point to be the average of the two neighbouring face points (A,F) and the two endpoints of the edge (vertex1,vertex2)
    Vertex avgEdge = Vertex.mult(Vertex.add(vertex1,vertex2),0.5);
    Vertex avgFace = new Vertex();
    for (Face f : neighbours) {
      avgFace = Vertex.add(avgFace,f.averageFacePoint());
    }
    avgFace = Vertex.mult(avgFace,1.0/(float)neighbours.size());
    return Vertex.mult(Vertex.add(avgEdge,avgFace),0.5);
  }

  // This function return an arraylist of all Edges contains the vertex, in normal circumstances listOfEdge is Face.getEdges()
  public static ArrayList<Edge> findEdgeOfVertex(Vertex vertex, ArrayList<Edge> listOfEdge){
    ArrayList<Edge> edgeOfVertex = new ArrayList<Edge>();
    for (Edge e : listOfEdge) {
      if (e.containVertex(vertex)) {
        edgeOfVertex.add(e);
      }
    }
    return edgeOfVertex;
  }

  public boolean containVertex(Vertex v){
    return (v.equals(vertex1) || v.equals(vertex2));
  }

  @Override
    public String toString() {
    return "[Vertex:"+vertex1+", "+vertex2+"]";
  }

  @Override
    public boolean equals(Object obj) {
    if (this == obj) return true;
    if (obj == null || getClass() != obj.getClass()) return false;
    Edge e = (Edge) obj;
    return (e.vertex1.equals(vertex1)&&e.vertex2.equals(vertex2))||(e.vertex1.equals(vertex2)&&e.vertex2.equals(vertex1));
  }
}
