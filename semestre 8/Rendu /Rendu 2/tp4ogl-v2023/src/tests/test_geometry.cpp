/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#define BOOST_TEST_MODULE testRenderer

#define BOOST_TEST_DYN_LINK

#include <boost/test/unit_test.hpp>
#include <geometry.hpp>

#include <map>
#include <string>
#include <optional>
#include <cmath>


BOOST_AUTO_TEST_SUITE(test_geometry)

BOOST_AUTO_TEST_CASE(test_compute_normal)
{
    const auto normal = computeNormal({0, 0, 0}, {1, 0, 0}, {0, 1, 0});
    BOOST_CHECK_CLOSE(normal.x, .0f, 0.0001f);
    BOOST_CHECK_CLOSE(normal.y, .0f, 0.0001f);
    BOOST_CHECK_CLOSE(normal.z, 1.f, 0.0001f);
    BOOST_CHECK_CLOSE(normal.norm(), 1.f, 0.0001f);
}

BOOST_AUTO_TEST_CASE(test_angleAtVertex)
{
    const auto c45 = static_cast<float>(std::cos(M_PI_4));
    const auto s45 = static_cast<float>(std::sin(M_PI_4));
    BOOST_CHECK_CLOSE(angleAtVertex({0, 0, 0}, {1, 0, 0}, {0, 1, 0}), M_PI_2, 0.0001f);
    BOOST_CHECK_CLOSE(angleAtVertex({0, 0, 0}, {1, 0, 0}, {c45, s45, 0}), M_PI_4, 0.0001f);
    BOOST_CHECK_CLOSE(angleAtVertex({0, 0, 0}, {1, 0, 0}, {-c45, s45, 0}), 3.f*M_PI_4, 0.0001f);
    BOOST_CHECK_CLOSE(angleAtVertex({0, 0, 0}, {1, 0, 0}, {-c45, -s45, 0}), 3.f*M_PI_4, 0.0001f);
    BOOST_CHECK_CLOSE(angleAtVertex({0, 0, 0}, {c45, s45, 0}, {1, 0, 0}), M_PI_4, 0.0001f);
    BOOST_CHECK_CLOSE(angleAtVertex({0, 0, 0}, {c45, -s45, 0}, {1, 0, 0}), M_PI_4, 0.0001f);
    BOOST_CHECK_CLOSE(angleAtVertex({0, 0, 0}, {-c45, -s45, 0}, {1, 0, 0}), 3.f*M_PI_4, 0.0001f);
    BOOST_CHECK_CLOSE(angleAtVertex({0, 0, 0}, {1, 0, 0}, {1, 0, 0}), .0f, 0.0001f);

}


BOOST_AUTO_TEST_SUITE_END()