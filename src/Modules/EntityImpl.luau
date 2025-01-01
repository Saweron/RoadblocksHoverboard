--!strict

local interfaces = require(script.Parent.Types.Interfaces)

local function combineTable<a, b>(t1: {a}, t2: {b}) : {a | b}
	local combined: {a | b} = {}

	for _, item in ipairs(t1) do
		table.insert(combined, item)
	end

	for _, item in ipairs(t2) do
		table.insert(combined, item)
	end

	return combined
end

local M = {}; local PT = {}; local MT={__index=PT}

type class = {
	_myAnonymous: {interfaces.component},
	_myComponents: {[number]: {[interfaces.typedComponent] : boolean}}
} & interfaces.entity

function M.create() : interfaces.entity
	local self = {
		_myAnonymous = {},
		_myComponents = {}
	} :: class
	
	return setmetatable(self, MT)
end

function PT.addAnonymous(self: class, component: interfaces.component)
	table.insert(self._myAnonymous, component)
	component._myEntity = self
	return self
end

function PT.addTyped(self: class, component: interfaces.typedComponent)
	local cType = component:getType()
	local ctyped = self._myComponents[cType]
	if not ctyped then 
		local newCtyped = {}
		self._myComponents[cType] = newCtyped
		ctyped = newCtyped
	end
	
	ctyped[component] = true
	component._myEntity = self
	return self
end

function PT.removeAnonymous(self: class, component: interfaces.component)
	for i, item in ipairs(self._myAnonymous) do
		if item ~= component then continue end
		table.remove(self._myAnonymous, i)
		return self
	end
	return self
end

function PT.removeTyped(self: class, component: interfaces.typedComponent)
	local cType = component:getType()
	
	local typed = self._myComponents[cType]
	if not typed then return end
	
	typed[component] = nil
	component._myEntity = nil
	return self
end

function PT.destroyAnonymous(self: class, component: interfaces.component)
	self:removeAnonymous(component)
	component:destroy()
	return self
end

function PT.destroyTyped(self: class, component: interfaces.typedComponent)
	self:removedTyped(component)
	component:destroy()
	return self
end

function PT.hasA(self: class, componentType: number)
	local has = false
	if self._myComponents[componentType] then has = true end
	return has
end

function PT.getSpecificType(self: class, componentType: number)
	local typed = self._myComponents[componentType]
	
	if not typed then return {} end
	
	local components = {}
	for component, _ in pairs(typed) do 
		table.insert(components, component)
	end
	
	return components
end

function PT.getAllCombined(self: class)
	return combineTable(self:getAllAnonymous(), self:getAllTyped())
end

function PT.getAllAnonymous(self: class)
	return self._myAnonymous
end

function PT.getAllTyped(self: class)
	local allComponents = {}
	
	for componentType, componentCollection in pairs(self._myComponents) do 
		for component, _ in pairs(componentCollection) do 
			table.insert(allComponents, component)
		end
	end
	
	return allComponents
end

function PT.destroy(self: class)
	for _, component in ipairs(self:getAllCombined()) do 
		component:destroy()
		component._myEntity = nil
	end
end

return M