/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#pragma once

#include "core.hpp"
#include <string>
#include <optional>

/**
 * A structure that model the bounding box
 */
struct BoundingBox
{
    /// the maximum point of the bounding box
    point3d pmax{};
    /// the minimum point of the bounding box
    point3d pmin{};

    /**
     * Default constructor
     */
    BoundingBox() = default;

    /**
     * Add a point to the bounding box. Its coordinates are taken into account
     * and the limits of the bounding box updated accordingly
     * @param[in] p the point to add
     */
    void add(const point3d &p)
    {
        pmax.max(p);
        pmin.min(p);
    }

    /**
     * Set the bounding box to the given point
     * @param[in] p the point
     */
    void set(const point3d &p)
    {
        pmax = p;
        pmin = p;
    }

};

/**
 * Load the OBJ data from file
 * @param[in] filename The name of the OBJ file to load
 * @param[out] vertices The list of vertices
 * @param[out] mesh The list of faces
 * @param[out] normals The list of normals
 * @param[out] bb The bounding box of the object
 * @return true if everything went well, false otherwise
 */
bool load(const std::string& filename, std::vector<point3d>& vertices, std::vector<face>& mesh, std::vector<vec3d>& normals, BoundingBox& bb);





//////////////////////////////////////////////////////////////////////////////////////////////////////////////


/**
 * It parses a line of the OBJ file containing a face and it return the result.
 * NB: it only recover the indices, it discard normal and texture indices
 *
 * @param[in] toParse the string to parse in the OBJ format for a face (f v/vt/vn v/vt/vn v/vt/vn) and its variants
 * @return the 3 indices for the face
 */
face parseFaceString(const std::string &toParse);

std::optional<face> parseFaceStringRegex( const std::string &toParse);

/**
 * It parses a line of the OBJ file containing a vertex and it return the result.
 *
 * @param[in] toParse the string to parse in the OBJ format for a vertex (v x y z)
 * @return the 3 coordinates of the vertex
 */
point3d parseVertexString(const std::string &toParse);

std::optional<point3d> parseVertexStringRegex(const std::string &toParse);





