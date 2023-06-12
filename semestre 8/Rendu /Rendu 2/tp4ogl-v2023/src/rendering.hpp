/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#pragma once

#include "core.hpp"
#include "openglAll.hpp"
#include <vector>

/// number of vertices in a triangle
constexpr GLsizei VERTICES_PER_TRIANGLE{3};
/// number of coordinates per vertex
constexpr GLsizei COORD_PER_VERTEX{3};
/// total number of floats in a triangle
constexpr GLsizei TOTAL_FLOATS_IN_TRIANGLE { (VERTICES_PER_TRIANGLE * COORD_PER_VERTEX) };

struct RenderingParameters
{
    /// wireframe on/off
    bool wireframe{true};
    /// draw the mesh on/off
    bool solid { true };
    /// use opengl drawElements on/off
    bool useIndexRendering{false};
    /// subdivision on/off
    bool subdivision{false};
    /// GL_SMOOTH on/off
    bool smooth{false};
    /// show normals on/off
    bool normals{false};
    /// number of subdivision level
    unsigned short subdivLevel{1};

    RenderingParameters() = default;

};

/**
* Draw the wireframe of the model
*
* @param[in] vertices The list of vertices
* @param[in] mesh The mesh as a list of faces, each face is a tripleIndex of vertex indices
* @param[in] params The rendering parameters
*/
void drawWireframe(const std::vector<point3d> &vertices, const std::vector<face> &indices, const RenderingParameters &params);

/**
 * Draw the model using the vertex indices and using a single normal for each vertex
 *
 * @param[in] vertices The vertices of the model as a list of points.
 * @param[in] indices The list of the faces, each face containing the 3 indices of the vertices.
 * @param[in] vertexNormals The list of normals associated to each vertex.
 * @param[in] params The rendering parameters
 */
void drawSmoothFaces(const std::vector<point3d> &vertices, const std::vector<face> &indices, std::vector<vec3d> &vertexNormals, const RenderingParameters &params);

/**
* Draw the faces using the computed normal of each face
*
* @param[in] vertices The list of vertices
* @param[in] mesh The list of face, each face containing the indices of the vertices
* @param[in] params The rendering parameters
*/
void drawFlatFaces(const std::vector<point3d> &vertices, const std::vector<face> &indices, const RenderingParameters &params);


//////////////////////////////////////////////////////////////////////////////////////////////

/**
* Draw the normals at each vertex of the model.
* @param[in] vertices The list of vertices
* @param[in] vertexNormals The list of associated normals
*/
void drawNormals(const std::vector<point3d> &vertices, const std::vector<vec3d>& vertexNormals);


void drawSolid(const std::vector<point3d> &vertices, const std::vector<face> &indices, std::vector<vec3d> &vertexNormals, const RenderingParameters &params);
