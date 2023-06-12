/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#include "geometry.hpp"
#include "loop.hpp"
#include "MeshModel.hpp"
#include "objReader.hpp"
#include <cassert>
#include <cmath>
#include <fstream>
#include <iostream>
#include <sstream>
#include <string>
#include <vector>

bool MeshModel::load(const std::string& filename)
{
    return ::load(filename, _vertices, _mesh, _normals, _bb);
}


/**
* Render the model according to the provided parameters
* @param params The rendering parameters
*/
void MeshModel::render( const RenderingParameters &params )
{
    // if we need to draw the original model
    if ( !params.subdivision )
    {
        // draw it
        draw( _vertices, _mesh, _normals, params );
        // draw the normals
        if ( params.normals )
        {
            drawNormals( _vertices, _normals );
        }
    }
    else
    {
        PRINTVAR(params.subdivLevel);
        PRINTVAR(_currentSubdivLevel);
        // before drawing check the current level of subdivision and the required one
        if ( ( _currentSubdivLevel == 0 ) || ( _currentSubdivLevel != params.subdivLevel ) )
        {
            // if they are different apply the missing steps: either restart from the beginning
            // if the required level is less than the current one or apply the missing
            // steps starting from the current one
            std::vector<point3d> tmpVert;        //!< a temporary list of vertices used in the iterations
            std::vector<face> tmpMesh;           //!< a temporary mesh used in the iterations

            if(( _currentSubdivLevel == 0 ) || ( _currentSubdivLevel > params.subdivLevel ) )
            {
                // start from the beginning
                _currentSubdivLevel = 0;
                tmpVert = _vertices;
                tmpMesh = _mesh;
            }
            else
            {
                // start from the current level
                tmpVert = _subVert;
                tmpMesh = _subMesh;
            }

            // apply the proper subdivision iterations
            for( ; _currentSubdivLevel < params.subdivLevel; ++_currentSubdivLevel)
            {
                std::cerr << "[Loop subdivision] iteration " << _currentSubdivLevel << std::endl;
                loopSubdivision( tmpVert, tmpMesh, _subVert, _subMesh, _subNorm );
                // swap unless it's the last iteration
                if( _currentSubdivLevel < ( params.subdivLevel - 1) )
                {
                    tmpVert = _subVert;
                    tmpMesh = _subMesh;
                }
            }
        }

        draw( _subVert, _subMesh, _subNorm, params );
        if ( params.normals )
        {
            drawNormals( _subVert, _subNorm );
        }
    }
}

/**
 * Draw the model
 *
 * @param vertices list of vertices
 * @param indices list of faces
 * @param vertexNormals list of normals
 * @param params Rendering parameters
 */
void MeshModel::draw( const std::vector<point3d> &vertices, const std::vector<face> &indices, std::vector<vec3d> &vertexNormals, const RenderingParameters &params ) const
{
    if ( params.solid )
    {
        drawSolid( vertices, indices, vertexNormals, params );
    }
    if ( params.wireframe )
    {
        ::drawWireframe( vertices, indices, params );
    }

}

/**
 * It scales the model to unitary size by translating it to the origin and
 * scaling it to fit in a unit cube around the origin.
 *
 * @return the scale factor used to transform the model
 */
float MeshModel::unitizeModel( )
{
    if ( _vertices.empty( ) || _mesh.empty( ) )
    {
        return .0f;
    }

    //****************************************
    // calculate model width, height, and
    // depth using the bounding box
    //****************************************
    const float w = std::fabs( _bb.pmax.x - _bb.pmin.x );
    const float h = std::fabs( _bb.pmax.y - _bb.pmin.y );
    const float d = std::fabs( _bb.pmax.z - _bb.pmin.z );

    std::cout << "size: w: " << w << " h " << h << " d " << d << std::endl;
    //****************************************
    // calculate center of the bounding box of the model
    //****************************************
    const point3d c = (_bb.pmax + _bb.pmin) * 0.5;

    //****************************************
    // calculate the unitizing scale factor as the
    // maximum of the 3 dimensions
    //****************************************
    const auto scale = static_cast<float>(2.f / std::max(std::max(w, h), d));

    std::cout << "scale: " << scale << " cx " << c.x << " cy " << c.y << " cz " << c.z << std::endl;

    // translate each vertex wrt to the center and then apply the scaling to the coordinate
    for(auto& v : _vertices)
    {
        //****************************************
        // translate the vertex
        //****************************************
        v.translate( -c.x, -c.y, -c.z );

        //****************************************
        // apply the scaling
        //****************************************
        v.scale( scale );

    }


    //****************************************
    // update the bounding box, ie translate and scale the 6 coordinates
    //****************************************
    _bb.pmax = (_bb.pmax - c) * scale;
    _bb.pmin = (_bb.pmin - c) * scale;


    std::cout << "New bounding box : pmax=" << _bb.pmax << "  pmin=" << _bb.pmin << std::endl;

    return scale;

}


//*****************************************************************************
//*                        DEPRECATED FUNCTIONS
//*****************************************************************************

// to be deprecated

void MeshModel::flatDraw( ) const
{
    glShadeModel( GL_SMOOTH );

    // for each triangle draw the vertices and the normals
    for(const auto &face : _mesh)
    {
        glBegin( GL_TRIANGLES );
        //compute the normal of the triangle
        const vec3d n = computeNormal( _vertices[face.v1], _vertices[face.v2], _vertices[face.v3]);
        glNormal3fv( (float*) &n );

        glVertex3fv( (float*) &_vertices[face.v1] );

        glVertex3fv( (float*) &_vertices[face.v2] );

        glVertex3fv( (float*) &_vertices[face.v3] );

        glEnd( );
    }

}

// to be deprecated

void MeshModel::drawWireframe( ) const
{

    ::drawWireframe( _vertices, _mesh, RenderingParameters( ) );

}

// to be deprecated

void MeshModel::indexDraw( ) const
{
    glShadeModel( GL_SMOOTH );
    //****************************************
    // Enable vertex arrays
    //****************************************
    glEnableClientState( GL_VERTEX_ARRAY );

    //****************************************
    // Enable normal arrays
    //****************************************
    glEnableClientState( GL_NORMAL_ARRAY );

    //****************************************
    // Vertex Pointer to triangle array
    //****************************************
    glEnableClientState( GL_VERTEX_ARRAY );

    //****************************************
    // Normal pointer to normal array
    //****************************************
    glNormalPointer( GL_FLOAT, 0, (float*) &_normals[0] );

    //****************************************
    // Index pointer to normal array
    //****************************************
    glVertexPointer( COORD_PER_VERTEX, GL_FLOAT, 0, (float*) &_vertices[0] );

    //****************************************
    // Draw the triangles
    //****************************************
    glDrawElements( GL_TRIANGLES, static_cast<GLsizei>(_mesh.size( )) * VERTICES_PER_TRIANGLE, GL_UNSIGNED_INT, (idxtype*) & _mesh[0] );

    //****************************************
    // Disable vertex arrays
    //****************************************
    glDisableClientState( GL_VERTEX_ARRAY ); // disable vertex arrays

    //****************************************
    // Disable normal arrays
    //****************************************
    glDisableClientState( GL_NORMAL_ARRAY );
}

// to be deprecated
void MeshModel::drawSubdivision( )
{
    if ( _subMesh.empty( ) || _subNorm.empty( ) || _subVert.empty( ) )
    {
        loopSubdivision( _vertices, _mesh, _subVert, _subMesh, _subNorm );
    }

    glShadeModel( GL_SMOOTH );

    glEnableClientState( GL_NORMAL_ARRAY );
    glEnableClientState( GL_VERTEX_ARRAY );

    glNormalPointer( GL_FLOAT, 0, (float*) &_subNorm[0] );
    glVertexPointer( COORD_PER_VERTEX, GL_FLOAT, 0, (float*) &_subVert[0] );

    glDrawElements( GL_TRIANGLES, static_cast<GLsizei>(_subMesh.size( )) * VERTICES_PER_TRIANGLE, GL_UNSIGNED_SHORT, (idxtype*) & _subMesh[0] );


    glDisableClientState( GL_VERTEX_ARRAY ); // disable vertex arrays
    glDisableClientState( GL_NORMAL_ARRAY );

    ::drawWireframe( _subVert, _subMesh, RenderingParameters( ) );

}
