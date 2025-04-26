#include "utils/logger.h"
#include <iostream>

namespace spotitml {

std::function<void(Logger::Level, const std::string&)> Logger::mCallback = Logger::defaultLog;

void Logger::setLogCallback(std::function<void(Level, const std::string&)> callback) {
    mCallback = callback ? callback : defaultLog;
}

void Logger::log(Level level, const std::string& message) {
    mCallback(level, message);
}

void Logger::defaultLog(Level level, const std::string& message) {
    const char* levelStr;
    switch (level) {
        case Level::DEBUG:   levelStr = "DEBUG"; break;
        case Level::INFO:    levelStr = "INFO"; break;
        case Level::WARNING: levelStr = "WARNING"; break;
        case Level::ERROR:   levelStr = "ERROR"; break;
    }
    
    std::cerr << "[" << levelStr << "] " << message << std::endl;
}