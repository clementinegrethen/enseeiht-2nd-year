/**
 * @author: cdehais
 * 
 * Basic linear algebra methods
 */

package algebra;

import java.lang.Math;

public class Vector implements Cloneable {

    protected int size;
    protected double values[];
    public String name = "v";


    protected Vector () { }

    /**
     * Creates a named vector of size @size
     */
    public Vector (String name, int size) throws java.lang.InstantiationException {
        this (size);
        this.name = name;
    }

    /**
     * Creates a vector of size @size
     */ 
    public Vector (int size) throws java.lang.InstantiationException {
        allocValues (size);
    }

    /**
     *  Compute the norm of the vector
     */
    public double norm () {
        double r = 0.0;
        
        for (int i = 0; i < this.size; i++) {
            r += this.values[i] * this.values[i];
        }

        return Math.sqrt (r);
    }
    
    /**
     * Makes the Vector unitary.
     */
    public void normalize () {
        double norm = norm();

        for (int i = 0; i < size; i++) {
            values[i] /= norm;
        }
    }
    /**
     * Multiplies the Vector by the given constant. 
     */
    public void scale (double f) {
        for (int i = 0; i < size; i++) {
            values[i] *= f;
        }
    }

    /**
     * Computes the vector dot product between the Vector and another Vector.
     * Both must be the same size.
     */
    public double dot (Vector v) throws SizeMismatchException {
        if (size != v.size) {
            throw new SizeMismatchException (this, v);
        }

        double d = 0.0;

        for (int i = 0; i < size; i++) {
            d += this.values[i] * v.values[i];
        }

        return d;
    }

    /**
     * Adds the given Vector to the Vector
     */
    public void add (Vector v) throws SizeMismatchException {
        if (size != v.size) {
            throw new SizeMismatchException (this, v);
        }

        for (int i = 0; i < size; i++) {
            values[i] += v.values[i];
        }
    }

    /**
     * Subtracts the given Vector to the Vector
     */
    public void subtract (Vector v) throws SizeMismatchException {
        if (size != v.size) {
            throw new SizeMismatchException (this, v);
        }

        for (int i = 0; i < size; i++) {
            values[i] -= v.values[i];
        }
    }

    /**
     * Returns a string representation of the Vector.
     * Using Matlab compatible output for easy debugging.
     */
    public String toString () {
        String repr = name + " = [";

        for (int i = 0; i < size-1; i++) {
            repr += values[i] + ", ";
        }

        repr += values[size-1] + "]';";

        return repr;
    }


    /**
     * Sets the name of the Vector  
     */ 
    public void setName (String name) {
        this.name = name;
    }

    /**
     * Gets the Vector's name
     */
    public String getName () {
        return this.name;
    }


    /**
     * Sets the @i-th coordinate to the given value @value.
     */
    public void set (int i, double value) {
        this.values[i] = value;
    }

    /**
     * Sets the values of the vector to the values contained in the given array
     */
    public void set (double values[]) throws Exception {
        if (values.length != this.size) {
            throw new Exception ("Bad size");
        }
        this.values = values;
    }
   public void setRow2 (int i, Vector v) throws SizeMismatchException {
        if (v.size != this.size) {
            throw new SizeMismatchException (this, v);
        }

        for (int j = 0; j < this.size; j++) {
            if (i == j) {
                for (int k = 0; k < this.size; k++) {
                    this.values[k] = v.values[k];
                }
            }
        }
    }
    /**
     * Sets all elements of the vector to 0 
     */
    public void zeros () {
        for (int i = 0; i < size; i++) {
            values[i] = 0.0;
        }
    }
    
    /**
     * Sets all elements of the vector to 1
     */
    public void ones () {
        for (int i = 0; i < size; i++) {
            values[i] = 1.0;
        }
    }

    /**
     * Gets the @i-th coordinate of the Vector.
     */
    public double get (int i) {
        return this.values[i];
    }

    /**
     * Returns the Vector size
     */
    public int size () {
        return this.size;
    }
    
    protected void allocValues (int size) throws java.lang.InstantiationException {
        if (size < 1) {
            throw new java.lang.InstantiationException ("Vector size must be strictly positive");
        }
        this.values = new double[size]; 
        this.size = size;
    }
}

