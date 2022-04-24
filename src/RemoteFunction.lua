local RunService = game:GetService("RunService")

local IS_SERVER = RunService:IsServer()
local IS_CLIENT = RunService:IsClient()

local RemoteFunction = {}
local REMOTE_FUNCTION_METATABLE = {}
REMOTE_FUNCTION_METATABLE.__index = REMOTE_FUNCTION_METATABLE

function RemoteFunction.new(...)
    local self = setmetatable({}, REMOTE_FUNCTION_METATABLE)

    local args = {...}
    if IS_SERVER then
        local remote = Instance.new("RemoteFunction")
        remote.Name = args[1]
        remote.Parent = args[2]
        self._remote = remote
    elseif IS_CLIENT then
        self._remote = args[1]
    end

    return self
end

function REMOTE_FUNCTION_METATABLE:Invoke(...)
    if IS_SERVER then
        local args = {...}
        return self._remote:InvokeClient(args[1], select(2, unpack(args)))
    elseif IS_CLIENT then
        return self._remote:InvokeServer(...)
    end

    return nil
end

function REMOTE_FUNCTION_METATABLE:Bind(callback)
    if IS_SERVER then
        self._remote.OnServerInvoke = callback
    elseif IS_CLIENT then
        self._remote.OnClientInvoke = callback
    end

    return self
end

return RemoteFunction
