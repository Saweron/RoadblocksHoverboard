--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local components = require(ReplicatedStorage.Modules.Types.Components)
local interfaces = require(ReplicatedStorage.Modules.Types.Interfaces)

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

function PT.destroy(self: class) return end
function PT.getType(self: class) return components.owner end

return M