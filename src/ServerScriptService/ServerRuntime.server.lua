local ReplicatedStorage = game.ReplicatedStorage
local Packages = ReplicatedStorage.Packages

local Greeter = require(ReplicatedStorage.Greeter)
local multiIndex = require(ReplicatedStorage.MultiIndex)
local Class = require(ReplicatedStorage.Class)

local Message = Greeter()
local __indexFunction = multiIndex({ abc = 2 }, { etc = 777 })

print(Message, { testMessage = "HelloWorld!" })

local newObject = Class.new("Test")

newObject:PrintInfo(true)
newObject:Destroy()
