local RunService = game:GetService("RunService")

local Promise = require(script.Parent.Promise)
local Signal = require(script.Parent.Signal)
local RemoteEvent = require(script.RemoteEvent)
local RemoteFunction = require(script.RemoteFunction)
local Types = require(script.Types)

local IS_SERVER = RunService:IsServer()
local IS_CLIENT = RunService:IsClient()

local remotes
local events = {}
local functions = {}
local Postman = {
    RemoteEventAdded = Signal.new(),
    RemoteFunctionAdded = Signal.new(),
}

-- Registers a RemoteEvent Instance into an object
local function registerRemote(remote)
    Types.RegisterRemote(remote)

    local name = remote.Name
    if remote:IsA("RemoteEvent") then
        remote = RemoteEvent.new(remote)
        events[name] = remote
        Postman.RemoteEventAdded:Fire(name, remote)
        return remote
    elseif remote:IsA("RemoteFunction") then
        remote = RemoteFunction.new(remote)
        functions[name] = remote
        Postman.RemoteFunctionAdded:Fire(name, remote)
        return remote
    end
end

if IS_SERVER then
    remotes = Instance.new("Folder")
    remotes.Name = "Remotes"
    remotes.Parent = script.Parent
elseif IS_CLIENT then
    remotes = script.Parent:WaitForChild("Remotes")

    for _,remote in ipairs(remotes:GetDescendants()) do
        if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
            registerRemote(remote)
        end
    end

    remotes.ChildAdded:Connect(function(remote)
        if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
            registerRemote(remote)
        end
    end)
end

function Postman.addRemoteEvent(name)
    Types.AddRemoteEvent(name)

    local remote = RemoteEvent.new(name, remotes)
    events[name] = remote
    return remote
end

function Postman.addRemoteFunction(name)
    Types.AddRemoteFunction(name)

    local remote = RemoteFunction.new(name, remotes)
    functions[name] = remote
    return remote
end

function Postman.getRemoteEvent(name)
    Types.GetRemoteEvent(name)

    return events[name]
end

function Postman.getRemoteFunction(name)
    Types.GetRemoteFunction(name)

    return functions[name]
end

function Postman.waitForRemoteEvent(name, timeout)
    Types.WaitForRemoteEvent(name, timeout)

    timeout = timeout or 30

    return Promise.new(function(resolve)
        local waitStart = os.clock()
        repeat
            task.wait()
            if os.clock() - waitStart > timeout then
                warn(("Waited %n seconds for remote %s"):format(name, timeout))
                break
            end
        until events[name]

        resolve(events[name])
    end)
end

function Postman.waitForRemoteFunction(name, timeout)
    Types.WaitForRemoteFunction(name, timeout)

    timeout = timeout or 30

    return Promise.new(function(resolve)
        local waitStart = os.clock()
        repeat
            task.wait()
            if os.clock() - waitStart > timeout then
                warn(("Waited %n seconds for remote %s"):format(name, timeout))
                break
            end
        until functions[name]

        resolve(functions[name])
    end)
end

return Postman
