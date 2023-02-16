#pragma once

#include <opencv2/core.hpp>

#include <string>

/**
 * @brief Print the information about the matrix (size, channels and type).
 * @param message A message to print before the matrix info: the output is in the format "message: [RxC] ch: #channels type: CV_XXTCY"
 * @param m The matrix.
 */
void printMatInfo(const std::string& message, const cv::Mat& m);

/**
 * @brief Print the information about a matrix with the name given by variable name.
 */
#define PRINT_MAT_INFO(mat) printMatInfo(#mat, mat)

/**
 * @brief Return the matrix type in readable string format
 * @param m The matrix
 * @return A string with the matrix type in string format, e.g. "CV_8UC3"
 */
std::string getMatType(const cv::Mat& m);