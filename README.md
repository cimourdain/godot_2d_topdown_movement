# Godot 2d topdown movements

The purpose of this plugin is to provide helpers to facilitate objects movements in a 2d topdown game.


# Features
- Manage multiple movements for an object by priority.
- Handle usage of a `Navigation2D` for pathfinding
- Handle "smooth" rotation of objects
- Provide helper functions to create you own movements


# Basic Usage

1. Add a Movement Manager at the root of your moving node (attach `movement_manager.gd` script to it.)
2. Add movmement owners as children of the movement manager node (script inheriting from `MovementOwner` class). 

Below an example of usage on a KinematicBody2D using the provided Patrol and FollowClick classes:
![Usage Example](img/usage.png?raw=true "Usage")

Below the result:
 1. The player use the default Patrol node to patrol between points (note the rotation)
 2. When the user clicks, the player goes to the click position
 3. The player goes back to patrolling.

![Usage Example](img/basic_usage_result.gif?raw=true "Usage")