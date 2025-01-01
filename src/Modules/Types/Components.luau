--!strict

local interfaces = require(script.Parent.Interfaces)

local index = 0
local function g()
	index +=1
	return index
end

local components = {}

components.hoverController =g()
export type hoverController = {

}

return components