class_name EffectData
extends Resource

enum TYPES {DEFAULT, SHAPE_2D, SHAPE_3D}

@export var type: TYPES
@export var text: String ## Name for the effect, also used in the HUD
@export var icon: Texture2D ## Icon used for the HUD
@export var expiration_time: float ## Time in seconds for the effect to expire, displayed on the HUD
@export var priority: int ## Higher number is higher priority
