local Logger = {}
local LogPrefix = "<Camera>"

local LogMessages = require(script.LogMessages)

local function GetPrefixedMessage(message: string)
	return (LogPrefix .. " " .. message)
end

local function GetFormattedMessage(message: string, ...)
	return (message:format(...))
end

function Logger:LogError(message: string, ...)
	local logMessage = LogMessages[message] or message

	local formattedMessage = GetPrefixedMessage(GetFormattedMessage(logMessage, ...))
	error(formattedMessage, 0)
end

return Logger
