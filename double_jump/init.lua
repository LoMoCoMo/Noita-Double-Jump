function OnPlayerSpawned( player_entity ) -- This runs when player entity has been created
	-- random loadout compatibility fix
	if tonumber(StatsGetValue("playtime")) < 1 then
		--[[
		local armEntity = EntityGetWithName("arm_r")
		ComponentSetValue( EntityGetFirstComponent( armEntity, "SpriteComponent" ), "image_file", "mods/mwp_player_frontline_witch/data/enemies_gfx/player_arm.xml" )		
		ComponentSetValue( EntityGetFirstComponent( player_entity, "SpriteComponent" ), "image_file", "mods/mwp_player_frontline_witch/data/enemies_gfx/player.xml" )
		ComponentSetValue( EntityGetFirstComponent( player_entity, "DamageModelComponent" ), "ragdoll_filenames_file", "mods/mwp_player_frontline_witch/data/ragdolls/player/filenames.txt" )

	
		-- Adds new hotspots
		EntityAddComponent( player_entity, "HotspotComponent",
			{
				_tags="pouch_root",
				sprite_hotspot_name="pouch"	
			} )
		EntityAddComponent( player_entity, "HotspotComponent",
			{
				_tags="pouchback_root",
				sprite_hotspot_name="pouchback"	
			} )		


		-- Remove cape and spawn/respawn custom one
		local plyChildEnt = EntityGetAllChildren( player_entity )
		if ( plyChildEnt ~= nil ) then
			for i,childEntity in ipairs( plyChildEnt ) do
				if ( EntityGetName( childEntity ) == "cape" ) then
					EntityKill( childEntity )
					local px, py = EntityGetTransform( player_entity )
					cape_entity = EntityLoad( "mods/mwp_player_frontline_witch/files/entities/verlet_chains/tw_braid/verlet_braid.xml", px, py )
					EntityAddChild( player_entity, cape_entity )
					break
				end
			end
		end

		
		-- Adds new verlet chain entities
		local px, py = EntityGetTransform( player_entity )
		local ent_pouch = EntityLoad("mods/mwp_player_frontline_witch/files/entities/verlet_chains/tw_pouch/verlet_pouch.xml",px, py)
		local ent_pouchback = EntityLoad("mods/mwp_player_frontline_witch/files/entities/verlet_chains/tw_pouchback/verlet_pouchback.xml",px, py)
		EntityAddChild(player_entity, ent_pouch )
		EntityAddChild(player_entity, ent_pouchback )
		

		
		EntitySetComponentsWithTagEnabled( player_entity, "jetpack", 1 )
		if( nil == EntityGetFirstComponent( player_entity, "ParticleEmitterComponent", "flwitch_pt" ) ) then
			-- Remove old particles
			for i,compo in ipairs( {"ParticleEmitterComponent", "SpriteParticleEmitterComponent"} ) do
				while( compo ~= nil ) do
					local ptEmit = EntityGetFirstComponent( player_entity, compo, "jetpack" )
					if ( ptEmit == nil ) then break end
					EntityRemoveComponent( player_entity, ptEmit )
				end
			end
			-- -- Create new particles start
			local ptEmit1 = EntityAddComponent( player_entity, "ParticleEmitterComponent",
			{
				_tags="jetpack,flwitch_pt",
				emitted_material_name="spark_blue",
				x_pos_offset_min="-5",
				x_pos_offset_max="5",
				y_pos_offset_min="-5",
				y_pos_offset_max="5",
				x_vel_min="-8",
				x_vel_max="8",
				y_vel_min="-8",
				y_vel_max="8",
				count_min="30",
				count_max="30",
				attractor_force="0",
				lifetime_min="0.25",
				lifetime_max="0.25",
				create_real_particles="0",
				emit_cosmetic_particles="1",
				fade_based_on_lifetime="1",
				draw_as_long="1",
				emission_interval_min_frames="5",
				emission_interval_max_frames="5",
				is_trail="0",
				trail_gap="0.1",
				airflow_force="1.051",
				airflow_time="1.01",
				airflow_scale="0.05",
				is_emitting="1"
			} )
		end
		
		-- Aiming reticle fix
		local old_hitbox = EntityGetFirstComponent( player_entity, "HitboxComponent" )
		ComponentSetValue(old_hitbox, "aabb_max_x", 2)
		ComponentSetValue(old_hitbox, "aabb_min_x", -2)
		ComponentSetValue(old_hitbox, "aabb_max_y", 1)
		ComponentSetValue(old_hitbox, "aabb_min_y", -11)
		
		EntityAddComponent( player_entity, "HitboxComponent",
			{
				aabb_max_x="3",
				aabb_max_y="4", 
				aabb_min_x="-3", 
				aabb_min_y="-12", 
				is_enemy="0", 
				is_item="0", 
				is_player="1"
			} )		


		EntityAddComponent( player_entity, "LuaComponent",
		{
		  remove_after_executed="0",
		  execute_times="-1",
		  script_source_file="mods/mwp_player_frontline_witch/files/scripts/cape_fix.lua"
		} )
		
		EntityAddComponent( player_entity, "LuaComponent",
		{
		  remove_after_executed="0",
		  execute_times="-1",
		  script_source_file="mods/mwp_player_frontline_witch/files/scripts/invisibility_fix.lua"
		} )
		
		EntityAddComponent( player_entity, "LuaComponent",
		{
		  remove_after_executed="0",
		  execute_times="-1",
		  script_source_file="mods/mwp_player_frontline_witch/files/scripts/velocity_fix.lua"
		} )
		
		EntityAddComponent( player_entity, "LuaComponent",
		{
		  remove_after_executed="0",
		  execute_times="-1",
		  script_source_file="mods/mwp_player_frontline_witch/files/scripts/transform_fix.lua"
		} )--]]
		
		EntityAddComponent( player_entity, "LuaComponent",
		{
		  remove_after_executed="0",
		  execute_times="-1",
		  script_source_file="mods/double_jump/files/scripts/jump_wait.lua"
		} )
	end
end
