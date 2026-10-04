# Godot-React

A React-like state and effect system for Godot, with an API closely following React.

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

## API

- `React.useState(initial_value)`
- `React.useEffect(effect, dependencies)`

## License

MIT
