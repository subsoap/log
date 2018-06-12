local M = {}

M.appname = "Log"
M.print = false
M.verbose = false
M.initialized = false
M.logging = true
M.logging_filename = "logging.log"
M.sysinfo = sys.get_sys_info()
M.callback_function = nil
M.include_timestamp = true
M.use_date_for_filename = true

M.NONE = 0
M.TRACE = 10
M.DEBUG = 20
M.INFO = 30
M.WARNING = 40
M.ERROR = 50
M.CRITICAL = 60
M.logging_level = M.DEBUG

-- Sets the minimum log level to log, default is log.DEBUG
function M.level(level)
end

-- TRACE
-- Meant for each step of a function, enable trace to have super granular log information
-- Show events and information leading up to a failure
-- Logs a tremendous amount of information if setup
function M.t(...)
end

function M.trace(...)
end

-- DEBUG
-- Meant for logging as much related information as possible when an error occurs
-- Show why a failure occurs
function M.d(...)
end

function M.debug(...)
end

-- INFO
function M.i(...)
end

function M.info(...)
end

-- WARNING
function M.w(...)
end

function M.warning(...)
end

-- ERROR
function M.e(...)
end

function M.error(...)
end

-- CRITICAL
function M.c(...)
end

function M.critical(...)
end



function M.save_log_line(line)
	
	local path = M.get_logging_path()
	local log = io.open(path, "a")
	if M.include_timestamp then
		local timestamp = os.time()
		log:write(os.date('%Y-%m-%d %H:%M:%S', timestamp) .. " (" .. timestamp .. ")", "\n")
	end
	log:write(line, "\n")
	io.close(log)
	if M.verbose then print("Log: log.save_log_line - Log written to " .. path) end	
end

function M.set_appname(appname)
	-- if you don't want appname filtered then set it directly
	-- log.appname = "whatever"
	appname = appname:gsub('%S%W','')
	M.appname = appname
end

function M.toggle_print()
	if M.print then
		M.print = false
	else
		M.print = true
	end
end

function M.toggle_verbose()
	if M.verbose then
		M.verbose = false
	else
		M.verbose = true
	end
end

function M.toggle_logging()
	if M.logging then
		M.logging = false
	else
		M.logging = true
	end
end

local function appname_check()
	if M.appname == "Log" then
		print("Log: You need to set a custom appname with log.set_appname(appname)")
	end
end

function M.get_logging_path()
	appname_check()
	if M.use_date_for_filename then
		local timestamp = os.time()
		M.logging_filename = os.date('%Y-%m-%d', ts) .. ".log"
	end
	if M.sysinfo.system_name == "Linux" then
		-- For Linux we must modify the default path to make Linux users happy
		local appname = "config/" .. tostring(M.appname)
		return sys.get_save_file(appname, M.logging_filename)
	end
	return sys.get_save_file(M.appname, M.logging_filename)
end

return M