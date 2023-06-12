
#include <cstdlib>
#include <cstdio>
#include <cmath>
#include <algorithm>

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


// Global variables to animate the robotic arm
float angle1 = 45; 
float angle2 = 45;

// Global variables to rotate the arm as a whole
float robotAngleX = 0;
float robotAngleY = 0;
float ecart_pince  = 0.2; 








/**
 * Function that draws the reference system (three lines along the x, y, z axis)
 */
void drawReferenceSystem()
{
    glBegin(GL_LINES);
    //**********************************
    // set the line width to 3.0
    //**********************************
    glLineWidth(3.0);
    //**********************************
    // Draw three lines along the x, y, z axis to represent the reference system
    // Use red for the x-axis, green for the y-axis and blue for the z-axis
    //**********************************
    glColor3f(1.0, 0.0, 0.0);
    glVertex3f(0,0,0);
    glVertex3f(1,0,0);
    glColor3f(0.0, 1.0, 0.0);
    glVertex3f(0,0,0);
    glVertex3f(0,1,0);
    glColor3f(0.0, 0.0, 1.0);
    glVertex3f(0,0,0);
    glVertex3f(0,0,1);

    //**********************************
    // reset the drawing color to white
    //**********************************
    glColor3f(1,1,1);  
    //**********************************
    // reset the line width to 1.0
    //**********************************
    glLineWidth(1.0);

    glEnd();

}


/**
 * Function that draws a single joint of the robotic arm
 */
void drawJoint()
{
    // first draw the reference system
    drawReferenceSystem();

    glPushMatrix();

    // Draw the joint as a parallelepiped (a cube scaled on the y-axis
    //**********************************
    // Bring the cube "up" so that the bottom face is on the xz plane
    //**********************************

    glTranslatef(0,0.5,0);

    //**********************************
    // draw the scaled cube. Remember that the scaling has to be only
    // on the local reference system, hence we need to get a local copy
    // of the modelview matrix...
    //**********************************
    glScalef(1,2,1);
    glutWireCube(1);

    glPopMatrix();

}

/**
 * Function that draws the robot as three parallelepipeds
 */
void drawRobot()
{
    //**********************************
    // we work on a copy of the current MODELVIEW matrix, hence we need to...
    //**********************************
    glPushMatrix();
     

    // draw the first joint
    drawJoint();


    // Draw the other joints: every joint must be placed on top of the previous one
    // and rotated according to the relevant Angle
       
    //**********************************
    // the second joint
    //**********************************
    glTranslatef(0,2,0);
    glRotatef(angle1,0,0,1);
    drawJoint();




    //**********************************
    // the third joint
    //**********************************

    
    glTranslatef(0,2,0);
    glRotatef(angle2,0,0,1);
    drawJoint();

    // on ajoute un rectngle horizontal 
    glTranslatef(0,1.7,0);
    glScalef(1,0.5,1);
    glutWireCube(0.7);

    // on ajoute deux pinces sur le rectangle 
    glPushMatrix();
    glTranslatef(0,0.7,ecart_pince);
    glScalef(1,1,0.1);
    glutWireCube(1);
    glPopMatrix();

    // deuxième pince 
    glPushMatrix();
    glTranslatef(0,0.7,-ecart_pince);
    glScalef(1,1,0.1);
    glutWireCube(1);
    glPopMatrix();

    //**********************************
    // "Release" the copy of the current MODELVIEW matrix
    //**********************************
    glPopMatrix();

}


/**
 * Function that handles the display callback (drawing routine)
 */
void display()
{
    // clear the window
    glClear(GL_COLOR_BUFFER_BIT);

    // working with the GL_MODELVIEW Matrix
    glMatrixMode(GL_MODELVIEW);

    //**********************************
    // we work on a copy of the current MODELVIEW matrix, hence we need to...
    //**********************************
    glPushMatrix();


    //**********************************
    // Rotate the robot around the x-axis and y-axis according to the relevant angles
    //**********************************
    glRotatef(robotAngleX,1,0,0);
    glRotatef(robotAngleY,0,1,0);



    // draw the robot
    drawRobot();

    

    //**********************************
    // "Release" the copy of the current MODELVIEW matrix
    //**********************************
    glPopMatrix();


    // flush drawing routines to the window
    glutSwapBuffers();

}


/**
 * Function that handles the special keys callback
 * @param[in] key the key that has been pressed
 * @param[in] x the mouse in window relative x-coordinate when the key was pressed
 * @param[in] y the mouse in window relative y-coordinate when the key was pressed
 */
void arrows(int key, int, int)
{
    //**********************************
    // Manage the update of RobotAngleX and RobotAngleY with the arrow keys
    //**********************************
    switch (key) {
        case GLUT_KEY_UP:
            robotAngleX += 5;
            break;
        case GLUT_KEY_DOWN:
            robotAngleX -= 5;
            break;
        case GLUT_KEY_LEFT:
            robotAngleY += 5;
            break;
        case GLUT_KEY_RIGHT:
            robotAngleY -= 5;
            break;
        default:
            break;
    }




    glutPostRedisplay();
}


/**
 * Function that handles the keyboard callback
 * @param key  the key that has been pressed
 * @param[in] x the mouse in window relative x-coordinate when the key was pressed
 * @param[in] y the mouse in window relative y-coordinate when the key was pressed
 */
void keyboard(unsigned char key, int, int)
{
    switch (key) {
        case 'z':
            if (angle1 >= -90) {
                angle1 -= 5;
            }
            break;
        case 'a':
        if (angle1 <= 90) {
            angle1 += 5;
        }
            break;
        case 'e': 
        if (angle2 <= 90) {
            angle2 += 5;
        }
            break;
        case 'r':
         if (angle2 >= -90) {
            angle2 -= 5;
         }
            break;
        case 'o':
        if (ecart_pince <0.3) ecart_pince+=0.02;

            break;
        case 'l':
            if (ecart_pince >0.07) ecart_pince-=0.02;
            break;
        default:
            break;

    }

    glutPostRedisplay();
}


void init()
{
    glClearColor(0.f, 0.f, 0.f, 0.f);
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    gluPerspective(65.0, 1.0, 1.0, 100.0);

    glShadeModel(GL_FLAT);
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();

    // Place the camera
    gluLookAt( 2,2,-6,0,2,0,0,1,0);  // up vector
}


/**
 * Function called every time the main window is resized
 * @param[in] width the new window width in pixels
 * @param[in] height the new window height in pixels
 */
void reshape(int width, int height)
{

    // define the viewport transformation;
    glViewport(0, 0, width, height);
    if (width < height)
        glViewport(0, (height - width) / 2, width, width);
    else
        glViewport((width - height) / 2, 0, height, height);
}


/**
 * Function that prints out how to use the keyboard
 */
void usage()
{
    printf("\n*******\n");
    printf("Arrows key: rotate the whole robot\n");
    printf("[a][z] : move the second joint of the arm\n");
    printf("[e][r] : move the third joint of the arm\n");

    printf("[esc]  : terminate\n");
    printf("*******\n");
}


int main(int argc, char **argv) {
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB);
    glutInitWindowSize(500, 500);
    glutInitWindowPosition(100, 100);
    glutCreateWindow(argv[0]);
    init();
    glutDisplayFunc(display);

    glutReshapeFunc(reshape);
    //**********************************
    // Register the keyboard function
    //**********************************
     glutKeyboardFunc(keyboard);

    //**********************************
    // Register the special key function
    //**********************************
    glutSpecialFunc(arrows);


    // just print the help
    usage();

    glutMainLoop();

    return EXIT_SUCCESS;
}


