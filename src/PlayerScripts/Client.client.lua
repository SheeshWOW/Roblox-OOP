local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local CharacterController = require(ReplicatedStorage.CharacterController)
local Camera = CharacterController.Camera

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

local Camera3Static = Camera.Camera3

local CameraController = Camera3Static.new(HumanoidRootPart)

local CameraOffset = CFrame.new(2, 2.2, 4)
--[[
    RShoulder Offset: CFrame.new(2, 2.2, 4)
    3d Person Offset: CFrame.new(0, 5.5, 10) * CFrame.Angles(-math.rad(20), 0, 0)
]]

CameraController:SetCameraOffset(CameraOffset)

RunService:BindToRenderStep("UpdateCamera3", Enum.RenderPriority.Camera.Value, function(deltaTime)
	CameraController:Update(deltaTime)
end)
