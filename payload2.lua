{
    game_info = {
        start_raw = {
            placement_grid = {
                size = {
                    x = 176
                    y = 184
                }
                bits_per_pixel = 1
            }
            start_locations = {
                1 = {
                    x = 33.5
                    y = 138.5
                }
            }
            terrain_height = {
                size = {
                    x = 176
                    y = 184
                }
                bits_per_pixel = 8
            }
            pathing_grid = {
                size = {
                    x = 176
                    y = 184
                }
                bits_per_pixel = 1
            }
            playable_area = {
                p1 = {
                    x = 158
                    y = 154
                }
                p0 = {
                    x = 18
                    y = 18
                }
            }
            map_size = {
                x = 176
                y = 184
            }
        }
        local_map_path = AcropolisAIE.SC2Map
        options = {
            show_cloaked = true
            raw = true
            show_placeholders = true
            raw_crop_to_playable_area = false
            raw_affects_selection = false
            score = true
            show_burrowed_shadows = true
        }
        map_name = Acropolis AIE
        mod_names = {
            1 = Mods/Core.SC2Mod
            2 = Mods/Liberty.SC2Mod
            3 = Mods/Swarm.SC2Mod
            4 = Mods/Void.SC2Mod
            5 = Mods/VoidMulti.SC2Mod
        }
        player_info = {
            1 = {
                race_requested = Terran
                race_actual = Terran
                player_id = 1
                type = Participant
            }
            2 = {
                race_requested = Terran
                difficulty = CheatInsane
                player_id = 2
                type = Computer
            }
        }
    }
    status = in_game
    id = 3
    response = game_info
}