class_name React
extends RefCounted

## A reactive state container.
class State:

	## A collection of effects subscribed to this state.
	class EffectSet:

		var _effects: Dictionary[Callable, Object] = {}
		var _invalid_effects: Array[Callable] = []
		var _need_to_prune: bool = false
		var _dispatching := false

		## Adds an effect to this set.
		func add(effect: Callable) -> void:
			if effect.is_valid():
				_effects[effect] = null

		## Dispatches all valid effects.
		func dispatch() -> void:
			assert(not _dispatching, "EffectSet cannot dispatch recursively")
			_dispatching = true

			for effect in _effects:
				if effect.is_valid():
					effect.call()
				else:
					_invalid_effects.append(effect)
					_need_to_prune = true

			if _need_to_prune: prune()

			_dispatching = false

		## Removes effects that are no longer valid.
		func prune() -> void:
			for effect in _invalid_effects:
				_effects.erase(effect)
			_invalid_effects.clear()
			_need_to_prune = false

	var _value
	var _effects := EffectSet.new()

	func _init(initial_value) -> void:
		_value = initial_value

	## The current value of this state.
	## Assigning a different value notifies all subscribed effects.
	var value:
		get:
			return _value
		set(new_value):
			if _value != new_value:
				_value = new_value
				_effects.dispatch()

## Creates a reactive state with the given initial value.
static func useState(initial_value):
	return State.new(initial_value)

## Subscribes [param effect] to the given states and then executes it immediately.
## Cleanup functions are not supported. Use Godot's native lifecycle
## and signal mechanisms when cleanup is required.
static func useEffect(effect: Callable, dependencies: Array[State]) -> void:
	if effect.is_valid():
		for dependency in dependencies:
			dependency._effects.add(effect)
		effect.call()
