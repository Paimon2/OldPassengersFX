----------------------
-- PassengersFX addon for X-Plane
-- "adding realistic passengers to your aircraft"
-- by mcpcfanc - Copyright 2017
-- Version 1.0.1

-----------
-- This add-on (not including the sounds) may not be re-uploaded, re-distributed, or re-sold to any individuals,
-- any website, any service, with or without modification, without written
-- permission from mcpcfanc.
-- If this is your first time opening this file, please read the included Manual.pdf file.
-----------

---  ------------- ---
  ----- OPTIONS -----
---  ------------- ---



local dis = 0 -- Enable or disable PassengersFX? (can be changed via FlyWithLua Macros Menu or keyboard commands) 0 to disable, 1 to enable.
local announcements_enabled = 1 -- Enable or disable announcements? 0 to disable, 1 to enable.
local ambience_enabled = 1 -- Enable or disable ambience/chatter? 0 to disable, 1 to enable.
local taxi_and_gate_sounds_enabled = 1 -- Enable or disable on-ground chatter? 0 to disable, 1 to enable.
local turbulence_screams_enabled = 1 -- Enable or disable turbulence screams/distress? 0 to disable, 1 to enable.
local baby_crying_enabled = 1 -- Enable or disable the baby crying? 0 to disable, 1 to enable.
local landing_status_report_enabled = 1 -- Enable or disable passenger clapping on landings? 0 to disable, 1 to enable.


-- Do not edit below this line!

dataref("engn_count", "sim/aircraft/engine/acf_num_engines")
if engn_count == 1 then
print("PassengersFX version 1.0.0 by mcpcfanc loaded, but you are need to be in an aircraft with two or more engines! PassengersFX will be disabled for this flight.")
else
local safetyvideo = load_WAV_file(SCRIPT_DIRECTORY .. "PassengersFX/safety_video.wav")
local chime_single = load_WAV_file(SCRIPT_DIRECTORY .. "PassengersFX/chime_single.wav")
local onground = load_WAV_file(SCRIPT_DIRECTORY .. "PassengersFX/on_ground.wav")
local taximusic = load_WAV_file(SCRIPT_DIRECTORY .. "PassengersFX/taxi_music.wav")
local afterlanding = load_WAV_file(SCRIPT_DIRECTORY .. "PassengersFX/after_landing_at_gate.wav")
local crz_announcement = load_WAV_file(SCRIPT_DIRECTORY .. "PassengersFX/crz_announcement.wav")
local flush1 = load_WAV_file(SCRIPT_DIRECTORY .. "PassengersFX/lavatory_flush_01.wav")
local flush2 = load_WAV_file(SCRIPT_DIRECTORY .. "PassengersFX/lavatory_flush_02.wav")
local babycry1 = load_WAV_file(SCRIPT_DIRECTORY .. "PassengersFX/baby_cry.wav")
--local babycry2 = load_WAV_file(SCRIPT_DIRECTORY .. "PassengersFX/baby_cry_02.wav") 
local seatshakelight = load_WAV_file(SCRIPT_DIRECTORY .. "PassengersFX/cabin_turbulence_shake_light.wav")
local seatshakehard = load_WAV_file(SCRIPT_DIRECTORY .. "PassengersFX/cabin_turbulence_shake_hard.wav")
local footsteps = load_WAV_file(SCRIPT_DIRECTORY .. "PassengersFX/passenger_footsteps.wav")
local cl_pass = load_WAV_file(SCRIPT_DIRECTORY .. "PassengersFX/Special Announcements/claustrophobic_passenger.wav")
local foodcart = load_WAV_file(SCRIPT_DIRECTORY .. "PassengersFX/food_cart.wav")
local paging = load_WAV_file(SCRIPT_DIRECTORY .. "PassengersFX/Special Announcements/paging_mr_hunter.wav")
local mb = load_WAV_file(SCRIPT_DIRECTORY .. "PassengersFX/Special Announcements/missing_watch.wav")
local galley_ambience = load_WAV_file(SCRIPT_DIRECTORY .. "PassengersFX/galley_ambience.wav")
--local paxoxyann = load_WAV_file(SCRIPT_DIRECTORY .. "PassengersFX/passenger_oxygen.wav")
local seatbeltsoff = load_WAV_file(SCRIPT_DIRECTORY .. "PassengersFX/seatbeltsoff.wav")
local seatbeltson = load_WAV_file(SCRIPT_DIRECTORY .. "PassengersFX/seatbeltson.wav")
local emergency = load_WAV_file(SCRIPT_DIRECTORY .. "PassengersFX/emergency.wav")
local turb_warn = load_WAV_file(SCRIPT_DIRECTORY .. "PassengersFX/turb_warn.wav")
local turbulence_scream1 = load_WAV_file(SCRIPT_DIRECTORY .. "PassengersFX/turbulencescream.wav")
local pax_cough = load_WAV_file(SCRIPT_DIRECTORY .. "PassengersFX/passengers_cough.wav")
local boarding = load_WAV_file(SCRIPT_DIRECTORY .. "PassengersFX/boarding_ambience.wav")
local clbdes_ambience = load_WAV_file(SCRIPT_DIRECTORY .. "PassengersFX/clbdes_ambience.wav")
local welcome_to_dest = load_WAV_file(SCRIPT_DIRECTORY .. "PassengersFX/welcome_to_dest.wav")
local goodlanding = load_WAV_file(SCRIPT_DIRECTORY .. "PassengersFX/goodlanding.wav")
local cruise = load_WAV_file(SCRIPT_DIRECTORY .. "PassengersFX/cruise_ambience.wav")
local ccpftf = load_WAV_file(SCRIPT_DIRECTORY .. "PassengersFX/takeoff_prep.wav")
local mealsel = load_WAV_file(SCRIPT_DIRECTORY .. "PassengersFX/meal_selection.wav")
local des_announcement = load_WAV_file(SCRIPT_DIRECTORY .. "PassengersFX/descent_announcement.wav")
local sf_playing = false
local turbannplayed = false
--local paxoxy_played = false
local timer_sec = 0
local rand
local turb_light_playing = 0
local turb_hard_playing = 0
local bfr = 0
local wts = 0
local lavatory_flush_bugfixer = 0
local clb_announ_played = 0
local clbdes_playing = 0
local announcements_volume = 6
local crzplaying = 0
local gl_played = 0
local aftergateplaying = 0
local onground_playing = 0
local crz_announ_played = 0
local des_announ_played = 0
local pft_played = 0
local boarding_playing = 0
local taximusic_playing = 0
local g_force_lastsec
local landed = 2
local in_air_fpm = 9999
-- Reserved for future: dataref("bagl", "sim/cockpit2/autopilot/flight_director_roll_deg")
dataref("camera_z_position", "sim/aircraft/view/acf_peZ")
dataref("g_force", "sim/flightmodel/forces/g_nrml")
dataref("flaps", "sim/flightmodel2/controls/flap_handle_deploy_ratio")
dataref("gnd_stat", "sim/flightmodel/forces/faxil_gear")
dataref("alt", "sim/cockpit2/gauges/indicators/altitude_ft_pilot")
dataref("seatbelt_sign_pos", "sim/cockpit2/annunciators/fasten_seatbelt")
dataref("thro", "sim/cockpit2/engine/actuators/throttle_ratio_all")
dataref("paxoxy", "sim/cockpit2/annunciators/passenger_oxy_on")
dataref("bat", "sim/cockpit/electrical/battery_on")
dataref("lali", "sim/cockpit/electrical/landing_lights_on")
dataref("viewext", "sim/graphics/view/view_is_external")
dataref("paused", "sim/time/paused")
dataref("prb", "sim/cockpit2/controls/parking_brake_ratio")
dataref("turb", "sim/weather/turbulence[0]")
dataref("smoke_in_cpit", "sim/operation/failures/rel_smoke_cpit")
dataref("spd", "sim/flightmodel/position/indicated_airspeed")
dataref("radio_alt", "sim/cockpit2/gauges/indicators/radio_altimeter_height_ft_pilot")
dataref("fpm", "sim/flightmodel/position/vh_ind_fpm")
--Reserved for future: dataref("pitch", "sim/cockpit2/autopilot/sync_hold_pitch_deg")
add_macro("PassengersFX: Ready for Boarding", "board()")
--obsolete: add_macro("PassengersFX: Announce Meals", "meal()")
--obsolete: add_macro("PassengersFX: Announce Emergency", "emer()")
--obsolete:add_macro("PassengersFX (Specials): Seat Swap", "ssw()")
--obsolete: add_macro("PassengersFX (Specials): Missing Watch", "msw()")
--obsolete: add_macro("PassengersFX (Specials): Duty Free Collection", "dfc()")
add_macro("PassengersFX: Disable for this flight", "disable_passengersfx()")
create_command("FlyWithLua/PassengersFX/annvolup", "PassengersFX: Announcements Volume Down", "", "", "annvolumedn()" )
create_command("FlyWithLua/PassengersFX/annvoldn", "PassengersFX: Announcements Volume Up", "", "", "annvolumeup()" )
create_command("FlyWithLua/PassengersFX/boarding", "PassengersFX: Ready for Boarding", "", "", "board()" )
create_command("FlyWithLua/PassengersFX/meals", "PassengersFX: Announce Meals", "", "", "meal()" )
create_command("FlyWithLua/PassengersFX/emergency", "PassengersFX: Announce Emergency", "", "", "emer()" )
create_command("FlyWithLua/PassengersFX/seatswap", "PassengersFX (Special Sounds): Seat Swap", "", "", "ssw()" )
create_command("FlyWithLua/PassengersFX/missingwatch", "PassengersFX (Special Sounds): Missing Watch", "", "", "msw()" )
create_command("FlyWithLua/PassengersFX/dutyfree", "PassengersFX (Special Sounds): Duty Free Collection", "", "", "dfc()")
create_command("FlyWithLua/PassengersFX/disable", "PassengersFX: Disable for this flight", "", "", "disable_passengersfx()" )
local stblt_poschg = seatbelt_sign_pos
let_sound_loop(onground, true)
let_sound_loop(clbdes_ambience, true)
let_sound_loop(cruise, true)
let_sound_loop(taximusic, true)
let_sound_loop(pax_cough, true)
let_sound_loop(seatshakelight, true)
let_sound_loop(seatshakehard, true)
g_force_lastsec = g_force
if sf_playing == false then stop_sound(safetyvideo) end
function board() play_sound(boarding, 0.75); boarding_playing = 1 end
function meal() play_sound(mealsel); play_sound(foodcart); play_sound(galley_ambience) end
function ssw() play_sound(cl_pass) end
function msw() play_sound(mb) end
function dfc() play_sound(paging) end
function emer() play_sound(emergency) end
function disable_passengersfx()
dis = 1
if clbdes_playing == 1 then stop_sound(clbdes_ambience); clbdes_playing = 4 end
if crzplaying == 1 then stop_sound(cruise); crzplaying = 4 end
if aftergateplaying == 1 then stop_sound(afterlanding); aftergateplaying = 4 end
if onground_playing == 1 then stop_sound(onground); onground_playing = 4 end
if taximusic_playing == 1 then stop_sound(taximusic); taximusic_playing = 4 end
if turb_light_playing == 1 then stop_sound(seatshakelight); turb_light_playing = 4 end
if turb_hard_playing == 1 then stop_sound(seatshakehard); turb_hard_playing = 4 end
print("PassengersFX will now be disabled for this flight. (if an announcement is playing, it will not sound again after this)")
end
function annvolumeup()
if announcements_volume == 10 then 
elseif announcements_volume ~= 10 then
announcements_volume = announcements_volume + 1 end
setannvolumes()
end
function annvolumedn()
if announcements_volume == 1 then 
elseif announcements_volume ~= 1 then
announcements_volume = announcements_volume - 1 end
setannvolumes()
end
function setannvolumes()
set_sound_gain(crz_announcement, announcements_volume / 10)
set_sound_gain(welcome_to_dest, announcements_volume / 10)
set_sound_gain(cl_pass, announcements_volume / 10)
set_sound_gain(paging, announcements_volume / 10)
set_sound_gain(mb, announcements_volume / 10)
set_sound_gain(emergency, announcements_volume / 10)
set_sound_gain(ccpftf, announcements_volume / 10)
set_sound_gain(mealsel, announcements_volume / 10)
set_sound_gain(turb_warn, announcements_volume / 10)
set_sound_gain(seatbeltsoff, announcements_volume / 10)
set_sound_gain(seatbeltson, announcements_volume / 10)
set_sound_gain(des_announcement, announcements_volume / 10)

end
function passengersfx_dynamicsoundlevels()
if math.floor(camera_z_position) < -14 then
if clbdes_playing == 1 then set_sound_gain(clbdes_ambience, 0.75) end
if crzplaying == 1 then set_sound_gain(cruise, 0.75) end
if aftergateplaying == 1 then set_sound_gain(afterlanding, 0.75) end
if onground_playing == 1 then set_sound_gain(onground, 0.5) end
if taximusic_playing == 1 then set_sound_gain(taximusic, 0.4) end
if turb_light_playing == 1 then set_sound_gain(seatshakelight, 0.8) end
if turb_hard_playing == 1 then set_sound_gain(seatshakehard, 0.8) end
set_sound_gain(turbulence_scream1, 0.5)
set_sound_gain(chime_single, 0.4)
set_sound_gain(boarding, 0.5)
set_sound_gain(safetyvideo, 0.4)
set_sound_gain(flush1, 0.6)
set_sound_gain(flush2, 0.6)
elseif math.floor(camera_z_position) > -14 and math.floor(camera_z_position) < -4 then 
if clbdes_playing == 1 then set_sound_gain(clbdes_ambience, 1.00) end
if crzplaying == 1 then set_sound_gain(cruise, 1.00) end
if aftergateplaying == 1 then set_sound_gain(afterlanding, 1.00) end
if onground_playing == 1 then set_sound_gain(onground, 1.00) end
if taximusic_playing == 1 then set_sound_gain(taximusic, 1.0) end
if turb_light_playing == 1 then set_sound_gain(seatshakelight, 1.00) end
if turb_hard_playing == 1 then set_sound_gain(seatshakehard, 1.00) end
set_sound_gain(turbulence_scream1, 1.00)
set_sound_gain(chime_single, 1.00)
set_sound_gain(safetyvideo, 1.00)
set_sound_gain(boarding, 1.0)
set_sound_gain(flush1, 0.8)
set_sound_gain(flush2, 0.8)
elseif math.floor(camera_z_position) > -4 then
if clbdes_playing == 1 then set_sound_gain(clbdes_ambience, 1.0) end
if crzplaying == 1 then set_sound_gain(cruise, 0.9) end
if aftergateplaying == 1 then set_sound_gain(afterlanding, 0.9) end
if onground_playing == 1 then set_sound_gain(onground, 0.9) end
if taximusic_playing == 1 then set_sound_gain(taximusic, 0.9) end
if turb_light_playing == 1 then set_sound_gain(seatshakelight, 0.9) end
if turb_hard_playing == 1 then set_sound_gain(seatshakehard, 0.9) end
set_sound_gain(turbulence_scream1, 1.00)
set_sound_gain(chime_single, 1.00)
set_sound_gain(safetyvideo, 0.9)
set_sound_gain(boarding, 0.8)
set_sound_gain(flush1, 0.7)
set_sound_gain(flush2, 0.7)
end
end
function passengersfx_onesecondlogic()
if dis == 0 and timer_sec ~= 2 then timer_sec = timer_sec + 1 end
if dis == 0 then
g_force_lastsec = g_force 
if bfr == 1 and gnd_stat == 0 and fpm < 0 then in_air_fpm = fpm end
if spd < -1.6 and sf_playing == false and bat == 1 and prb == 0 and lali == 1 then 
if camera_z_position > -14 and dis == 0 and announcements_enabled == 1 then play_sound(safetyvideo); sf_playing = true
elseif dis == 0 then play_sound(safetyvideo, 1.00); sf_playing = true
end
end
if sf_playing == false then stop_sound(safetyvideo) end
if spd < 40 and wts == 0 and gnd_stat > 1 and in_air_fpm ~= 9999 and in_air_fpm ~= 0 and dis == 0 and announcements_enabled == 1 then play_sound(welcome_to_dest); wts = 1 end
if gnd_stat > 1 and dis == 0 and in_air_fpm ~= 9999 and in_air_fpm ~= 0 and bfr == 1 then
if math.floor(in_air_fpm) > -200 and gl_played == 0 and viewext == 0 and paused == 0 and landing_status_report_enabled == 1 then play_sound(goodlanding); gl_played = 1 end
stop_sound(clbdes_ambience)
clbdes_playing = 0
if onground_playing == 0 and taxi_and_gate_sounds_enabled == 1 and dis == 0 then play_sound(onground)
onground_playing = 1
end
landed = 1
end
if flaps > 0 and spd < 40 and gnd_stat ~= 0 and pft_played == 0 and viewext == 0 and paused == 0 and announcements_enabled == 1 then
play_sound(ccpftf)
if taximusic_playing == 1 then stop_sound(taximusic); taximusic_playing = 3 end
pft_played = 1
end
if gnd_stat > 1 and onground_playing == 0 and paused == 0 and viewext == 0 then if spd < 40 and spd > 2 or boarding_playing == 1 and taxi_and_gate_sounds_enabled == 1 then play_sound(onground); onground_playing = 1 end end
if thro > 0.75 and taximusic_playing == 1 then stop_sound(taximusic); taximusic_playing = 0 end
if seatbelt_sign_pos == 0 and stblt_poschg == 1 and announcements_enabled == 1 then	
play_sound(seatbeltsoff)
stblt_poschg = 0
end
if seatbelt_sign_pos == 1 and stblt_poschg == 0 and announcements_enabled == 1 then
if fpm < -150 and spd < 250 then play_sound(des_announcement) else
play_sound(seatbeltson)
end
stblt_poschg = 1
end
end
end


function passengersfx_tensecondlogic()
if dis == 0 then
if gnd_stat == 0 and boarding_playing == 1 or boarding_playing == 2 then stop_sound(boarding); boarding_playing = 3 end
if bfr ~= 1 then bfr = 1 end
if lavatory_flush_bugfixer ~= 10 then
lavatory_flush_bugfixer = lavatory_flush_bugfixer + 10
end
if smoke_in_cpit > 1 and paused == 0 and viewext == 0 then play_sound(pax_cough) end
--if paxoxy == 1 and paxoxy_played == false and gnd_stat == 0 then play_sound(paxoxyann); paxoxy_played = true end
if turb ~= 0 then
if turb <= 5 and turb_light_playing == 0 and alt > 200 and gnd_stat == 0 then
if turbannplayed == false then play_sound(turb_warn); turbannplayed = true end
play_sound(seatshakelight); turb_light_playing = 1; turb_hard_playing = 0
elseif turb >= 6 and turb_hard_playing == 0 and alt > 200 and gnd_stat == 0 then
if turbannplayed == false then play_sound(turb_warn); turbannplayed = true end
play_sound(seatshakehard); turb_hard_playing = 1; turb_light_playing = 0
end
else
if turb_light_playing == 1 then stop_sound(seatshakelight); turb_light_playing = 0 end
if turb_hard_playing == 1 then stop_sound(seatshakehard); turb_hard_playing = 0 end
end
if fpm < 30 and fpm > -30 and alt > 9000 and gnd_stat == 0 and seatbelt_sign_pos == 0 and viewext == 0 and paused == 0 and announcements_enabled == 1 then
if crz_announ_played == 0 then 
play_sound(crz_announcement)
crz_announ_played = 1
end
stop_sound(clbdes_ambience)
clbdes_playing = 0
if ambience_enabled == 1 then 
play_sound(cruise)
crzplaying = 1 
end

end
if fpm < -100 and seatbelt_sign_pos == 1 and landed == 2 then
if des_announ_played == 0 then stop_sound(cruise); des_announ_played = 1 end
if alt < 5800 and ambience_enabled == 1 then play_sound(clbdes_ambience); clbdes_playing = 1 end end
if fpm > 300 and alt > 50 and clbdes_playing == 0 then
if taximusic_playing == 1 then stop_sound(taximusic); taximusic_playing = 0 end
if ambience_enabled == 1 then play_sound(clbdes_ambience); clbdes_playing = 1 end
end
if spd > 1 and spd < 30 and gnd_stat > 1 then
if boarding_playing == 1 or boarding_playing == 2 then stop_sound(boarding) end
if taximusic_playing == 0 then
if spd > 5 and spd < 30 and gnd_stat > 1 and thro < 0.75 then if in_air_fpm == 9999 or in_air_fpm == 0 then play_sound(taximusic); taximusic_playing = 1 end end
end
end
if spd > 40 then stop_sound(onground); onground_playing = 0 end
if prb > 0 and spd < 2 and seatbelt_sign_pos == 0 and in_air_fpm ~= 9999 and in_air_fpm ~= 0 and aftergateplaying == 0 then
stop_sound(onground)
onground_playing = 0
play_sound(afterlanding)
if boarding_playing == 1 or boarding_playing == 2 then stop_sound(boarding); boarding_playing = 3 end
aftergateplaying = 1
end
rand = math.random(1, 18)
if fpm < 40 and fpm > 40 or gnd_stat > 1 then
if rand == 5 and paused == 0 and viewext == 0 and aftergateplaying == 0 and baby_crying_enabled == 1 then play_sound(babycry1) end
--if rand == 9 and paused == 0 and viewext == 0 and aftergateplaying == 0 and baby_crying_enabled == 1 then play_sound(babycry2) end
end
if rand == 10 and paused == 0 and viewext == 0 and in_air_fpm ~= 9999 and in_air_fpm ~= 0 then play_sound(chime_single) end
if rand == 7 and paused == 0 and viewext == 0 and fpm < 70 and fpm > -70 and seatbelt_sign_pos == 0 and gnd_stat == 0 and lavatory_flush_bugfixer == 10 then play_sound(flush2); lavatory_flush_bugfixer = 0 end
if rand == 12 and paused == 0 and viewext == 0 and fpm < 70 and fpm > -70 and seatbelt_sign_pos == 0 and gnd_stat == 0 and lavatory_flush_bugfixer == 10 then play_sound(flush1); lavatory_flush_bugfixer = 0 end
if rand == 16 and paused == 0 and viewext == 0 and seatbelt_sign_pos == 0 and fpm < 70 and fpm > -70 and gnd_stat == 0 then play_sound(footsteps) end
end
end
function passengersfx_framelogic()
if dis == 0 then
if g_force_lastsec > g_force + 1.7 or g_force_lastsec < g_force - 1.7 and bfr == 1 and turbulence_screams_enabled == 1 and bfr == 1 then
if viewext == 0 and paused == 0 and timer_sec == 2 then play_sound(turbulence_scream1); timer_sec = 0 end
g_force_lastsec = g_force
end
if viewext == 1 or paused == 1 then
if clbdes_playing == 1 then pause_sound(clbdes_ambience); clbdes_playing = 2 end
if crzplaying == 1 then pause_sound(cruise); crzplaying = 2 end
if aftergateplaying == 1 then pause_sound(afterlanding); aftergateplaying = 2 end
if onground_playing == 1 then pause_sound(onground); onground_playing = 2 end
if taximusic_playing == 1 then pause_sound(taximusic); taximusic_playing = 2 end
if turb_light_playing == 1 then pause_sound(seatshakelight); turb_light_playing = 2 end
if turb_hard_playing == 1 then pause_sound(seatshakehard); turb_hard_playing = 2 end
elseif viewext ~= 1 or paused ~= 1 then
if clbdes_playing == 2 then play_sound(clbdes_ambience); clbdes_playing = 1 end
if crzplaying == 2 then play_sound(cruise); crzplaying = 1 end
if aftergateplaying == 2 then play_sound(afterlanding); aftergateplaying = 1 end
if onground_playing == 2 then play_sound(onground); onground_playing = 1 end
if boarding_playing == 2 then play_sound(boarding); boarding_playing = 1 end
if taximusic_playing == 2 then play_sound(taximusic); taximusic_playing = 1 end
if turb_light_playing == 2 then play_sound(seatshakelight); turb_light_playing = 1 end
if turb_hard_playing == 2 then play_sound(seatshakehard); turb_hard_playing = 1 end
end
end
end

do_every_frame("passengersfx_framelogic()") -- run every frame

do_often("passengersfx_onesecondlogic()") -- run every second

do_often("passengersfx_dynamicsoundlevels()") -- run every second, may be switched to every frame soon

do_sometimes("passengersfx_tensecondlogic()") -- run every ten seconds

do_on_exit("unload_all_sounds()") -- done on LUA engine exit

print("PassengersFX version 1.0.0 by mcpcfanc for X-Plane loaded successfully.")
end