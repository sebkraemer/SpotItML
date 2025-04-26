#pragma once

#include <functional>
#include <string>

namespace spotitml {

class Logger {
public:
    enum class Level {
        DEBUG,
        INFO,
        WARNING,
        ERROR
    };

    static void setLogCallback(std::function<void(Level, const std::string&)> callback);
    static void log(Level level, const std::string& message);

private:
    static std::function<void(Level, const std::string&)> mCallback;
    static void defaultLog(Level level, const std::string& message);
};

} // namespace spotitml