local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TestEZ = require(ReplicatedStorage.DevPackages.TestEZ)

local ObjectCache = script.Parent.Parent.Module

TestEZ.TestBootstrap:run({
    ObjectCache["init.spec"],
})