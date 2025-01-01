--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local interfaces = require(ReplicatedStorage.Modules.Types.Interfaces)

-------------------------------
-- UNCACHED IMPLEMENTATION
-------------------------------

local UNCACHED_PT = {}; local UNCACHED_MT = {__index = UNCACHED_PT}

type uncachedImpl<t> = {
	_myInstance: Instance,
	_attributeName: string
} & interfaces.getset<t>

local function createUncached<t>(
	From: Instance,
	attributeName: string
): interfaces.getset<t>

	local self = {
		_myInstance = From,
		_attributeName = attributeName
	} :: uncachedImpl<t>

	return setmetatable(self, UNCACHED_MT)
end

function UNCACHED_PT.set<t>(self: uncachedImpl<t>, to: t) self._myInstance:SetAttribute(self._attributeName, to) end
function UNCACHED_PT.get<t>(self: uncachedImpl<t>) return self._myInstance:GetAttribute(self._attributeName) end

-------------------------------
-- CACHED IMPLEMENTATION
-------------------------------

local CACHED_PT = {}; local CACHED_MT = {__index = CACHED_PT}

type cachedImpl<t> = {
	_cachedValue: t,
	_cacheInvalidated: boolean,
	_invalidatedConnection: RBXScriptConnection?,

	_reconnectEvent: (self: cachedImpl<t>) -> ()
} & interfaces.getset<t> & uncachedImpl<t>

local function createCached<t>(
	From: Instance,
	attributeName: string
): interfaces.getset<t>

	local self = {
		_cachedValue = From:GetAttribute(attributeName),
		_cacheInvalidated = false
	} :: cachedImpl<t>

	return setmetatable(self, CACHED_MT)
end

function CACHED_PT._reconnectEvent<t>(self: cachedImpl<t>)
	if self._invalidatedConnection then self._invalidatedConnection:Disconnect() end

	self._invalidatedConnection = self._myInstance:GetAttributeChangedSignal(self._attributeName):Once(function(to: t)
		self._cacheInvalidated = true
	end)
end

function CACHED_PT.set<t>(self: cachedImpl<t>, to: t)
	self._cacheInvalidated = false
	self._cachedValue = to
	self._myInstance:SetAttribute(self._attributeName, to)

	self:_reconnectEvent()
end

function CACHED_PT.get<t>(self: cachedImpl<t>)
	if self._cacheInvalidated then 
		local retrieved = self._myInstance:GetAttribute(self._attributeName) :: any
		self._cacheInvalidated = false
		self._cachedValue = retrieved

		self:_reconnectEvent()
		return retrieved
	end

	return self._cachedValue
end

-------------------------------
-- MODULE
-------------------------------

local M = {} 

function M.create<t>(
	From: Instance,
	attributeName: string,
	shouldCache: boolean
): interfaces.getset<t>

	if shouldCache then
		return createCached(From, attributeName)
	else
		return createUncached(From, attributeName)
	end
end

return M