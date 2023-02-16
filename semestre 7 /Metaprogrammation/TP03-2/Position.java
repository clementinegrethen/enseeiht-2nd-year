/** DÃ©finir une position.  */
public class Position extends Object {
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + x;
		result = prime * result + y;
		return result;	
	}

	private int x;
	private int y;

	public Position(int x, int y) {
		this.x = x;
		this.y = y;
		System.out.println("...appel Ã  Position(" + x + "," + y + ")" + " --> " + this);
	}

	@Override public String toString() {
		return super.toString() + "(" + x + "," + y + ")";
	}
	public int getY(){
		return y;
	}
	public void setY(int y){
		this.y = y;
	}
	@Override
	public boolean equals(Object o1) {
		if (o1 == null) return false;
		if (o1 == this) return true;
		if (o1.getClass() != this.getClass()) return false;
		Position p1 = (Position) o1;
		return this.x == p1.x && this.y == p1.y;
	}
}


