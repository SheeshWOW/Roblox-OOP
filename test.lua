--!strict

local function multiIndex(...: {[any]: any} | (any, any)->any): (any, any)->any
	local indexables = {...}
	return function(object: any, index: any): any
		for _, indexable in ipairs(indexables) do
			local v: any
			if type(indexable) == "function" then
				v = indexable(object, index)
			else
				v = indexable[index]
			end
			if v then return v end
		end
		return nil
	end
end

local tableA =  {a = 1}
local tableB = {b = 2}
local tableC =      {c = 3}


local tableAll = setmetatable({}, {__index = multiIndex(tableA, tableB, tableC)})

print(tableAll.a) -- 1
print(tableAll.b) -- 2
print(tableAll.c) -- 3