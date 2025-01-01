--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local components = require(ReplicatedStorage.Modules.Types.Components)
local interfaces = require(ReplicatedStorage.Modules.Types.Interfaces)

local M = {}; local PT = {}; local MT = {__index = PT}

type class = {

} & interfaces.component

function M.create(

) : interfaces.component

	local self = {

	} :: class

	return setmetatable(self, MT)
end

function PT.destroy(self: class)
	
end

return M