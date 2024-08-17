--[[
	Возвращает функцию для метометода __index благодаря которой,
	индексироваться будут сразу несколько таблиц, вместо одной.
]]
local function multiIndex(...: { [any]: any } | (any, any) -> any): (any, any) -> any
	local indexables = { ... }
	return function(object: any, index: any): any
		for _, indexable in ipairs(indexables) do
			local v: any
			if type(indexable) == "function" then
				v = indexable(object, index)
			else
				v = indexable[index]
			end
			if v then
				return v
			end
		end
		return nil
	end
end

return multiIndex
