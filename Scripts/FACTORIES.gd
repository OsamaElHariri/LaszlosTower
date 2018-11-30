extends Node

var factory = load('res://Scripts/SectionSpawning/SectionFactory.gd')

var factories = {
	TOWER_TYPES.TRAIN: 1
}

func clear():
	factories = {}

func add(tower_type, limit):
	factories[tower_type] = factory.new(tower_type, limit)

func can_dispense(tower_type):
	return factories.has(tower_type) && factories[tower_type].can_dispense()

func dispense(tower_type):
	return FACTORIES.factories[tower_type].dispense()