/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#pragma once

#include "core.hpp"

/**
 * Calculate the normal of a triangular face defined by three points
 *
 * @param[in] v1 the first vertex of the face
 * @param[in] v2 the second vertex of the face
 * @param[in] v3 the third vertex of the face
 * @return the normal of the face as a normalized vector
 * @note the normal is normalized
 */
vec3d computeNormal( const point3d& v1, const point3d& v2, const point3d& v3);

/**
 * Computes the angle at vertex baseV formed by the edges connecting it with the
 * vertices v1 and v2 respectively, ie the baseV-v1 and baseV-v2 edges
 *
 * @brief Computes the angle at vertex
 * @param[in] baseV the vertex at which to compute the angle
 * @param[in] v1 the other vertex of the first edge baseV-v1
 * @param[in] v2 the other vertex of the second edge baseV-v2
 * @return the angle in radiants
 */
[[nodiscard]] float angleAtVertex(const point3d& baseV, const point3d& v2, const point3d& v3);