#include "ocv_utils.hpp"

#include <iostream>
std::string getMatType(int number)
{
    // find type
    const int imgTypeInt = number % 8;
    std::string imgTypeString;

    switch(imgTypeInt)
    {
        case 0: imgTypeString = "8U"; break;
        case 1: imgTypeString = "8S"; break;
        case 2: imgTypeString = "16U"; break;
        case 3: imgTypeString = "16S"; break;
        case 4: imgTypeString = "32S"; break;
        case 5: imgTypeString = "32F"; break;
        case 6: imgTypeString = "64F"; break;
        default: break;
    }

    // find channel
    const int channel = (number / 8) + 1;

    std::stringstream type;
    type << "CV_" << imgTypeString << "C" << channel;

    return type.str();
}

void printMatInfo(const std::string& message, const cv::Mat& m)
{
    std::cout << message << ": " << m.size() << " ch: "<< m.channels() << " type: " << getMatType(m.type()) << std::endl;
}


std::string getMatType(const cv::Mat& m)
{
    return getMatType(m.type());
}