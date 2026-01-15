--< Written by: Christopher Gholmieh
--< Variables (Assignment):

--< Colors:
local Colors = {
	--< Information:
	INFORMATION = "\27[32m";

	--< Warning:
	WARNING = "\27[33m";

	--< Error:
	ERROR = "\27[31m";

	--< Reset:
	RESET = "\27[0m";
}

--< Logger:
local Logger = {}

--< Functions:
function Logger.collect_timestamp()
	return os.date("%Y-%m-%d %H:%M:%S")
end

function Logger.log_function(level, color, message)
	--< Variables (Assignment):
	--< Timestamp:
	local timestamp = Logger.collect_timestamp()

	--< Message:
	message = tostring(message)

	--< Logger:
	print(string.format(
		--< Format:
		"%s[%s] [%s]%s: %s",

		--< Color:
		color,

		--< Timestamp:
		timestamp,

		--< Level:
		level,

		--< Reset:
		Colors.RESET,

		--< Message:
		message
	))
end

function Logger.log_information(message)
	Logger.log_function("INFORMATION", Colors.INFORMATION, message)
end

function Logger.log_warning(message)
	Logger.log_function("WARNING", Colors.WARNING, message)
end

function Logger.log_error(message)
	Logger.log_function("ERROR", Colors.ERROR, message)
end

Logger.format = string.format

--< Logger:
return Logger
