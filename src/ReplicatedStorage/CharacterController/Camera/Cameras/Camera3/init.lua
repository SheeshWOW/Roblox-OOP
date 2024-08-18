-- Camera3.lua
-- Made by SnerMorY

-- class Camera3 {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Root = script.Parent.Parent
local AbstractCamera = require(Root.AbstractCamera)
local Logger = require(Root.Logger)

local Packages = ReplicatedStorage.Packages
local Promise = require(Packages.Promise)
local Janitor = require(Packages.Janitor)

local Utilities = Root.Utilities
local MultiIndex = require(Utilities.MultiIndex)

local Camera3Static = {}
setmetatable(Camera3Static, { __index = AbstractCamera })

local Camera3PublicInstanceMethods = setmetatable({}, { __index = AbstractCamera.inheritables.publicMethods })
local Camera3ProtectedInstanceMethods = setmetatable({}, { __index = AbstractCamera.inheritables.protectedMethods })
local Camera3PrivateInstanceMethods = {}

Camera3Static.inheritables = {
	-- publicMethods = setmetatable({}, { __index = Camera3PublicInstanceMethods }),
	-- protectedMethods = setmetatable({}, { __index = Camera3ProtectedInstanceMethods }),
}

export type Camera3PublicInstanceVariables = AbstractCamera.CameraPublicInstanceVariables & {}
export type Camera3ProtectedInstanceVariables = AbstractCamera.CameraProtectedInstanceVariables & {
	CameraOffset: CFrame,
	Damping: number,
}
type Camera3PrivateInstanceVariables = {}

type Camera3InstanceVariables =
	Camera3PublicInstanceVariables
	& Camera3ProtectedInstanceVariables
	& Camera3PrivateInstanceVariables

type Camera3PublicInstanceMethods = typeof(Camera3PublicInstanceMethods)
type Camera3ProtectedInstanceMethods = typeof(Camera3ProtectedInstanceMethods)
type Camera3PrivateInstanceMethods = typeof(Camera3PrivateInstanceMethods)

type Camera3InstanceMethods =
	Camera3PublicInstanceMethods
	& Camera3ProtectedInstanceMethods
	& Camera3PrivateInstanceMethods

type Camera3 = Camera3PublicInstanceMethods & Camera3PublicInstanceVariables
type Camera3Internal = Camera3InstanceVariables & Camera3InstanceMethods

--[[
	Конструктор класса `Camera3`.
	Создает камеру от третьего лица.
]]
function Camera3Static.new(Host: Model | BasePart): Camera3
	if Host:IsA("Model") then
		Host = Host.PrimaryPart :: BasePart
	end

	local self = (
		setmetatable({} :: Camera3InstanceVariables, {
			__index = MultiIndex(
				Camera3PublicInstanceMethods,
				Camera3ProtectedInstanceMethods,
				Camera3PrivateInstanceMethods
			),
			__tostring = function(camera: Camera3)
				return camera.Name
			end,
		}) :: any
	) :: Camera3Internal

	self.CurrentCamera = workspace.CurrentCamera :: Camera
	self.Host = Host :: BasePart
	self.Name = "Camera3"

	self.CameraOffset = CFrame.identity

	self.IsActive = false
	self.InstanceJanitor = Janitor.new()
	self.ConnectionsJanitor = Janitor.new()

	self.InstanceJanitor:Add(self.ConnectionsJanitor, "Destroy")

	return self :: Camera3
end

--[[
	Setter. Устанавливает отступ камеры от `Host`'a.
]]
function Camera3PublicInstanceMethods:SetCameraOffset(cameraOffset: CFrame)
	local self = (self :: any) :: Camera3Internal

	if typeof(cameraOffset) ~= "CFrame" then
		return
	end

	self.CameraOffset = cameraOffset
end

--[[
	Getter. Возвращает начальную точку камеры с которой она начинается.
]]
function Camera3PublicInstanceMethods:GetRawStartCameraCFrame(): CFrame
	local self = (self :: any) :: Camera3Internal

	-- Settings
	local Host = self.Host
	if not Host then
		return CFrame.identity
	end
	local deltaX, deltaY = 0, 0

	return CFrame.new(Host.CFrame.Position)
		* CFrame.Angles(0, math.rad(deltaX), 0)
		* CFrame.Angles(math.rad(deltaY), 0, 0)
end

--[[
	Getter. Возвращает конечную точку камеры к которой она стремится.
]]
function Camera3PublicInstanceMethods:GetRawGoalCameraCFrame(): CFrame
	local self = (self :: any) :: Camera3Internal

	-- Settings
	local CameraOffset = self.CameraOffset

	local StartCameraCFrame = self:GetRawStartCameraCFrame()
	return StartCameraCFrame:ToWorldSpace(CameraOffset) * CFrame.identity
end

--[[
	Обновление камеры с помощью вызова метода в RunService (Enum.RenderPriority.Camera).
]]
function Camera3PublicInstanceMethods:Update(deltaTime: number)
	local self = (self :: any) :: Camera3Internal

	local Host = self.Host
	local Camera = self.CurrentCamera
	if not Host or not Camera then
		return
	end

	-- Settings
	local CameraOffset = self.CameraOffset

	-- temp variables
	local deltaX, deltaY = 0, 0

	local StartCF = self:GetRawStartCameraCFrame()
	local GoalCF = self:GetRawGoalCameraCFrame()
	local CameraDirection = GoalCF:ToWorldSpace(CFrame.new(0, 0, -100000))

	local OutputCameraCFrame = CFrame.lookAt(GoalCF.Position, CameraDirection.Position)

	Camera.CFrame = OutputCameraCFrame
end

--[[
	Уничтожение объекта и очистка всех соединений.
]]
function Camera3PublicInstanceMethods:Destroy()
	local self = (self :: any) :: Camera3Internal

	-- Destroying all indexes
	self:__cleanupJanitor()
	self.InstanceJanitor:Destroy()

	print(self, "Destroyed!")
end

--[[
	Очищаем все данные и останавливаем соединения. Метод для очистки `Janitor`'a.
]]
function Camera3PrivateInstanceMethods:__cleanupJanitor()
	local self = (self :: any) :: Camera3Internal

	self.InstanceJanitor:Cleanup()

	print("Janitor has cleaned up!")
end

return Camera3Static
