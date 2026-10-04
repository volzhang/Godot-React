# Godot-React

A React-like state and effect system for Godot, with an API closely following React.

## Motivation

I'm a React user and I like the simplicity and familiarity of its reactive API. I created this plugin to:

- Reduce the boilerplate required by Godot's native signals.
- Provide a React-like experience for React users, so they can get started immediately.

The API follows the familiar `useState` and `useEffect` patterns. One small difference is that `signal.value` is used when reading a state inside an effect, while the signal itself is used as the dependency.

## API

- `React.useState(initial_value)`
- `React.useEffect(effect, dependencies)`

## Usage

Example scene:

```text
Main
├── Data   [data.gd]
├── Label  [label.gd]
└── Button [button.gd]
```

`data.gd`

```gdscript
extends Node

var data = React.useState(100)
```

`label.gd`

```gdscript
extends Label

@onready var data = $"../Data".data

func _ready() -> void:
	React.useEffect(func(): text = str(data.value), [data])
```

`button.gd`

```gdscript
extends Button

@onready var data = $"../Data".data

func _pressed() -> void:
	data.value += 100
```

## License

MIT
