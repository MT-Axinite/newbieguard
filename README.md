# Minetest mod : Newbie Guard

Prevent newbies from being slaughtered by other players.

Also, prevent newbies from hitting people.

## What it does

After installing the mod, any newly-joining player receives a period of protection from being hit by existing players.

Each player's protection is registered against a timer ; when the timer runs out, the player loses their immunity.

Should the player log out, or the server restart, the players' immunity timers resume where they last left off, so the players always get the full extent of their immunity duration.

## Settings

The following can be added to your `minetest.conf` to configure `newbieguard` (values reflect the existing defaults)

* `newbieguard.defense_age = 10`
	* The duration for which new players are protected, in minutes

* `newbieguard.step_period = 2`
	* How frequently to check new players' timers, in seconds

* `newbieguard.save_interval = 10`
	* How frequently to save the players' timers, in seconds

### Messages

Special settings for customizing messages:


* `newbieguard.onjoin = "Welcome ! You are immune to PvP as a newbie."`
	* welcome message to players who are still under protection

* `newbieguard.warning = "Beware ! You are no logner immune to PvP !"`
	* alert message to players who have just lost the new player protection

* `newbieguard.playnice = "Since you cannot be attacked, you cannot attack either."`
	* Message to show when a newbie attacks someone else

* `newbieguard.theyrenew = " is still new, don't hit them."
	* message to show when someone else attacks a newbie

