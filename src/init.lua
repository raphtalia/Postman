local RunService = game:GetService("RunService")

local RemoteEvent = require(script.RemoteEvent)
local RemoteFunction = require(script.RemoteFunction)
local Types = require(script.Types)

local IS_SERVER = RunService:IsServer()
local IS_CLIENT = RunService:IsClient()

local NetworkService = {}
local NETWORK_SERVICE_METATABLE = {}
NETWORK_SERVICE_METATABLE.__index = NETWORK_SERVICE_METATABLE

function NetworkService.new()
    local self = setmetatable({
        _remotes = nil,

        Events = {},
        Functions = {},
    }, NETWORK_SERVICE_METATABLE)

    if IS_SERVER then
        local remotes = Instance.new("Folder")
        remotes.Name = "Remotes"
        remotes.Parent = script.Parent
        self._remotes = remotes

        return self
    elseif IS_CLIENT then
        self._remotes = script.Parent:WaitForChild("Remotes")

        for _,remote in ipairs(self._remotes:GetDescendants()) do
            if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
                self:RegisterRemote(remote)
            end
        end

        self._remotes.ChildAdded:Connect(function(remote)
            if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
                self:RegisterRemote(remote)
            end
        end)

        return self
    end
end

-- Registers a RemoteEvent Instance into an object
function NETWORK_SERVICE_METATABLE:RegisterRemote(remote)
    Types.RegisterRemote(remote)

    local name = remote.Name
    if remote:IsA("RemoteEvent") then
        remote = RemoteEvent.new(remote)
        self.Events[name] = remote
        return remote
    elseif remote:IsA("RemoteFunction") then
        remote = RemoteFunction.new(remote)
        self.Functions[name] = remote
        return remote
    end
end

function NETWORK_SERVICE_METATABLE:AddRemoteEvent(name)
    Types.AddRemoteEvent(name)

    local remote = RemoteEvent.new(name, self._remotes)
    self.Events[name] = remote
    return remote
end

function NETWORK_SERVICE_METATABLE:AddRemoteFunction(name)
    Types.AddRemoteFunction(name)

    local remote = RemoteFunction.new(name, self._remotes)
    self.Functions[name] = remote
    return remote
end

function NETWORK_SERVICE_METATABLE:GetRemoteEvent(name)
    Types.GetRemoteEvent(name)

    return self.Events[name]
end

function NETWORK_SERVICE_METATABLE:GetRemoteFunction(name)
    Types.GetRemoteFunction(name)

    return self.Functions[name]
end

function NETWORK_SERVICE_METATABLE:WaitForRemoteEvent(name, timeout)
    Types.WaitForRemoteEvent(name, timeout)

    timeout = timeout or 30

    local waitStart = os.clock()
    repeat
        task.wait()
        if os.clock() - waitStart > timeout then
            warn(("Waited %n seconds for remote %s"):format(name, timeout))
            break
        end
    until self.Events[name]

    return self.Events[name]
end

function NETWORK_SERVICE_METATABLE:WaitForRemoteFunction(name, timeout)
    Types.WaitForRemoteFunction(name, timeout)

    timeout = timeout or 30

    local waitStart = os.clock()
    repeat
        task.wait()
        if os.clock() - waitStart > timeout then
            warn(("Waited %n seconds for remote %s"):format(name, timeout))
            break
        end
    until self.Functions[name]

    return self.Functions[name]
end

return NetworkService.new()
