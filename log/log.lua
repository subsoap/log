local M = {}

M.appname = "DefoldLog"
M.print = false
M.verbose = false
M.initialized = false
M.logging = true
M.logging_filename = "app.log"
M.sysinfo = sys.get_sys_info()
M.callback_function = nil
M.use_date_for_filename = true
M.use_tag_whitelist = false

M.tag_whitelist = 
{
	["none"] = true
}

M.NONE = 0
M.TRACE = 10
M.DEBUG = 20
M.INFO = 30
M.WARNING = 40
M.ERROR = 50
M.CRITICAL = 60
M.logging_level = M.DEBUG

M.log_level_names = 
	{
	[0] = "NONE  ",
	[10] = "TRACE ", 
	[20] = "DEBUG ",
	[30] = "INFO  ",
	[40] = "WARN  ",
	[50] = "ERROR ",
	[60] = "CRIT  "
	}


function M.add_to_whitelist(tag, state)
	M.tag_whitelist[tag] = state
end
	


-- Sets the minimum log level to log, default is log.DEBUG
function M.set_level(level)
	M.logging_level = level
end

-- TRACE
-- Meant for each step of a function, enable trace to have super granular log information
-- Show events and information leading up to a failure
-- Logs a tremendous amount of information if setup
function M.t(message, tag)
	M.trace(message, tag)
end

function M.trace(message, tag)
	local level = M.TRACE
	M.save_log_line(message, level, tag)
end

-- DEBUG
-- Meant for logging as much related information as possible when an error occurs
-- Show why a failure occurs
function M.d(message, tag)
	M.debug(message, tag)
end

function M.debug(message, tag)
	local level = M.DEBUG
	M.save_log_line(message, level, tag)	
end

-- INFO
function M.i(message, tag)
	M.info(message, tag)
end

function M.info(message, tag)
	local level = M.INFO
	M.save_log_line(message, level, tag)		
end

-- WARNING
function M.w(message, tag)
	M.warning(message, tag)
end

function M.warning(message, tag)
	local level = M.WARNING
	M.save_log_line(message, level, tag)		
end

-- ERROR
function M.e(message, tag)
	M.error(message, tag)
end

function M.error(message, tag)
	local level = M.ERROR
	M.save_log_line(message, level, tag)		
end

-- CRITICAL
function M.c(message, tag)
	M.critical(message, tag)
end

function M.critical(message, tag)
	local level = M.CRITICAL
	M.save_log_line(message, level, tag)		
end



function M.save_log_line(line, level, tag)
	level = level or M.NONE
	if level < M.logging_level then return false end

	tag = tag or "none"
	if M.use_tag_whitelist then
		if M.tag_whitelist[tag] ~= true then
			return false
		end
	end	
	
	local level_string = M.log_level_names[level]
	
	local path = M.get_logging_path()
	local log = io.open(path, "a")
	local timestamp = os.time()
	local timestamp_string = os.date('%Y-%m-%d %H:%M:%S', timestamp)

	local head = "[" .. level_string .. timestamp_string .. "]"
	local body = ""
	
	if debug then
		local info = debug.getinfo(2, "Sl") -- https://www.lua.org/pil/23.1.html
		local short_src = info.short_src
		local line_number = info.currentline		
		body = short_src .. ":" .. line_number .. ":"
	end

	local complete_line = head .. " " .. body .. " " .. line
	if M.print == true then print(complete_line) end
	
	log:write(complete_line, "\n")
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
	if M.appname == "DefoldLog" then
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