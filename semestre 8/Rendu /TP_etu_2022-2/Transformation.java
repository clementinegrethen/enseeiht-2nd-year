
import algebra.*;

/**
 * author: cdehais
 */
public class Transformation  {

    Matrix worldToCamera;
    Matrix projection;
    Matrix calibration;

    public Transformation () {
        try {
            worldToCamera = new Matrix ("W2C", 4, 4);
            projection = new Matrix ("P", 3, 4);
            calibration = Matrix.createIdentity (3);
            calibration.setName ("K");
        } catch (InstantiationException e) {
            /* should not reach */
        }
    }
    // on définit la matrice worldToCamera
    public void setLookAt (Vector3 cam, Vector3 lookAt, Vector3 up) {
        try {
         Vector3 e3_c=new Vector3(lookAt);
        e3_c.subtract(cam);
        e3_c.normalize ();
        Vector3 e1_c = up.cross(e3_c);
        e1_c.normalize ();
        Vector3 e2_c = e3_c.cross(e1_c);
        e2_c.normalize();
        Matrix N_transpose = new Matrix(3, 3);
        N_transpose.setRow(0, e1_c);
        N_transpose.setRow(1, e2_c);
        N_transpose.setRow(2, e3_c);
        //vecteur  de translation
        Vector t= new Vector(3);
        t=N_transpose.multiply(cam);
        t.scale(-1);
        //matrice de passage
        worldToCamera = new Matrix(4, 4);
        worldToCamera.setSubMatrix(0, 0, N_transpose);
        worldToCamera.setSubVector(0, 3, t);
        Vector v = new Vector(4);
        v.set(3, 1);
        worldToCamera.setRow(3, v);


        } catch (Exception e) { /* unreached */ };
        
        System.out.println("Modelview matrix:\n" + worldToCamera);
    }

    public void setProjection () {
        // création de la matrice de projection pour z = 1
       try { 
        //Matrix projection = new Matrix (3, 4);
        System.out.println("ok");
        Vector v1 = new Vector (4);
        v1.set (0, 1);
        Vector v2 = new Vector (4);
        v2.set (1, 1);
        Vector v3 = new Vector (4);
        v3.set (2, 1);
    
        projection.setRow(0, v1);

        projection.setRow(1, v2);
        projection.setRow(2, v3);
        System.out.println("Projection matrix:\n" + projection);

        } catch (Exception e) { /* unreached */ };

    }

    public void setCalibration (double focal, double width, double height) {
        try { //Matrix
        //calibration= new Matrix (3, 3);
        Vector v1 = new Vector (3);
        v1.set (0, focal);
        v1.set (1, 0);
        v1.set (2, width/2);
        Vector v2 = new Vector (3);
        v2.set (0, 0);
        v2.set (1, focal);
        v2.set (2, height/2);
        Vector v3 = new Vector (3);
        v3.set (0, 0);
        v3.set (1, 0);
        v3.set (2, 1);
        calibration.setRow (0, v1);
        calibration.setRow (1, v2);
        calibration.setRow (2, v3);
        System.out.println ("Calibration matrix:\n" + calibration);
        } catch (Exception e) { /* unreached */ };

    }

    /**
     * Projects the given homogeneous, 4 dimensional point onto the screen.
     * The resulting Vector as its (x,y) coordinates in pixel, and its z coordinate
     * is the depth of the point in the camera coordinate system.
     */  
    public Vector3 projectPoint (Vector p)
        throws SizeMismatchException, InstantiationException {
	    Vector ps = new Vector(3);
        ps = calibration.multiply(projection.multiply(worldToCamera.multiply(p)));
        // normalisation en perspective
        double z= ps.get(2);
        ps.scale(1/ps.get(2));
        // on conserve la profondeur
        ps.set(2, z);
	    return new Vector3 (ps);
    }
    
    /**
     * Transform a vector from world to camera coordinates.
     */
    public Vector3 transformVector (Vector3 v)
        throws SizeMismatchException, InstantiationException {
        /* Doing nothing special here because there is no scaling */
        Matrix R = worldToCamera.getSubMatrix (0, 0, 3, 3);
        Vector tv = R.multiply (v);
        return new Vector3 (tv);
    }
    
}

