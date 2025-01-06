class_name EffectData
extends Resource

@export_category("Base Effect Settings")
@export var type: EffectLibrary.TYPES
@export var name: String ## Name for the effect, also used in the HUD
@export var icon: Texture2D ## Icon used for the HUD
@export var expiration_time: float ## Time in seconds for the effect to expire, displayed on the HUD
@export var priority: int ## Higher number is higher priority
