local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Postman = require(ReplicatedStorage.Packages.Postman)

local event = Postman.waitForRemoteEvent("event"):expect()
local func = Postman.waitForRemoteFunction("func"):expect()

event:Fire("Hello from client!")

print(func:Invoke())
