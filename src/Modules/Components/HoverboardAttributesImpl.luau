--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local components = require(ReplicatedStorage.Modules.Types.Components)
local interfaces = require(ReplicatedStorage.Modules.Types.Interfaces)
local getset = require(ReplicatedStorage.Modules.Classes.AttributeGetset).create

local M = {}; local PT = {}; local MT = {__index = PT}

type class = {} & components.hoverboardAttributes & interfaces.typedComponent

function M.create(
	From: Instance
) : components.hoverboardAttributes & interfaces.typedComponent

	local self = {
		maxSpeed = getset(From, "MaxSpeed", true),
		accelerationRate = getset(From, "AccelerationRate", true),
		heightResponsiveness = getset(From, "HeightResponsiveness", true),
		headingResponsiveness = getset(From, "HeadingResponsiveness", true),
		shouldFollowCamera = getset(From, "ShouldFollowCamera", true),
	} :: class

	return setmetatable(self, MT)
end

function PT.destroy(self: class) return end
function PT.getType(self: class) return components.hoverboardAttributes end

return M