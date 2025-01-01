--!strict

-- EVENT

export type eventConnection = {
	disconnect: (self: eventConnection) -> ()
}

export type event<T...> = {
	connect: (self: event<T...>, callback: (T...) -> ()) -> (eventConnection),
	fire: (self: event<T...>, T...) -> (),
	destroy: (self: event<T...>) -> (),
}

-- ENTITY AND COMPONENT

export type entity = {
	addAnonymous: (self: entity, component: component) -> (entity),
	addTyped: (self: entity, component: typedComponent) -> (entity), -- return self for easier inline chaining

	removeAnonymous: (self: entity, component: component) -> (entity),
	removedTyped: (self: entity, component: typedComponent) -> (entity), -- remove but don't destroy

	destroyAnonymous: (self: entity, component: component) -> (entity),
	destroyTyped: (self: entity, component: typedComponent) -> (entity),

	hasA: (self: entity, componentType: number) -> (boolean),

	getSpecificType: (self: entity, componentType: number) -> ({typedComponent & any}),

	getAllCombined: (self: entity) -> ({component & any}),
	getAllAnonymous: (self: entity) -> ({component & any}),
	getAllTyped: (self: entity) -> ({typedComponent & any}),

	destroy: (self: entity) -> ()
}

export type component = {
	_myEntity: entity?,
	destroy: (self: component) -> (),
}

type typedComponentExtras = {
	getType: (self: component) -> (number),
	destroying: event<>
}

export type typedComponent = component & typedComponentExtras

return {}