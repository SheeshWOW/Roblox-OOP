-- Camera.lua
-- Made by SnerMorY

-- abstract class Camera {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Janitor = require(Packages.Janitor)

local CameraStatic = {}

local CameraPublicInstanceMethods = {}
local CameraProtectedInstanceMethods = {}
local CameraPrivateInstanceMethods = {}

CameraStatic.inheritables = {
	publicMethods = setmetatable({}, { __index = CameraPublicInstanceMethods }),
	protectedMethods = setmetatable({}, { __index = CameraProtectedInstanceMethods }),
}

export type CameraPublicInstanceVariables = {
	Name: string,
	IsActive: boolean,
}
export type CameraProtectedInstanceVariables = {
	CurrentCamera: Camera,
	Host: BasePart,

	InstanceJanitor: Janitor.Janitor,
	ConnectionsJanitor: Janitor.Janitor,
}
type CameraPrivateInstanceVariables = {}

type CameraInstanceVariables =
	CameraPublicInstanceVariables
	& CameraProtectedInstanceVariables
	& CameraPrivateInstanceVariables

type CameraPublicInstanceMethods = typeof(CameraPublicInstanceMethods)
type CameraProtectedInstanceMethods = typeof(CameraProtectedInstanceMethods)
type CameraPrivateInstanceMethods = typeof(CameraPrivateInstanceMethods)

type CameraInstanceMethods = CameraPublicInstanceMethods & CameraProtectedInstanceMethods & CameraPrivateInstanceMethods

type AbstractCamera = CameraPublicInstanceMethods & CameraPublicInstanceVariables
type CameraInternal = CameraInstanceVariables & CameraInstanceMethods

--[[
    Создантие экземпляра класса `Camera`.
    Прототип метода
]]
function CameraStatic.new(instanceName: string): AbstractCamera end

--[[
	Обновление камеры с помощью вызова метода в RunServices.
	Прототип метода.
]]
function CameraPublicInstanceMethods:Update(deltaTime: number)
	print("Update camera.", deltaTime)
end

--[[
	Уничтожение объекта и очистка всех соединений.
]]
function CameraPublicInstanceMethods:Destroy()
	local self = (self :: any) :: CameraInternal

	-- Destroying all indexes
	self:__cleanupJanitor()
	self.InstanceJanitor:Destroy()

	print(self, "Destroyed!")
end

--[[
	Очищаем все данные и останавливаем соединения. Метод для очистки `Janitor`'a.
]]
function CameraPrivateInstanceMethods:__cleanupJanitor()
	local self = (self :: any) :: CameraInternal

	self.InstanceJanitor:Cleanup()

	print("Janitor has cleaned up!")
end

return CameraStatic
