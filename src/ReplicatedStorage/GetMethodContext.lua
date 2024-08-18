return function(level: number)
	local _, f, n = pcall(function()
		local f = debug.info(level, "f")
		local n = debug.info(level, "n")

		return f, n
	end)

	return f, n
end
