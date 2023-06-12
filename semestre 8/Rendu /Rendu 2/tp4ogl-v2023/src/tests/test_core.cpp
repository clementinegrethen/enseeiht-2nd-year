/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#define BOOST_TEST_MODULE testRenderer

#define BOOST_TEST_DYN_LINK

#include <boost/test/unit_test.hpp>
#include <core.hpp>

#include <map>
#include <string>
#include <random>

BOOST_AUTO_TEST_SUITE(test_core)

BOOST_AUTO_TEST_CASE(test_edge)
{
    edge2vertex mylist {{edge(6, 5), 6},
                       {edge(1, 2), 1},
                       {edge(2, 1), 4},
                       {edge(1, 4), 5},
                       {edge(3, 5), 6}};

    BOOST_CHECK_EQUAL(mylist.size(), 4);
//    PRINTVAR(mylist);

    BOOST_CHECK(mylist.find(edge(4,1)) != mylist.end());
    BOOST_CHECK(mylist.find(edge(3,2)) == mylist.end());
    BOOST_CHECK(mylist.find(edge(1,2)) != mylist.end());
    BOOST_CHECK(mylist.find(edge(2,1)) != mylist.end());
    BOOST_CHECK(mylist.find(edge(5,3)) != mylist.end());
    BOOST_CHECK(mylist.find(edge(6,5)) != mylist.end());

    // test equality
    BOOST_CHECK_EQUAL(mylist[edge(1, 2)], 1);
    BOOST_CHECK_EQUAL(mylist[edge(2, 1)], 1);
    BOOST_CHECK_EQUAL(mylist[edge(1, 4)], 5);
    BOOST_CHECK_EQUAL(mylist[edge(3, 5)], 6);
    BOOST_CHECK_EQUAL(mylist[edge(6, 5)], 6);

    BOOST_CHECK((edge(3,5)==edge(3,5)));
    BOOST_CHECK((edge(3,5)==edge(5,3)));
    BOOST_CHECK((edge(1,2)!=edge(3,5)));

    idxtype idx{0};
    idxtype tmp = idx;
    BOOST_CHECK(!face(1,2,3).containsEdge( edge(3,5), idx ));
    BOOST_CHECK( idx == tmp);
    BOOST_CHECK((face(1,2,3).containsEdge( edge(2,3), idx )));
    BOOST_CHECK( idx == 1);
    BOOST_CHECK(face(1,2,3).containsEdge( edge(3,2), idx ));
    BOOST_CHECK( idx == 1);
    tmp = idx;
    BOOST_CHECK(!(face(1,2,3).containsEdge( edge(0,2), idx )));
    BOOST_CHECK( idx == tmp);
    BOOST_CHECK((face(1,2,3).containsEdge( edge(3,1), idx )));
    BOOST_CHECK( idx == 2);

}

BOOST_AUTO_TEST_CASE(test_edge_list)
{
    EdgeList list;
    const idxtype numTrial{1000};

    const idxtype maxIdx  = numTrial/5;

    std::random_device rd;  // Will be used to obtain a seed for the random number engine
    std::mt19937 gen(rd()); // Standard mersenne_twister_engine seeded with rd()
    std::uniform_int_distribution<> distrib(1, maxIdx);

    std::vector<edge> listEdges;
    std::vector<idxtype> listIdx;

    // fill up the list with random edges
    for(idxtype i =0; i < numTrial; ++i)
    {
        edge e(static_cast<idxtype>(distrib(gen)), static_cast<idxtype>(distrib(gen)));
        listEdges.push_back(e);
        listIdx.push_back(i);

        list.add(e, i);
    }

    // test
    for(size_t i =0; i < numTrial; ++i)
    {
        const edge e = listEdges[i];
        // test it contains the edges we inserted
        BOOST_CHECK(list.contains( e ));

        // reflexive test (inverted indices))
        BOOST_CHECK(list.contains( edge(e.second, e.first)));

        const idxtype res = list.getIndex( e );

        // if the index is different
        if( res != listIdx[i] )
        {
            // then there must be another edge with the same indices in the reversed order
            bool found = false;
            for( size_t j= 0; (j < numTrial) && (!found); ++j )
            {
                // avoid to check for the current edge
                if(j != i )
                {
                    found = (listEdges[j] == e);
                    if(found)
                    {
                        BOOST_CHECK(listEdges[j] == e);
                    }
                }
            }
            BOOST_CHECK(found);
        }
    }
}

BOOST_AUTO_TEST_SUITE_END()