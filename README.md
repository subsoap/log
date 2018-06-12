# Log
General purpose logging for Defold

## Installation
You can use Log in your own project by adding this project as a [Defold library dependency](http://www.defold.com/manuals/libraries/). Open your game.project file and in the dependencies field under project add:

	https://github.com/subsoap/log/archive/master.zip
  
Once added, you must require the main Lua module in your scripts via

```
local log = require("log.log")
```

Or require it globally in your main entrypoint so that all of your scripts can use Log without each needing to require it.

```
log = require("log.log")
```

## Usage

First set your appname. Your appname determines a relative OS directory for storing your app's logs.

```
log.set_appname("YourAppName")
```

You can then log information to logs based on levels. You can use a short or long form of the log function names.

```
log.c("This would be a critical log message.")
log.critical("This would also be a critical log message.")
```

Here is what the above lines would log to your log file. Note that it inclues the log level, timestamp, and script information (path and line number) of which script did the logging.

```
[CRIT  2018-06-12 00:21:10] /example/example.script:19: This would be a critical log message.
[CRIT  2018-06-12 00:21:10] /example/example.script:20: This would also be a critical log message.
```

There are muliple built in log levels. You are able to set the minimum log level so that any messages below that log level are not logged.

```
log.set_log_level(log.INFO) -- disable logging for all log levels below log.INFO
```

When you log a message you can include an optional tag. Tags can be used to whitelist (or blacklist) certain log information types. For example, you may only want to allow logging from one section of your game while you are doing debugging, you can disable all other log tags.

![Log](log_logo.png)