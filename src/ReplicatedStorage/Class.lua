local ReplicatedStorage = game.ReplicatedStorage
local Packages = ReplicatedStorage.Packages

local multiIndex = require(ReplicatedStorage.MultiIndex)
local Janitor = require(Packages.Janitor)

local ExampleStatic = {}

local ExamplePublicInstanceMethods = {}
local ExampleProtectedInstanceMethods = {}
local ExamplePrivateInstanceMethods = {}

ExampleStatic.inheritables = {
	publicMethods = setmetatable({}, { __index = ExamplePublicInstanceMethods }),
	protectedMethods = setmetatable({}, { __index = ExampleProtectedInstanceMethods }),
}

export type ExamplePublicInstanceVariables = {
	Name: string,
}
export type ExampleProtectedInstanceVariables = {
	Janitor: Janitor.Janitor,
}
type ExamplePrivateInstanceVariables = {
	Message: string,
}

type ExampleInstanceVariables =
	ExamplePublicInstanceVariables
	--[[ Added for convenience --]]
	& ExampleProtectedInstanceVariables
	--[[    in constructor.    --]]
	& ExamplePrivateInstanceVariables

type ExamplePublicInstanceMethods = typeof(ExamplePublicInstanceMethods)
type ExampleProtectedInstanceMethods = typeof(ExampleProtectedInstanceMethods)
type ExamplePrivateInstanceMethods = typeof(ExamplePrivateInstanceMethods)

type Example = ExamplePublicInstanceMethods & ExamplePublicInstanceVariables
type ExampleProtected = Example & ExampleProtectedInstanceMethods & ExampleProtectedInstanceVariables
type ExamplePrivate = ExampleProtected & ExamplePrivateInstanceMethods & ExamplePrivateInstanceVariables

type ExampleInternal =
	ExampleInstanceVariables
	& ExamplePublicInstanceMethods
	& ExampleProtectedInstanceMethods
	& ExamplePrivateInstanceMethods

--[[
    Создантие экземпляра класса `Example`.
    Статический метод
]]
function ExampleStatic.new(instanceName: string): Example
	-- Set the metatable to make it index the instance
	-- method tables. Otherwise it will believe that
	-- it has these methods despite not being able
	-- to index them.

	local self = (
		setmetatable({} :: ExampleInstanceVariables, {
			__index = multiIndex(
				ExamplePublicInstanceMethods,
				ExampleProtectedInstanceMethods,
				ExamplePrivateInstanceMethods
			),
		}) :: any
	) :: ExampleInternal

	self.Name = instanceName
	self.Message = self:__GetInfoMessage()

	self.Janitor = Janitor.new()

	return self :: Example
	-- And finally cast the whole thing to an
	-- Example for autocomplete convenience.
end

function ExamplePublicInstanceMethods:PrintInfo(useWarn: boolean)
	local self = (self :: any) :: ExampleInternal
	local useWarn = useWarn or false

	local message = self:__GetInfoMessage()

	if useWarn then
		warn(message)
	else
		print(message)
	end
end

--[[
Уничтожение объекта и очистка всех соединений.
]]
function ExamplePublicInstanceMethods:Destroy()
	local self = (self :: any) :: ExampleInternal
	print("Destroying!")
	self:__cleanupJanitor()
end

--[[
Возвращает сообщение, хранящее информации об объекте.
]]
function ExampleProtectedInstanceMethods:__GetInfoMessage(): string
	return `Information:\nName: {self.Name}\n`
end

--[[
Очищаем все данные и останавливаем соединения. Метод для очистки `Janitor`'a.
]]
function ExamplePrivateInstanceMethods:__cleanupJanitor()
	local self = (self :: any) :: ExampleInternal

	print("Janitor has cleaned up!")
end

return ExampleStatic
