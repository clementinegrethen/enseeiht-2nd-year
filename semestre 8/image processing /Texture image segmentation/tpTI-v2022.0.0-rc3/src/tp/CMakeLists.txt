add_executable( kmeans kmeans.cpp ocv_utils.hpp ocv_utils.cpp)
add_executable( meanshift meanshift.cpp ocv_utils.hpp ocv_utils.cpp)
target_link_libraries( meanshift ${OpenCV_LIBS} )
target_link_libraries( kmeans ${OpenCV_LIBS} )

