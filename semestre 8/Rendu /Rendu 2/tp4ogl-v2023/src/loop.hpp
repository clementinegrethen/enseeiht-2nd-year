/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#pragma once

#include "core.hpp"

/**
 * Compute the subdivision of the input mesh by applying one step of the Loop algorithm
 *
 * @param[in] origVert The list of the input vertices
 * @param[in] origMesh The input mesh (the vertex indices for each face/triangle)
 * @param[out] destVert The list of the new vertices for the subdivided mesh
 * @param[out] destMesh The new subdivided mesh (the vertex indices for each face/triangle)
 * @param[out] destNorm The new list of normals for each new vertex of the subdivided mesh
 */
void loopSubdivision(const std::vector<point3d> &origVert, const std::vector<face> &origMesh, std::vector<point3d> &destVert, std::vector<face> &destMesh, std::vector<vec3d> &destNorm);


/**
 * For a given edge it returns the index of the new vertex created on its middle point. If such vertex already exists it just returns the
 * its index; if it does not exist it creates it in vertList along it's normal and return the index
 * @brief ObjModel::getNewVertex
 * @param e the edge
 * @param currFace the current triangle containing the edge e
 * @param vertList the list of vertices
 * @param indices the list of triangles
 * @param normList the list of normals associated to the vertices
 * @param newVertList The list of the new vertices added so far
 * @return the index of the new vertex
 * @see EdgeList
 */
idxtype getNewVertex(const edge &e, std::vector<point3d> &vertList, const std::vector<face> &mesh, EdgeList &newVertList);