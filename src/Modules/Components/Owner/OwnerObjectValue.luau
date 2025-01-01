--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local components = require(ReplicatedStorage.Modules.Types.Components)
local interfaces = require(ReplicatedStorage.Modules.Types.Interfaces)

local IS_CLIENT = RunService:IsClient()

local M = {}; local PT = {}; local MT = {__index = PT}

type class = {
	_myValue: ObjectValue
} & components.owner & interfaces.typedComponent

function M.create(
	from: ObjectValue
) : components.owner & interfaces.typedComponent

	local self = {
		_myValue = from
	} :: class

	return setmetatable(self, MT)
end

function PT.get(self: class) : Player?
	local value = self._myValue.Value
	if not value then return nil end
	if not value:IsA("Player") then return nil end
	return value
end

function PT.set(self: class, to: Player?)
	if IS_CLIENT then warn("cannot set owner on client"); return end
	self._myValue.Value = to
end

function PT.destroy(self: class) return end
function PT.getType(self: class) return components.owner end

return M