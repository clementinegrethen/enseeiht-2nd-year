#include <cstdlib>

// for mac osx
#ifdef __APPLE__
#include <GLUT/glut.h>
#include <OpenGL/gl.h>
#include <OpenGL/glu.h>
#else
// only for windows
#ifdef _WIN32
#include <windows.h>
#endif
// for windows and linux
#include <GL/freeglut.h>
#include <GL/gl.h>
#include <GL/glu.h>
#endif

#include <iostream>
using namespace std;

void display()
{
    // clear window
    glClear(GL_COLOR_BUFFER_BIT);

    // set current matrix as GL_MODELVIEW
    glMatrixMode(GL_MODELVIEW);

    // draw scene

    // add a copy of the curr. matrix to the stack
    glPushMatrix();

        glPushMatrix();
            gluLookAt(.0, .0, 5., .0, .0, -1., .0, 1., .0);

        
            // translate by -3 on the z
            glTranslatef(.0f, .0f, -3.f);
            // set drawing color to red
            glColor3f(1.0f, 0.0f, 0.0f);
            // middle red teapot
            glutWireTeapot(1);
            // translate by 2 on the y
            glTranslatef(.0f, 2.f, .0f);
            // set drawing color to blue
            glColor3f(.0f, 1.0f, .0f);
            // rotate 90 deg around x
            glRotatef(90.f, 1.0f, 0.0f, 0.0f);
            // top green teapot
            glutWireTeapot(1);
        // pop the current matrix
        glPopMatrix();

        // translate -2 on y and -1 on z
        glTranslatef(.0f, -2.f, -1.f);
        // set drawing color to blue
        glColor3f(.0f, .0f, 1.f);
        // bottom blue teapot
        glutWireTeapot(1);

    // pop the current matrix
    glPopMatrix();

    // flush drawing routines to the window
    glFlush();
}

// Function called everytime a key is pressed
void key(unsigned char key, int, int)
{
    switch(key)
    {
        case 27:
        case 'q': exit(EXIT_SUCCESS); break;
        default: break;
    }
    glutPostRedisplay();
}

void reshape(int width, int height)
{
    // define the viewport transformation
    glViewport(0, 0, width, height);
}

int main(int argc, char* argv[])
{
    // initialize GLUT, using any commandline parameters passed to the program
    glutInit(&argc, argv);

    // setup the size, position, and display mode for new windows
    glutInitWindowSize(500, 500);
    glutInitWindowPosition(0, 0);
    glutInitDisplayMode(GLUT_RGB);

    // create and set up a window
    glutCreateWindow("hello, teapot!");
    // Set up the callback functions
    // for display
    glutDisplayFunc(display);
    // for the keyboard
    glutKeyboardFunc(key);
    // for reshaping
    glutReshapeFunc(reshape);

    // define the projection transformation
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    gluPerspective(60, 1, 1, 10);

    // define the viewing transformation
    glMatrixMode(GL_MODELVIEW);
    // glLoadIdentity();
    //gluLookAt(.0, .0, 5., .0, .0, -1., .0, 1., .0);

    // tell GLUT to wait for events
    glutMainLoop();
}
