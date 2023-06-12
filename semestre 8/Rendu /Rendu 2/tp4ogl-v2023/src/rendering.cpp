/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#include "rendering.hpp"
#include "geometry.hpp"

/**
 * Draw the wireframe of the model
 *
 * @param vertices The list of vertices
 * @param mesh The mesh as a list of faces, each face is a tripleIndex of vertex indices
 * @param params The rendering parameters
 */
void drawWireframe(const std::vector<point3d>& vertices,
                   const std::vector<face>& mesh,
                   const RenderingParameters& params)
{
    //**************************************************
    // we first need to disable the lighting in order to
    // draw colored segments
    //**************************************************
    glDisable(GL_LIGHTING);

    // if we are displaying the object with colored faces
    if ( params.solid )
    {
        // use black ticker lines
        glColor3f( 0, 0, 0 );
        glLineWidth( 2 );
    }
    else
    {
        // otherwise use white thinner lines for wireframe only
        glColor3f( .8f, .8f, .8f );
        glLineWidth( .21f );
    }

    //**************************************************
    // for each face of the mesh...
    //**************************************************

     for (  face f : mesh )
    {
        //**************************************************
        // draw the contour of the face as a  GL_LINE_LOOP
        //**************************************************
        glBegin( GL_LINE_LOOP );
        glVertex3fv( (float *) &vertices[f.v1] );
        glVertex3fv( (float *) &vertices[f.v2] );
        glVertex3fv( (float *) &vertices[f.v3] );

        glEnd( );
    }

    //**************************************************
    // re-enable the lighting
    //**************************************************
    glEnable( GL_LIGHTING );
}


/**
 * Draw the faces using the computed normal of each face
 *
 * @param[in] vertices The list of vertices
 * @param[in] mesh The list of face, each face containing the indices of the vertices
 * @param[in] params The rendering parameters
 */
void drawFlatFaces(const std::vector<point3d>& vertices,
                   const std::vector<face>& mesh,
                   const RenderingParameters& params)
{
    // shading model to use
    if(params.smooth)
    {
        glShadeModel(GL_SMOOTH);
    }
    else
    {
        glShadeModel(GL_FLAT);
    }

    //**************************************************
    // for each face
    //**************************************************
    for ( face f : mesh )
    {  
        //**************************************************
        // Compute the normal to the face and then draw the
        // faces as GL_TRIANGLES assigning the proper normal
        //**************************************************
        glBegin( GL_TRIANGLES );
        vec3d normal = computeNormal(vertices[f.v1], vertices[f.v2], vertices[f.v3]);
        glNormal3fv( (float *) &normal);
        glVertex3fv( (float *) &vertices[f.v1]);
        glVertex3fv( (float *) &vertices[f.v2]);
        glVertex3fv( (float *) &vertices[f.v3]);
        glEnd( );
    }
}



/**
 * Draw the model using the vertex indices
 *
 * @param vertices The vertices
 * @param indices The list of the faces, each face containing the 3 indices of the vertices
 * @param vertexNormals The list of normals associated to each vertex
 * @param params The rendering parameters
 */
void drawSmoothFaces(const std::vector<point3d>& vertices,
                     const std::vector<face>& mesh,
                     std::vector<vec3d>& vertexNormals,
                     const RenderingParameters& params)
{
    if(params.smooth)
    {
        glShadeModel(GL_SMOOTH);
    }
    else
    {
        glShadeModel(GL_FLAT);
    }
    //****************************************
    // Enable vertex arrays
    //****************************************
    glEnableClientState(GL_VERTEX_ARRAY);

    //****************************************
    // Enable normal arrays
    //****************************************
    glEnableClientState(GL_NORMAL_ARRAY);

    //****************************************
    // Normal pointer to normal array
    //****************************************
    glNormalPointer(GL_FLOAT, 0, (float*)&vertexNormals[0]);

    //****************************************
    // Vertex pointer to Vertex array
    //****************************************
    glVertexPointer(3, GL_FLOAT, 0, (float*)&vertices[0]);

    //****************************************
    // Draw the faces
    //****************************************
    glDrawElements(GL_TRIANGLES, mesh.size() * 3, GL_UNSIGNED_INT, (int*)&mesh[0]);

    //****************************************
    // Disable vertex arrays
    //****************************************
    glDisableClientState(GL_VERTEX_ARRAY);

    //****************************************
    // Disable normal arrays
    //****************************************
    glDisableClientState(GL_NORMAL_ARRAY);

}



//////////////////////////////////////// Nothing to do after this /////////////////////////////////

void drawNormals(const std::vector<point3d>& vertices, const std::vector<vec3d>& vertexNormals)
{
    glDisable(GL_LIGHTING);

    glColor3f(.8f, .0f, .0f);
    glLineWidth(2);

    for(std::size_t i = 0; i < vertices.size(); ++i)
    {
        glBegin(GL_LINES);

        const auto v = vertices[i];
        const auto n = vertexNormals[i];

        vec3d newP = v + 0.05f * n;
        glVertex3fv((float*)&v);

        glVertex3f(newP.x, newP.y, newP.z);

        glEnd();
    }
    glEnable(GL_LIGHTING);
}

void drawSolid(const std::vector<point3d>& vertices,
               const std::vector<face>& indices,
               std::vector<vec3d>& vertexNormals,
               const RenderingParameters& params)
{
    if(params.useIndexRendering)
    {
        drawSmoothFaces(vertices, indices, vertexNormals, params);
    }
    else
    {
        drawFlatFaces(vertices, indices, params);
    }
}