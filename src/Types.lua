local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local t = require(ReplicatedStorage.Packages.t)

local IS_SERVER = RunService:IsServer()

return {
    RegisterRemote = function(remote)
        assert(t.union(
            t.instanceIsA("RemoteEvent"),
            t.instanceIsA("RemoteFunction")
        )(remote))
    end,

    AddRemoteEvent = function(name)
        assert(IS_SERVER, "AddRemoteEvent() can only be called on the server")
        assert(t.string(name))
    end,

    AddRemoteFunction = function(name)
        assert(IS_SERVER, "AddRemoteFunction() can only be called on the server")
        assert(t.string(name))
    end,

    GetRemoteEvent = function(name)
        assert(t.string(name))
    end,

    GetRemoteFunction = function(name)
        assert(t.string(name))
    end,

    WaitForRemoteEvent = function(name, timeout)
        assert(t.tuple(
            t.string,
            t.optional(t.number)
        )(name, timeout))
    end,

    WaitForRemoteFunction = function(name, timeout)
        assert(t.tuple(
            t.string,
            t.optional(t.number)
        )(name, timeout))
    end,
}
