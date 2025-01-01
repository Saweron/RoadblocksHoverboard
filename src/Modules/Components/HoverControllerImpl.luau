--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local components = require(ReplicatedStorage.Modules.Types.Components)
local interfaces = require(ReplicatedStorage.Modules.Types.Interfaces)

local DEFAULT_HEADING = Vector3.xAxis
local DEFAULT_HEIGHT = 1
local GRAVITY_UP = Vector3.yAxis

local M = {}; local PT = {}; local MT = {__index = PT}

type class = {
	_desiredHeading: Vector3,
	_desiredHeight: number,

	_myGroundSensor: components.groundSensor,
	_myAttributes: components.hoverboardAttributes,
	_myPart: BasePart,
	_myForce: VectorForce,
	_myAlign: AlignOrientation,

	_connection: RBXScriptConnection,

	_update: (self: class, dt: number) -> ()
} & components.hoverController & interfaces.typedComponent

function M.create(
	groundSensor: components.groundSensor,
	attributes: components.hoverboardAttributes,
	observingPart: BasePart,
	UsingForce: VectorForce,
	UsingAlign: AlignOrientation
): components.hoverController & interfaces.typedComponent

	local self = {
		_desiredHeading = DEFAULT_HEADING,
		_desiredHeight = DEFAULT_HEIGHT,
		_myGroundSensor = groundSensor,
		_myAttributes = attributes,
		_myPart = observingPart,
		_myForce = UsingForce,
		_myAlign = UsingAlign
	} :: class

	self._connection = RunService.Heartbeat:Connect(function(dt)
		self:_update(dt)
	end)

	return setmetatable(self, MT)
end

function PT._update(self: class, dt: number)
	local currentHeight = self._myGroundSensor:pollHeight()
	local currentMass = self._myPart.AssemblyMass
	local currentVelocity = self._myPart.AssemblyLinearVelocity

	local antigravityForce =
		GRAVITY_UP *
		(currentMass * workspace.Gravity)

	local hoverUpForce = 
		GRAVITY_UP *
		(currentHeight - self._desiredHeight) *
		self._myAttributes.heightResponsiveness:get()

	local headingForce = 
		(currentVelocity - self._desiredHeading) *
		self._myAttributes.headingResponsiveness:get()

	local netForce = antigravityForce + hoverUpForce + headingForce
	self._myForce.Force = netForce

	local headingDirectionCF = CFrame.lookAt(
		Vector3.zero,
		self._desiredHeading,
		GRAVITY_UP
	)
	self._myAlign.CFrame = headingDirectionCF
end

function PT.setHeading(self: class, to: Vector3) self._desiredHeading = to end
function PT.setHeight(self: class, to: number) self._desiredHeight = to end

function PT.destroy(self: class)
	self._connection:Disconnect()
end

function PT.getType(self: class) return components.hoverController end

return M