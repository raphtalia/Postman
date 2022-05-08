local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Postman = require(ReplicatedStorage.Packages.Postman)

local event = Postman.addRemoteEvent("event")
local func = Postman.addRemoteFunction("func")

event:Connect(function(player, msg)
    print(("Message from %s: %s"):format(player.Name, msg))
end)

func:Bind(function()
    return "Hello from server!"
end)
