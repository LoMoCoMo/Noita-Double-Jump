dofile_once( "mods/double_jump/files/scripts/jump_wait_variables.lua") -- Variables stored outside to stop the script from resetting them.
dofile("data/scripts/lib/utilities.lua")

local player = get_players()[1]
local x, y = EntityGetTransform(player)
local controlsComponent = EntityGetFirstComponent(player, "ControlsComponent")
local dataComp = EntityGetFirstComponent(player, "CharacterDataComponent")
local is_grounded = ComponentGetValue(dataComp, "is_on_ground")
local is_on_wall = ComponentGetValue(dataComp, "mCollidedHorizontally")
local sprite_P = EntityGetFirstComponent(player, "SpriteComponent")

local player_vel_x, player_vel_y = ComponentGetValueVector2(dataComp, "mVelocity")
local aim_x, aim_y = ComponentGetValueVector2(controlsComponent, "mAimingVectorNormalized")

local currentFrame = GameGetFrameNum()
local jumpFrame = ComponentGetValue( controlsComponent, "mButtonFrameFly")
local jumpDown = ComponentGetValue( controlsComponent, "mButtonDownFly")
local leftDown = ComponentGetValue( controlsComponent, "mButtonDownLeft")
local rightDown = ComponentGetValue( controlsComponent, "mButtonDownRight")

local walljump_left, wj_left_x, wj_left_y = Raytrace(x - 5, y + 3, x - 5, y - 5)
local walljump_right, wj_right_x, wj_right_y = Raytrace(x + 5, y + 3, x + 5, y - 5)



if (tonumber(is_grounded)) == 1 then
	JUMP_BUFFER = currentFrame
end

if currentFrame >= JUMP_BUFFER + 10 and IS_JUMPING == false then
	if currentFrame >= jumpFrame + 30 then
		ComponentSetValue(dataComp, "mFlyingTimeLeft", 0.1)
		IS_JUMPING = true
	end
end

if currentFrame >= JUMP_BUFFER + 10 and IS_JUMPING == true and (tonumber(jumpDown)) == 1 and JUMP_PRESS == false and player_vel_x >= -10 and player_vel_x <= 10 then
	
	if (tonumber(is_grounded)) == 0 and walljump_left == true and IS_WALL_JUMPING == false and (tonumber(leftDown)) == 1 then
		if(aim_x > 0) then
			ComponentSetValue(sprite_P,"rect_animation", "jump_forward",0)
		elseif(aim_x < 0) then
			ComponentSetValue(sprite_P,"rect_animation", "jump_backwards",0)
		end		
		ComponentSetValue(dataComp, "mFlyingTimeLeft", 0.1)
		player_vel_x = player_vel_x + 200
		WALL_BUFFER = currentFrame
		IS_WALL_JUMPING = true
		JUMP_PRESS = true
	end	
	if (tonumber(is_grounded)) == 0 and walljump_right == true and IS_WALL_JUMPING == false and (tonumber(rightDown)) == 1 then
		if(aim_x > 0) then
			ComponentSetValue(sprite_P,"rect_animation", "jump_backwards",0)
		elseif(aim_x < 0) then
			ComponentSetValue(sprite_P,"rect_animation", "jump_forward",0)
		end	
		ComponentSetValue(dataComp, "mFlyingTimeLeft", 0.1)
		player_vel_x = player_vel_x - 200
		WALL_BUFFER = currentFrame
		IS_WALL_JUMPING = true
		JUMP_PRESS = true
	end	
	if currentFrame >= WALL_BUFFER + 20 and IS_WALL_JUMPING == true then
		IS_WALL_JUMPING = false
	end
	ComponentSetValueVector2(dataComp, "mVelocity", player_vel_x, player_vel_y)
end

if (tonumber(jumpDown)) == 0 then
	JUMP_PRESS = false
end

if (tonumber(is_grounded)) == 1 and IS_JUMPING == true then
	IS_JUMPING = false
	IS_WALL_JUMPING = false
end