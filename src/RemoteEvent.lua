local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local IS_SERVER = RunService:IsServer()
local IS_CLIENT = RunService:IsClient()

local RemoteEvent = {}
local REMOTE_EVENT_METATABLE = {}
REMOTE_EVENT_METATABLE.__index = REMOTE_EVENT_METATABLE

function RemoteEvent.new(...)
    local self = setmetatable({}, REMOTE_EVENT_METATABLE)

    local args = {...}
    if IS_SERVER then
        local remote = Instance.new("RemoteEvent")
        remote.Name = args[1]
        remote.Parent = args[2]
        self._remote = remote
    elseif IS_CLIENT then
        self._remote = args[1]
    end

    return self
end

function REMOTE_EVENT_METATABLE:Fire(...)
    if IS_SERVER then
        local args = {...}
        local players = args[1]

        args = {select(2, unpack(args))}
        players = type(players) ~= "table" and {players} or players

        for _,player in ipairs(players) do
            self._remote:FireClient(player, unpack(args))
        end
    elseif IS_CLIENT then
        self._remote:FireServer(...)
    end

    return self
end

function REMOTE_EVENT_METATABLE:FireNearby(pos: Vector3, radius: number, ...)
    assert(IS_SERVER, "This method can only be used from the server")

    for _,player in ipairs(Players:GetPlayers()) do
        local playerPos = player.Character and player.Character.HumanoidRootPart and player.Character.HumanoidRootPart.Position

        if playerPos then
            if (playerPos - pos).Magnitude < radius then
                self._remote:FireClient(player, ...)
            end
        end
    end

    return self
end

function REMOTE_EVENT_METATABLE:FireAll(...)
    assert(IS_SERVER, "This method can only be used from the server")

    self._remote:FireAllClients(...)

    return self
end

function REMOTE_EVENT_METATABLE:Connect(handler): RBXScriptConnection
    if IS_SERVER then
        return self._remote.OnServerEvent:Connect(handler)
    elseif IS_CLIENT then
        return self._remote.OnClientEvent:Connect(handler)
    end
end

return RemoteEvent
