/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#include "objReader.hpp"
#include "geometry.hpp"

#include <regex>
#include <array>
#include <cmath>
#include <iostream>
#include <fstream>

/**
 * Load the OBJ data from file
 * @param[in] filename The name of the OBJ file to load
 * @param[out] vertices The list of vertices
 * @param[out] mesh The list of faces
 * @param[out] normals The list of normals
 * @param[out] bb The bounding box of the object
 * @return true if everything went well, false otherwise
 */
bool load(const std::string& filename, std::vector<point3d>& vertices, std::vector<face>& mesh, std::vector<vec3d>& normals, BoundingBox& bb)
{
    std::string line;
    std::ifstream objFile( filename );

    // If obj file is not open return (e.g. file does not exist
    if (! objFile.is_open( ) )
    {
        std::cerr << "Unable to open file " << filename << std::endl;
        return false;
    }

    // Start reading file data
    while( !objFile.eof( ) )
    {
        // Get a line from file
        getline( objFile, line );

        // If the first character is a simple 'v'...
//            PRINTVAR( line );
        if ( (line[0] == 'v') && (line[1] == ' ') ) // to drop all the vn and vn lines
        {
//                PRINTVAR( line );
            // Read 3 floats from the line:  X Y Z and store them in the corresponding place in _vertices
            const point3d p = parseVertexString(line);

            //**************************************************
            // add the new point to the list of the vertices
            // and its normal to the list of normals: for the time
            // being it is a [0, 0 ,0] normal.
            //************************************************** 
            vertices.push_back( p );
            normals.push_back( vec3d( 0, 0, 0 ) );
            




            // update the bounding box, if it is the first vertex simply
            // set the bb to it
            if (vertices.size( ) == 1 )
            {
                bb.set( p );
            }
            else
            {
                // otherwise add the point
                bb.add( p );
            }

        }
        // If the first character is a 'f'...
        if ( line[0] == 'f' )
        {
            face t = parseFaceString( line);

            //**************************************************
            // correct the indices: OBJ starts counting from 1, in C the arrays starts at 0...
            //**************************************************
            t.v1 -= 1;
            t.v2 -= 1;
            t.v3 -= 1;


            //**************************************************
            // add it to the mesh
            //**************************************************
            mesh.push_back( t );


            //*********************************************************************
            //  Compute the normal of the face
            //*********************************************************************
            vec3d normalFace = computeNormal( vertices[t.v1], vertices[t.v2], vertices[t.v3]);
            //*********************************************************************
            // Sum the normal of the face to each vertex normal
            //*********************************************************************
             float angle = angleAtVertex( vertices[t.v1], vertices[t.v2], vertices[t.v3] );
            normals[t.v1] += normalFace * angle;
            normals[t.v2] += normalFace * angle;
            normals[t.v3] += normalFace * angle;

        }
    }

    std::cerr << "Found :\n\tNumber of triangles (_indices) " << mesh.size( ) << "\n\tNumber of Vertices: " << vertices.size( ) << "\n\tNumber of Normals: " << normals.size( ) << std::endl;
       PRINTVAR( mesh );
       PRINTVAR( vertices );
       PRINTVAR( normals );

    //*********************************************************************
    // normalize the normals of each vertex
    //*********************************************************************
    for ( auto& n : normals )
    {
        n.normalize( );
    }




     PRINTVAR( normals );

    // Close OBJ file
    objFile.close();


    std::cout << "Object loaded with " << vertices.size( ) << " vertices and " << mesh.size( ) << " faces" << std::endl;
    std::cout << "Bounding box : pmax=" << bb.pmax << "  pmin=" << bb.pmin << std::endl;
    return true;
}







//////////////////////////////////////// Nothing to do after this /////////////////////////////////

// lambda to convert the string matches to a face
auto face_from_match(const std::string& vst1, const std::string& vst2, const std::string& vst3) -> face
{
    const auto v1 = static_cast<idxtype>(std::stoi(vst1));
    const auto v2 = static_cast<idxtype>(std::stoi(vst2));
    const auto v3 = static_cast<idxtype>(std::stoi(vst3));
    return {v1, v2, v3};
}

face parseFaceString(const std::string &toParse)
{
    const auto res = parseFaceStringRegex(toParse);
    if(!res.has_value())
        throw std::runtime_error("Error while reading line: " + toParse);

    return res.value();
}

std::optional<face> parseFaceStringRegex( const std::string &toParse)
{
    static const std::array<std::regex, 4> face_regexes {
          // regex to match a face from a string in the format f v1 v2 v3
          std::regex(R"(f\s+(\d+)\s+(\d+)\s+(\d+))"),
          // regex to match a face from a string in the format f v1/t1 v2/t2 v3/t3
          std::regex(R"(f\s+(\d+)(?:\/\d+){1}\s+(\d+)(?:\/\d+){1}\s+(\d+)(?:\/\d+){1})"),
          // regex to match a face from a string in the format f v1/t1/n1 v2/t2/n2 v3/t3/n3
          std::regex(R"(f\s+(\d+)(?:\/\d+){2}\s+(\d+)(?:\/\d+){2}\s+(\d+)(?:\/\d+){2})"),
          // regex to match a face from a string in the format f v1//n1 v2//n2 v3//n3
          std::regex (R"(f\s+(\d+)(?:\/\/\d+){1}\s+(\d+)(?:\/\/\d+){1}\s+(\d+)(?:\/\/\d+){1})")
    };

    // early exit if the string is empty or does not start with 'f'
    if (toParse.empty() || toParse[0] != 'f' )
    {
        return {};
    }

    std::smatch face_match;

    // try to match the string to each of the regexes
    for(const auto& face_regex : face_regexes)
    {
        if(std::regex_search(toParse, face_match, face_regex))
        {
            return face_from_match(face_match[1], face_match[2], face_match[3]);
        }
    }

    // if no match was found, return an empty optional
    return {};
}

point3d parseVertexString(const std::string &toParse)
{
    const auto res = parseVertexStringRegex(toParse);
    if(!res.has_value())
        throw std::runtime_error("Error while reading line: " + toParse);

    return res.value();
}

std::optional<point3d> parseVertexStringRegex(const std::string &toParse)
{
    static const std::regex vertex_regex(R"(v\s+([+-]?(?:[0-9]*[.])?[0-9]+)\s+([+-]?(?:[0-9]*[.])?[0-9]+)\s+([+-]?(?:[0-9]*[.])?[0-9]+))");

    // early exit if the string is empty or does not start with 'v'
    if (toParse.empty() || toParse[0] != 'v' )
    {
        return {};
    }

    std::smatch vertex_match;

    // try to match the string to the regex
    if(std::regex_search(toParse, vertex_match, vertex_regex))
    {
        const auto x = std::stof(vertex_match[1]);
        const auto y = std::stof(vertex_match[2]);
        const auto z = std::stof(vertex_match[3]);
        return point3d(x, y, z);
    }

    // if no match was found, return an empty optional
    return {};
}

