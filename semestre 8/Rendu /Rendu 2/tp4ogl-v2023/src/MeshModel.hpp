/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */


#pragma once

#include "core.hpp"
#include "objReader.hpp"
#include "rendering.hpp"

#include <cmath>
#include <optional>
#include <ostream>
#include <string>
#include <vector>

/**
 * The class containing and managing the 3D model 
 */
class MeshModel
{
private:

    /// Stores the vertex indices for the triangles
    std::vector<face> _mesh{};
    /// Stores the vertices
    std::vector<point3d> _vertices{};
    /// Stores the normals for the triangles
    std::vector<vec3d> _normals{};

    // Subdivision
    /// Stores the vertex indices for the triangles
    std::vector<face> _subMesh{};
    /// Stores the vertices
    std::vector<point3d> _subVert{};
    /// Stores the normals for the triangles
    std::vector<vec3d> _subNorm{};

    /// the current bounding box of the model
    BoundingBox _bb{};

    /// the current subdivision level
    unsigned short _currentSubdivLevel{};   

public:
  MeshModel() = default;

    /**
     * Load the OBJ data from file
      * @param[in] filename The name of the OBJ file
      * @return true if everything went well, false otherwise
     */
    bool load(const std::string& filename);

    /**
     * Render the model according to the provided parameters
     * @param params The rendering parameters
     */
    void render(const RenderingParameters &params = RenderingParameters());


    /**
     * It scales the model to unitary size by translating it to the origin and
     * scaling it to fit in a unit cube around the origin.
     *
     * @return the scale factor used to transform the model
     */
    float unitizeModel();


private:
    /**
    * Draw the model
    *
    * @param[in] vertices list of vertices
    * @param[in] indices list of faces
    * @param[in] vertexNormals list of normals
    * @param[in] params Rendering parameters
    */
    void draw(const std::vector<point3d> &vertices, const std::vector<face> &indices, std::vector<vec3d> &vertexNormals, const RenderingParameters &params) const;


    /////////////////////////////
    // DEPRECATED METHODS
    [[deprecated]] void drawSubdivision();
    [[deprecated]] void indexDraw() const;
    [[deprecated]] void flatDraw() const;
    [[deprecated]] void drawWireframe() const;


};