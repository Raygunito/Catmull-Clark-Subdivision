public class Edge {
    Vertex vertex1, vertex2;
    ArrayList<Face> neighbours;
    public Edge(Vertex v1, Vertex v2) {
        this.vertex1 = v1;
        this.vertex2 = v2;
        neighbours = new ArrayList<Face>();
    }

    public Vertex edgePoint(){
        Vertex midPoint = Vertex.PVecToVertex(PVector.div(Vertex.add(vertex1, vertex2).getPVector(), 2));
        Vertex facePointsAverage = new Vertex();
        for (Face neighbor : neighbours) {
          facePointsAverage = Vertex.add(facePointsAverage, neighbor.averageFacePoint());
        }
        facePointsAverage = Vertex.PVecToVertex(PVector.div(facePointsAverage.getPVector(), neighbours.size()));
        float n = neighbours.size();
        float factor = 1.0 / n * (n - 3) / (n - 1);
        return Vertex.PVecToVertex(PVector.add(PVector.mult(midPoint.getPVector(), factor),PVector.mult(facePointsAverage.getPVector(), 1 - factor)));
    }

    public void addFace(Face f){
        if (!neighbours.contains(f)) {
            neighbours.add(f);
        }
    }
    @Override
    public String toString(){
        return "[Vertex:"+vertex1+", "+vertex2+"][Neighours size:"+neighbours.size()+"]";
    }
}
