--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local components = require(ReplicatedStorage.Modules.Types.Components)
local interfaces = require(ReplicatedStorage.Modules.Types.Interfaces)

local M = {}; local PT = {}; local MT = {__index = PT}

type class = {
	_myHumanoid: interfaces.getset<Humanoid?>
} & components.groundSensor & interfaces.typedComponent

function M.create(
	usingHumanoid: interfaces.getset<Humanoid?>
) : components.groundSensor & interfaces.typedComponent

	local self = {
		_myHumanoid = usingHumanoid
	} :: class

	return setmetatable(self, MT)
end

function PT.pollMovement(self: class)
	local Humanoid = self._myHumanoid:get()
	if not Humanoid then return Vector2.zero end

	local d = Humanoid.MoveDirection
	return Vector2.new(d.X, d.Z)
end

function PT.destroy(self: class) return end
function PT.getType(self: class) return components.groundSensor end

return M
