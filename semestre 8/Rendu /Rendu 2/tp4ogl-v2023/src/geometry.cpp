/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */


#include "geometry.hpp"
#include <cmath>

/**
 * Calculate the normal of a triangular face defined by three points
 *
 * @param[in] v1 the first vertex of the face
 * @param[in] v2 the second vertex of the face
 * @param[in] v3 the third vertex of the face
 * @return the normal of the face as a normalized vector
 * @note the normal is normalized
 */
vec3d computeNormal( const point3d& v1, const point3d& v2, const point3d& v3)
{
    //**************************************************
    // compute the cross product between two edges of the triangular face
    //**************************************************
    vec3d norm;
    vec3d e1 = v2 - v1;
    vec3d e2 = v3 - v1;
    norm = e1.cross( e2 );

    //**************************************************
    // remember to normalize the result before returning it
    //**************************************************
    norm.normalize( );

    return norm;
}


//////////////////////////////////////// Nothing to do after this /////////////////////////////////


/**
 * Computes the angle at vertex baseV formed by the edges connecting it with the
 * vertices v1 and v2 respectively, ie the baseV-v1 and baseV-v2 edges
 *
 * @brief Computes the angle at vertex
 * @param baseV the vertex at which to compute the angle
 * @param v1 the other vertex of the first edge baseV-v1
 * @param v2 the other vertex of the second edge baseV-v2
 * @return the angle in radiants
 */
float angleAtVertex( const point3d& baseV, const point3d& v2, const point3d& v3 )
{
    const vec3d e1 = baseV - v2;
    const vec3d e2 = baseV - v3;
    //safe acos...
    if ( std::fabs( (e1).dot( e2 ) / (e1.norm( ) * e2.norm( )) ) >= 1.f )
    {
        std::cerr << "warning: using safe acos" << std::endl;
        return (std::acos( 1.f ));
    }
    else
    {
        return ( std::acos( (e1).dot( e2 ) / (e1.norm( ) * e2.norm( )) ));
    }
}