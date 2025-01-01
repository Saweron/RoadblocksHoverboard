--!strict

local interfaces = require(script.Parent.Interfaces)

local index = 0
local function g()
	index +=1
	return index
end

local components = {}

components.owner =g()
export type owner = {
	get: (self: owner) -> (Player?),
	set: (self: owner, to: Player?) -> ()
}

components.hoverController =g()
export type hoverController = {
	setHeading: (self: hoverController, to: Vector3) -> (),
	setHeight: (self: hoverController, to: number) -> (),
}

components.inputSensor =g()
export type inputSensor = {
	pollMovement: (self: inputSensor) -> (Vector2)
}

components.groundSensor =g()
export type groundSensor = {
	pollHeight: (self: groundSensor) -> (number)
}

components.hoverboardAttributes =g()
export type hoverboardAttributes = {
	maxSpeed: interfaces.getset<number>,
	accelerationRate: interfaces.getset<number>,

	heightResponsiveness: interfaces.getset<number>,
	headingResponsiveness: interfaces.getset<number>,

	shouldFollowCamera: interfaces.getset<boolean>,
}

return components