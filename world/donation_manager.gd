extends CanvasLayer

enum State {
	POLL_DONATION,
	READING_MESSAGE,
	IDLE,
	RETURN
}

var window_visible := false

@onready var anim: AnimationPlayer = %AnimationPlayer
@onready var label: RichTextLabel = %RichTextLabel
@onready var fmt: String = label.text

func _anim_return_finished() -> void:
	window_visible = false

func _process(delta: float) -> void:
	if not window_visible:
		var donation := DonorDrive.get_donation()
		if donation != null:
			var flies := ceili(donation.dollar_amount * randf_range(25, 55)) * 5
			label.text = fmt % [donation.donor_name, donation.dollar_amount, flies]

			anim.play("chat")
			window_visible = true

			World.instance.spawn_count += flies

			donation.erase()

func _on_close_button_pressed() -> void:
	if Tool.held_tool == null and not anim.is_playing():
		anim.play("return")
