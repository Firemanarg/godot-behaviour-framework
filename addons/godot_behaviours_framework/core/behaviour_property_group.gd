extends Node


var group_name: String = ""
var subgroups: Dictionary = {}
var properties: Array[Behaviour.Property] = []


func _init(group_name: String):
	self.group_name = group_name


## Add a property to the property list
func add_property(property: Behaviour.Property) -> void:
	if property == null:
		return
	properties.append(property)


## Add a subgroup to the subgroups dictionary, considering subgroup name as key
func add_subgroup(subgroup: Behaviour.PropertyGroup) -> void:
	if subgroup == null or subgroups.has(subgroup.group_name):
		return
	subgroups[subgroup.group_name] = subgroup


## Return a dictionary formatted as a subgroup
func as_property_dict(prefix: String = "") -> Dictionary:
	var dict: Dictionary = {
		"name": prefix + group_name,
		"type": TYPE_NIL,
		"usage": PROPERTY_USAGE_SUBGROUP
	}
	return (dict)


## Return a list containing all properties from this and subgroup's
## properties as dictionaries
func as_property_list(prefix: String = "") -> Array:
	var list: Array = []
	var new_prefix: String = (prefix + group_name + '/').trim_prefix('/')

	for property in properties:
		var dict: Dictionary = property.as_property_dict(new_prefix)
		list.append(dict)
	for subgroup in subgroups.values():
		var prop_list: Array = subgroup.as_property_list(new_prefix)
		list.append_array(prop_list)
	return (list)


## Return the subgroup by given string, or null if it doesn't exist
func get_subgroup(subgroup_name: String) -> Behaviour.PropertyGroup:
	return (subgroups.get(subgroup_name))


## Return true if group has subgroup of given string, or false otherwise
func has_subgroup(subgroup_name: String) -> bool:
	return (subgroups.has(subgroup_name))



