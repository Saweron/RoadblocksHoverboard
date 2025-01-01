--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local components = require(ReplicatedStorage.Modules.Types.Components)
local interfaces = require(ReplicatedStorage.Modules.Types.Interfaces)

local GRAVITY_UP = Vector3.yAxis
local MAX_POLL_DISTANCE = 100
local DEFAULT_RAY_PARAMS = RaycastParams.new()
DEFAULT_RAY_PARAMS.IgnoreWater = false

local M = {}; local PT = {}; local MT = {__index = PT}

type class = {
	_castingFrom: PVInstance,
	_myRayParams: RaycastParams
} & components.groundSensor & interfaces.typedComponent

function M.create(
	castingFrom: PVInstance,
	useRayParams: RaycastParams?
) : components.groundSensor & interfaces.typedComponent

	local self = {
		_castingFrom = castingFrom,
		_myRayParams = useRayParams or DEFAULT_RAY_PARAMS
	} :: class

	return setmetatable(self, MT)
end

function PT.pollHeight(self: class)
	local result = workspace:Raycast(
		self._castingFrom:GetPivot(),
		-GRAVITY_UP * MAX_POLL_DISTANCE,
		self._myRayParams
	)
	return result.Distance
end

function PT.destroy(self: class) return end
function PT.getType(self: class) return components.groundSensor end

return M