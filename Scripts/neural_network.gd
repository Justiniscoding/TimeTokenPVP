class_name NeuralNetwork

func sigmoid(x: float) -> float:
	return 1 / (1 + exp(-x))

class NeuralNode:
	var bias: float
	var value: float

	func _init(val: float) -> void:
		value = val

class NeuralLayer:
	var nodes: Array[NeuralNode]
	func _init(size: int) -> void:
		nodes = []

		for i in range(size):
			nodes.push_back(NeuralNode.new(0))

class NeuralConnector:
	var weight: float

	var start_layer: int
	var in_node: int
	var out_node: int

	func _init(start: int, in_id: int, out_id: int) -> void:
		weight = 1 - randf() * 2

		start_layer = start
		in_node = in_id
		out_node = out_id

var layers: Array[NeuralLayer]
var connectors: Array[NeuralConnector]
var activation_function: Callable

func _init(input_nodes: int, hidden_amount: int, hidden_nodes: int, output_nodes: int, activation: Callable) -> void:
	activation_function = activation

	var input_layer := NeuralLayer.new(input_nodes)
	var output_layer := NeuralLayer.new(output_nodes)

	layers.push_back(input_layer)

	for i in range(hidden_amount):
		layers.push_back(NeuralLayer.new(hidden_nodes))

	layers.push_back(output_layer)

	connectors = []

	for i in range(layers.size() - 1):
		for end_node in range(layers[i + 1].nodes.size()):
			for start_node in range(layers[i].nodes.size()):
				connectors.push_back(NeuralConnector.new(i, start_node, end_node))

func solve(inputs: Array[float]) -> Array[float]:
	for i in range(layers[0].nodes.size()):
		layers[0].nodes[i].value = inputs[i]

	var connector_index := 0
	var last_layer_size := layers[0].nodes.size()

	for i in range(1, layers.size()):
		for j in range(layers[i].nodes.size()):
			var value := 0.0

			for k in range(last_layer_size):
				var connector := connectors[connector_index]
				connector_index += 1
				value += layers[i - 1].nodes[connector.in_node].value * connector.weight

			value += layers[i].nodes[j].bias

			layers[i].nodes[j].value = activation_function.call(value);

		last_layer_size = layers[i].nodes.size()

	var output: Array[float] = []

	for node in layers[layers.size() - 1].nodes:
		output.push_back(node.value)

	return output

func load_weights(weights: Array[float], biases: Array[float]) -> void:
	var biasIndex := 0

	for i in range(1, layers.size()):
		for node in layers[i].nodes:
			node.bias = biases[biasIndex]
			biasIndex += 1

	var weightIndex := 0

	for connector in connectors:
		connector.weight = weights[weightIndex]
		weightIndex += 1
