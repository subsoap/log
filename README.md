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

There is an optional dependency for LFS which is currently required if you would like to be able to auto-prune old log files. LFS is a native extension so could add to build time if you are not already using a native extension. This can be ignored if you don't care about auto-pruning of old log files.

	https://github.com/britzl/defold-lfs

	https://github.com/britzl/defold-lfs/archive/master.zip

## Usage

If you wish to have log lines be printed to the Defold console you must toggle console printing in your main file. Otherwise log lines will only be added to the log files.

```
log.toggle_print()
```

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

The available builtin log levels are from lowest to highest:

```
log.t(message, tag)
log.trace(message, tag)
log.TRACE = 10

log.d(message, tag)
log.debug(message, tag)
log.DEBUG = 20

log.i(message, tag)
log.info(message, tag)
log.INFO = 30

log.w(message, tag)
log.warning(message, tag)
log.WARNING = 40

log.e(message, tag)
log.error(message, tag)
log.ERROR = 50

log.c(message, tag)
log.critical(message, tag)
log.CRITICAL = 60
```

If you save a log line directly without using a log level function you can manually specifiy the log level. The debug_level should be left to be nil or 0 if log.save_log_line is called directly.

```
log.save_log_line(line, level, tag, debug_level)
```

When you log a message you can include an optional tag. Tags can be used to whitelist (or blacklist) certain log information types. For example, you may only want to allow logging from one section of your game while you are doing debugging, you can disable all other log tags.

To enable the tag whitelist and add a tag to the whitelist use

```
log.use_tag_whitelist = false
log.add_to_whitelist(tag, state)
```

You can also modify the table holding the whitelist data directly.

```
log.tag_whitelist = 
{
	["none"] = false,
	["msg_proxy"] = true
}
```

By default, all logging is disabled when you bundle a release build. To force logging to continue in release builds then you must set this value to false

```
log.disable_logging_for_release = false
```

By default, dates are used for log filenames. If you wish to store logs within a single file then disable using dates for filenames.

```
log.use_date_for_filename = false
```

You can change the default dateless log filename too.

```
log.logging_filename = "app.log"
```

You can manually disable all logging with

```
log.logging = false
```

You can delete old log files (such as on the init of your main entrypoint) based on the number of days you wish to keep logs around. This requires the LFS extension to be included (for now). This function will only delete logs which match the pattern of NNNN-NN-NN.log or it will not delete. If you don't set the number of days then it will default to log.delete_old_logs_days which by default is 10 days.

```
log.delete_old_logs(days)
```

![Log](log_logo.png)