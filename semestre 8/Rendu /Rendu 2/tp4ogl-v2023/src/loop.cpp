/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#include "loop.hpp"
#include "geometry.hpp"

#include <cassert>

/**
 * Compute the subdivision of the input mesh by applying one step of the Loop algorithm
 *
 * @param[in] origVert The list of the input vertices
 * @param[in] origMesh The input mesh (the vertex indices for each face/triangle)
 * @param[out] destVert The list of the new vertices for the subdivided mesh
 * @param[out] destMesh The new subdivided mesh (the vertex indices for each face/triangle)
 * @param[out] destNorm The new list of normals for each new vertex of the subdivided mesh
 */
void loopSubdivision(const std::vector<point3d>& origVert, //!< the original vertices
                     const std::vector<face>& origMesh,    //!< the original mesh
                     std::vector<point3d>& destVert,       //!< the new vertices
                     std::vector<face>& destMesh,          //!< the new mesh
                     std::vector<vec3d>& destNorm)         //!< the new normals
{
    // copy the original vertices in destVert
    destVert = origVert;

    // start fresh with the new mesh
    destMesh.clear( );

    //    PRINTVAR(destVert);
    //    PRINTVAR(origVert);

    // create a list of the new vertices created with the reference to the edge
    EdgeList newVertices;

    //*********************************************************************
    // for each face
    //*********************************************************************
    for ( face f : origMesh )

    {
        //*********************************************************************
        // get the indices of the triangle vertices
        //*********************************************************************
        const idxtype v1 = f.v1;
        const idxtype v2 = f.v2;
        const idxtype v3 = f.v3;



        //*********************************************************************
        // for each edge get the index of the vertex of the midpoint using getNewVertex
        //*********************************************************************
        const idxtype v12 = getNewVertex( edge( v1, v2 ), destVert, origMesh, newVertices );
        const idxtype v23 = getNewVertex( edge( v2, v3 ), destVert, origMesh, newVertices );
        const idxtype v31 = getNewVertex( edge( v3, v1 ), destVert, origMesh, newVertices );



        //*********************************************************************
        // create the four new triangles
        // BE CAREFUL WITH THE VERTEX ORDER!!
        //               v2
        //               /\
        //              /  \
        //             /    \
        //            a ---- b
        //           / \     /\
        //          /   \   /  \
        //         /     \ /    \
        //        v1 ---- c ---- v3
        //
        // the original triangle was v1-v2-v3, use the same clock-wise order for the other
        // hence v1-a-c, a-b-c and so on
        //*********************************************************************
        destMesh.push_back( face( v1, v12, v31 ) );
        destMesh.push_back( face( v12, v2, v23 ) );
        destMesh.push_back( face( v31, v23, v3 ) );
        destMesh.push_back( face( v12, v23, v31 ) );

    }

    //*********************************************************************
    // Update each "old" vertex using the Loop coefficients. A smart way to do
    // so is to think in terms of faces than the single vertex: for each face
    // we update each of the 3 vertices using the Loop formula wrt the other 2 and
    // sum it to a temporary copy tmp of the vertices (which is initialized to
    // [0 0 0] at the beginning). We also keep a record of the occurrence of each vertex.
    // At then end, to get the final vertices we just need to divide each vertex
    // in tmp by its occurrence
    //*********************************************************************

    // A list containing the occurrence of each vertex
    std::vector<size_t> occurrences( origVert.size( ), 0 );

    // A list of the same size as origVert with all the elements initialized to [0 0 0]
    std::vector<point3d> tmp( origVert.size( ) );

    //*********************************************************************
    // for each face
    //*********************************************************************
    for ( face f : origMesh )
    {
        //*********************************************************************
        // consider each of the 3 vertices:
        // 1) increment its occurrence
        // 2) apply Loop update wrt the other 2 vertices of the face
        // BE CAREFUL WITH THE COEFFICIENT OF THE OTHER 2 VERTICES!... consider
        // how many times each vertex is summed in the general case...
        //*********************************************************************
        occurrences[f.v1]++;
        occurrences[f.v2]++;
        occurrences[f.v3]++;
        tmp[f.v1] += (5.0 / 8.0) * origVert[f.v1] + (3.0 / 16.0) * (origVert[f.v2] + origVert[f.v3]);
        tmp[f.v2] += (5.0 / 8.0) * origVert[f.v2] + (3.0 / 16.0) * (origVert[f.v3] + origVert[f.v1]);
        tmp[f.v3] += (5.0 / 8.0) * origVert[f.v3] + (3.0 / 16.0) * (origVert[f.v1] + origVert[f.v2]);







    }

    //*********************************************************************
    //  To obtain the new vertices, divide each vertex by its occurrence value
    //*********************************************************************
    for ( size_t i = 0; i < tmp.size( ); i++ )
    {
        assert( occurrences[i] != 0 );
        destVert[i] = tmp[i] / occurrences[i];
    }

    //PRINTVAR(destVert);

    // redo the normals, reset and create a list of normals of the same size as
    // the vertices, each normal set to [0 0 0]
    destNorm.clear( );
    destNorm = std::vector<vec3d>(destVert.size( ));

    //*********************************************************************
    //  Recompute the normals for each face
    //*********************************************************************
    for ( face f : destMesh )
    {
        //*********************************************************************
        //  Calculate the normal of the triangles, it will be the same for each vertex
        //*********************************************************************
        const vec3d normal = computeNormal( destVert[f.v1], destVert[f.v2], destVert[f.v3] );

        //*********************************************************************
        // Sum the normal of the face to each vertex normal using the angleAtVertex as weight
        //*********************************************************************
        destNorm[f.v1] += normal * angleAtVertex( destVert[f.v1], destVert[f.v2], destVert[f.v3] );
        destNorm[f.v2] += normal * angleAtVertex( destVert[f.v2], destVert[f.v3], destVert[f.v1] );
        destNorm[f.v3] += normal * angleAtVertex( destVert[f.v3], destVert[f.v1], destVert[f.v2] );

    }
    //*********************************************************************
    // normalize the normals of each vertex
    //*********************************************************************
    for(vec3d v: destVert) {
        v.normalize();
    }

    
}

/**
 * FordestVerta given edge it returns the index of the new vertex created on its middle point.
 * If such vertex already exists it just returns the its index; if it does not exist
 * it creates it in vertList along it's normal and return the index
 *
 * @param[in] e the edge
 * @param[in,out] vertList the list of vertices
 * @param[in] mesh the list of triangles
 * @param[in,out] newVertList The list of the new vertices added so far
 * @return the index of the new vertex or the one that has been already created for that edge
 * @see EdgeList
 */
idxtype getNewVertex(const edge& e,
                     std::vector<point3d>& vertList,
                     const std::vector<face>& mesh,
                     EdgeList& newVertList)
{
    //    PRINTVAR(e);
    //    PRINTVAR(newVertList);

    //*********************************************************************
    // if the egde is NOT contained in the new vertex list (see EdgeList.contains() method)
    //*********************************************************************
    if ( !newVertList.contains( e ) )

    {
        //*********************************************************************
        // generate new index (vertex.size)
        //********************************************************************* 
        const idxtype newIndex = vertList.size( );
    


        //*********************************************************************
        // add the edge and index to the newVertList
        //*********************************************************************
        newVertList.add( e, newIndex );


        // generate new vertex
        point3d nvert;        //!< this will contain the new vertex
        idxtype oppV1;        //!< the index of the first "opposite" vertex
        idxtype oppV2;        //!< the index of the second "opposite" vertex (if it exists)

        //*********************************************************************
        // check if it is a boundary edge, ie check if there is another triangle
        // sharing this edge and if so get the index of its "opposite" vertex
        //*********************************************************************
        if ( !isBoundaryEdge( e, mesh, oppV1, oppV2 ) )

        {
            // if it is not a boundary edge create the new vertex

            //*********************************************************************
            // the new vertex is the linear combination of the two extrema of
            // the edge V1 and V2 and the two opposite vertices oppV1 and oppV2
            // Using the loop coefficient the new vertex is
            // nvert = 3/8 (V1+V2) + 1/8(oppV1 + oppV2)
            //
            // REMEMBER THAT IN THE CODE OPPV1 AND OPPV2 ARE INDICES, NOT VERTICES!!!
            //*********************************************************************
             nvert = (3.0 / 8.0) * (vertList[e.first] + vertList[e.second]) + (1.0 / 8.0) * (vertList[oppV1] + vertList[oppV2]);


        }
         else
        {
            //*********************************************************************
            // otherwise it is a boundary edge then the vertex is the linear combination of the
            // two extrema
            //*********************************************************************
            nvert = (1.0 / 2.0) * (vertList[e.first] + vertList[e.second]);
        }
        //*********************************************************************
        // append the new vertex to the list of vertices
        //*********************************************************************
        vertList.push_back( nvert );

        //*********************************************************************
        // return the index of the new vertex
        //*********************************************************************
        return newIndex;

    }
     else
    // else we don't need to do anything, just return the associated index of the
    // already existing vertex
    {
        //*********************************************************************
        // get and return the index of the vertex
        //*********************************************************************
        return newVertList.getIndex( e );
    }

    // this is just to avoid compilation errors at the beginning
    // execution should normally never reach here
    // the return instructions go inside each branch of the if - else above
    // remove this return instruction once you have implemented the function
    std::cerr << "WARNING: the subdivision may not be implemented correctly" << std::endl;
    return 0;
}