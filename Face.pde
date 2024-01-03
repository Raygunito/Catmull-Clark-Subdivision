public class Face {
    ArrayList<Vertex> vertices;
    ArrayList<Edge> edges;
    public Face(Vertex... vertices) {
        this.vertices = new ArrayList<Vertex>();
        this.edges = new ArrayList<Edge>();
        for (int i = 0; i < vertices.length; i++) {
            this.vertices.add(vertices[i]);
            this.edges.add(new Edge(vertices[(i)%vertices.length], vertices[(i+1)%vertices.length]));
            this.edges.get(i).addFace(this);
        }
    }

    public Vertex averageFacePoint(){
        // Face point = (sum(Vertex))/sizeOf(Vertex)
        Vertex sum = new Vertex();
        for (Vertex v : vertices) {
            sum = Vertex.add(sum,v);
        }
        return Vertex.PVecToVertex(PVector.div(sum.getPVector(),vertices.size()));
    }

    public boolean containEdge(Edge e){
        if (edges.contains(e)){
            return true;
        }
        return false;
    }

    public ArrayList<Vertex> getVertices() {
        return this.vertices;
    }

    public ArrayList<Edge> getEdges(){
        return this.edges;
    }

    @Override
    public String toString(){
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
