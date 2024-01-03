public static class Vertex {
    float x,y,z;
    public Vertex(float x,float y, float z) {
        this.x = x;
        this.y = y;
        this.z = z;
    }

    public Vertex(){
        this(0,0,0);
    }


    public static Vertex add(Vertex ... vect){
        Vertex sum = new Vertex();
        for (Vertex v : vect) {
            sum.x += v.getX();
            sum.y += v.getY();
            sum.z += v.getZ();
        }
        return sum;
    }
    public float getX(){
        return this.x;
    }
    public float getY(){
        return this.y;
    }
    public float getZ(){
        return this.z;
    }    
    public void setX(float x){
        this.x = x;
    }    
    public void setY(float y){
        this.y = y;
    }
    public void setZ(float z){
        this.z = z;
    }
    public PVector getPVector(){
        return new PVector(x,y,z);
    }
    static Vertex PVecToVertex(PVector vect){
        return new Vertex(vect.x,vect.y,vect.z);
    }
    @Override
    public String toString(){
        return "[x="+x+", y="+y+", z="+z+"]";
    } 

    @Override
    public boolean equals(Object obj){
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        Vertex v = (Vertex) obj;
        return (x==v.x) && (y==v.y) && (z==v.z);
    }
}
