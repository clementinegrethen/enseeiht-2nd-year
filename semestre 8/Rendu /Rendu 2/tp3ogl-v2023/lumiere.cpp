#include <cstdlib>
#include <cstdio>
#include <cmath>

// for mac osx
#ifdef __APPLE__
#include <OpenGL/gl.h>
#include <OpenGL/glu.h>
#include <GLUT/glut.h>
#else
// only for windows
#ifdef _WIN32
#include <windows.h>
#endif
// for windows and linux
#include <GL/gl.h>
#include <GL/glu.h>
#include <GL/freeglut.h>


#endif


float angle_x{45.f};
float angle_y{45.f};
float distance{8.f};
float shininess{25.f};

bool directional{false}; 



/**
 * @brief Draw a room of size size centered on the origin
 * it's a cube with inverted normals, ie pointing inwards
 * @param size
 */
void glRoom (GLfloat size)
{
    GLfloat v = size/2;

    glBegin (GL_QUADS);
        glNormal3f ( 0,  0, 1);
        glVertex3f (-v, -v, -v);
        glVertex3f ( v, -v, -v);
        glVertex3f ( v,  v, -v);
        glVertex3f (-v,  v, -v);

        glNormal3f ( 0,  0, -1);
        glVertex3f ( v, -v, v);
        glVertex3f (-v, -v, v);
        glVertex3f (-v,  v, v);
        glVertex3f ( v,  v, v);

        glNormal3f ( -1, 0,  0);
        glVertex3f ( v, -v, -v);
        glVertex3f ( v, -v,  v);
        glVertex3f ( v,  v,  v);
        glVertex3f ( v,  v, -v);

        glNormal3f ( 1,  0,  0);
        glVertex3f (-v, -v,  v);
        glVertex3f (-v, -v, -v);
        glVertex3f (-v,  v, -v);
        glVertex3f (-v,  v,  v);

        glNormal3f ( 0, -1,  0);
        glVertex3f (-v,  v, -v);
        glVertex3f ( v,  v, -v);
        glVertex3f ( v,  v,  v);
        glVertex3f (-v,  v,  v);

        glNormal3f ( 0,  1,  0);
        glVertex3f (-v, -v, -v);
        glVertex3f (-v, -v,  v);
        glVertex3f ( v, -v,  v);
        glVertex3f ( v, -v, -v);
    glEnd();
}


/**
 * @brief Place the camera in the scene
 */
void place_camera ()
{
    glTranslatef (0.f, 0.f, -distance);
    glRotatef (angle_x, 1.f, 0.f, 0.f);
    glRotatef (angle_y, 0.f, 1.f, 0.f);
}

/**
 * @brief Place a light in the scene
 * @param[in] x x coordinate of the light
 * @param[in] y y coordinate of the light
 * @param[in] z z coordinate of the light
 */
void place_light (GLfloat x, GLfloat y, GLfloat z)
{
    //**********************************
    // set the light components: ambient (0.2 grey),
    // diffuse and specular (both white)
    //**********************************
    GLfloat light_ambient[]= { 0.2f, 0.2f, 0.2f, 1.f };
    GLfloat light_diffuse[]= { 1.f, 1.f, 1.f, 1.f };
    GLfloat light_specular[]= { 1.f, 1.f, 1.f, 1.f };







    //**********************************
    // set the light position (directional or positional)
    //**********************************
    GLfloat light_position[]= { x, y, z, directional ? 0.f : 1.f};

    glLightfv(GL_LIGHT0, GL_AMBIENT, light_ambient);
    glLightfv(GL_LIGHT0, GL_DIFFUSE, light_diffuse);
    glLightfv(GL_LIGHT0, GL_SPECULAR, light_specular);
    glLightfv(GL_LIGHT0, GL_POSITION, light_position);








    //**********************************
    // draw a yellow point to visually represent the light
    //**********************************
    //glDisable (GL_LIGHT0);
    glDisable (GL_LIGHTING);
    glPointSize(5.0);
    glBegin(GL_POINTS);
        glColor3f(1.0, 1.0, 0);

        glVertex3f(x, y, z);
    glEnd();

     







    //**********************************
    // turn the light and the lighting on
    //**********************************

    glEnable (GL_LIGHT0);
    glEnable (GL_LIGHTING);






}

/**
 * @brief Define a material
 * @param ar  ambient red component
 * @param ag  ambient green component
 * @param ab  ambient blue component
 * @param dr  diffuse red component
 * @param dg  diffuse green component
 * @param db  diffuse blue component
 * @param sr  specular red component
 * @param sg  specular green component
 * @param sb  specular blue component
 * @param sh  shininess
 */
void define_material (	GLfloat ar, GLfloat ag, GLfloat ab, // ambient
                        GLfloat dr, GLfloat dg, GLfloat db, // diffuse
                        GLfloat sr, GLfloat sg, GLfloat sb, // specular
                        GLfloat sh							// shininess
                        )
{
    GLfloat mat_ambient[4];
    GLfloat mat_diffuse[4];
    GLfloat mat_specular[4];

    //**********************************
    // set the ambient property
    //**********************************
    mat_ambient[0] = ar;
    mat_ambient[1] = ag;
    mat_ambient[2] = ab;
    mat_ambient[3] = 1.f;
    glMaterialfv (GL_FRONT, GL_AMBIENT, mat_ambient);

    //**********************************
    // set the diffuse property
    //**********************************
    mat_diffuse[0] = dr;
    mat_diffuse[1] = dg;
    mat_diffuse[2] = db;
    mat_diffuse[3] = 1.f;
    glMaterialfv (GL_FRONT, GL_DIFFUSE, mat_diffuse);

    //**********************************
    // set the specular property
    //**********************************
    mat_specular[0] = sr;
    mat_specular[1] = sg;
    mat_specular[2] = sb;
    mat_specular[3] = 1.f;
    glMaterialfv (GL_FRONT, GL_SPECULAR, mat_specular);

    //**********************************
    // set the shininess property
    //**********************************
    glMaterialf (GL_FRONT, GL_SHININESS, sh);
}

/**
 * @brief Place the room in the scene
 */
void place_background ()
{
    glPushMatrix();
        glScalef (15.f, 15.f, 15.f);
        glRoom (1.f);
    glPopMatrix ();
}


/**
 * OpenGL Initialization
 */
void init ()
{
    glClearColor (0.f, 0.f, 0.f, 0.f);
    //**********************************
    // activate the Gouraud shading instead of the flat one
    //**********************************
    glShadeModel (GL_SMOOTH);


    //**********************************
    // enable face culling
    //**********************************
    glEnable (GL_CULL_FACE);


    //**********************************
    // enable the depth test
    //**********************************
    glutInitDisplayMode(GLUT_RGB|GLUT_DEPTH);
    glEnable(GL_DEPTH_TEST);


    //**********************************
    // set the ambient light with glLightModelfv to a 50% grey
    //**********************************
    glShadeModel(GL_SMOOTH);
    glEnable(GL_NORMALIZE);
}


void display ()
{
    glClear (GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();

    //place the camera
    place_camera ();

    //**********************************
    // place the light in the scene using place_light
    //**********************************
    place_light(7, 10, 0);
    //place_light(0, 0, 0);



    //**********************************
    // define the material for the room (instead of color)
    //**********************************
    //glColor3f (1.f, 1.f, 1.f);
    define_material(0.1, 0.1, 0.1, // ambient
                    0.5, 0.5, 0.5, // diffuse
                    1.0, 1.0, 1.0, // specular
                    10.0);			// shininess








    place_background();

    // the 2 objects
    // red shining sphere
    glPushMatrix ();
        glTranslatef (-2.f, 0.f, 0.f);

        //**********************************
        // define the material for the sphere (instead of color)
        //**********************************
        define_material(0.1, 0.1, 0.1, // ambient
                        0.5, 0.0, 0.0, // diffuse
                        1.0, 1.0, 1.0, // specular
                        shininess);			// shininess







        glutSolidSphere (1.0, 24, 12);

    glPopMatrix ();

    // green cube
    glPushMatrix ();
        glTranslatef (2.f, 0.f, 0.f);

        //**********************************
        // define the material for the cube (instead of color)
        //**********************************
        //glColor3f (0.f, 1.f, 0.f);
        define_material(0.1, 0.1, 0.1, // ambient
                        0.0, 0.5, 0.0, // diffuse
                        1.0, 1.0, 1.0, // specular
                        10.0);			// shininess








        glutSolidCube (2.0);

    glPopMatrix ();

    glutSwapBuffers ();
}

/**
 *	@brief Callback for window size change
 *	@param[in] w new width of the window
 *	@param[in] h new height of the window
 */
void reshape (int w, int h)
{
    glViewport (0, 0, (GLsizei) w, (GLsizei) h);
    glMatrixMode (GL_PROJECTION);
    glLoadIdentity();
    gluPerspective (60, (GLfloat)w/(GLfloat)h, 0.1, 50);
}


/**
 * Callback for special keys
 */
void special (int key, int, int)
{
    static constexpr float DELTA_ANGLE_X{5.f};
    static constexpr float DELTA_ANGLE_Y{5.f};
    static constexpr float DELTA_DISTANCE{.3f};
    static constexpr float DISTANCE_MIN{.0f};

    switch (key) {
        case GLUT_KEY_UP:
            angle_x = std::fmod(angle_x + DELTA_ANGLE_X, 360.f);
        break;
        case GLUT_KEY_DOWN:
            angle_x = std::fmod(angle_x - DELTA_ANGLE_X, 360.f);
        break;
        case GLUT_KEY_LEFT:
            angle_y = std::fmod(angle_y + DELTA_ANGLE_Y, 360.f);
        break;
        case GLUT_KEY_RIGHT:
            angle_y = std::fmod(angle_y - DELTA_ANGLE_Y, 360.f);
        break;
        case GLUT_KEY_PAGE_DOWN:
            distance += DELTA_DISTANCE;
        break;
        case GLUT_KEY_PAGE_UP:
            distance -= (distance > DISTANCE_MIN)? DELTA_DISTANCE: .0f;
        break;

        default:
            break;
    }
    glutPostRedisplay();
}


void keyboard (unsigned char key, int, int)
{
    switch (key) {
        //**********************************
        // directional light, use global variable directional
        //**********************************
        case 'd':
            directional = !directional;






        break;

        //**********************************
        // Shininess: 's' to decrement, 'S' to increment
        //**********************************
        case 's':
            shininess += 1.f;






        break;

        case 'e':
            shininess -= 1.f;




        break;

        case 'q':
        case 27: // [ESC]
            exit(0);
        break;
        default:
        break;
    }
    glutPostRedisplay();
}



int main (int argc, char **argv)
{
    glutInit (&argc,argv);
    // enable the double buffer and the depth buffer
    glutInitDisplayMode (GLUT_DOUBLE | GLUT_RGB | GLUT_DEPTH);

    // main window
    glutInitWindowSize (640,480);
    glutInitWindowPosition (50,50);
    glutCreateWindow ("Testing OpenGL light");

    // callbacks
    glutDisplayFunc (display);
    glutReshapeFunc (reshape);

    glutKeyboardFunc (keyboard);
    glutSpecialFunc (special);

    init();

    glutMainLoop();
    exit (0);
}
