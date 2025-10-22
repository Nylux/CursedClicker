extends Node

# clicked on a AnimatedTextureRect
signal clicked(ui)

# used when a new amount of cultists is added to the current amount
signal cultist_created(amount)
# used when the amount of cultist is changed
signal cultist_changed(amount)

# clicked on altar
signal sacrifice_created(amount)

# generated blood
signal blood_created(amount)
