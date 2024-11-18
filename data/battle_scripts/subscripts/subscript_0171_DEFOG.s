.include "asm/include/battle_commands.inc"

.data

// defog updated to clear terrains and such

_000:
    CheckSideCondition BATTLER_CATEGORY_DEFENDER, CHECK_SIDE_COND_VAL_NOT_ZERO, SIDE_COND_REFLECT_TURNS, _playMoveAndAnim
    CheckSideCondition BATTLER_CATEGORY_DEFENDER, CHECK_SIDE_COND_VAL_NOT_ZERO, SIDE_COND_LIGHT_SCREEN_TURNS, _playMoveAndAnim
    CheckSideCondition BATTLER_CATEGORY_DEFENDER, CHECK_SIDE_COND_VAL_NOT_ZERO, SIDE_COND_MIST_TURNS, _playMoveAndAnim
    CheckSideCondition BATTLER_CATEGORY_DEFENDER, CHECK_SIDE_COND_VAL_NOT_ZERO, SIDE_COND_SAFEGUARD_TURNS, _playMoveAndAnim
    CheckSideCondition BATTLER_CATEGORY_DEFENDER, CHECK_SIDE_COND_VAL_NOT_ZERO, SIDE_COND_SPIKES_LAYERS, _playMoveAndAnim
    CheckSideCondition BATTLER_CATEGORY_DEFENDER, CHECK_SIDE_COND_VAL_NOT_ZERO, SIDE_COND_TOXIC_SPIKES_LAYERS, _playMoveAndAnim
    CompareVarToValue OPCODE_FLAG_SET, BSCRIPT_VAR_SIDE_CONDITION_TARGET, SIDE_CONDITION_STEALTH_ROCKS, _playMoveAndAnim
    CheckSideCondition BATTLER_CATEGORY_ATTACKER, CHECK_SIDE_COND_VAL_NOT_ZERO, SIDE_COND_SPIKES_LAYERS, _playMoveAndAnim
    CheckSideCondition BATTLER_CATEGORY_ATTACKER, CHECK_SIDE_COND_VAL_NOT_ZERO, SIDE_COND_TOXIC_SPIKES_LAYERS, _playMoveAndAnim
    CompareVarToValue OPCODE_FLAG_SET, BSCRIPT_VAR_SIDE_CONDITION_ATTACKER, SIDE_CONDITION_STEALTH_ROCKS, _playMoveAndAnim
    CompareVarToValue OPCODE_FLAG_SET, BSCRIPT_VAR_FIELD_CONDITION, FIELD_CONDITION_FOG, _playMoveAndAnim
    GotoIfTerrainOverlayIsType GRASSY_TERRAIN, _playMoveAndAnim
    GotoIfTerrainOverlayIsType MISTY_TERRAIN, _playMoveAndAnim
    GotoIfTerrainOverlayIsType ELECTRIC_TERRAIN, _playMoveAndAnim
    GotoIfTerrainOverlayIsType PSYCHIC_TERRAIN, _playMoveAndAnim
    GoTo _lowerEvasion

_playMoveAndAnim:
    Call BATTLE_SUBSCRIPT_ATTACK_MESSAGE_AND_ANIMATION

_lowerEvasion:
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_PARAM, MOVE_SUBSCRIPT_PTR_EVASION_DOWN_1_STAGE
    Call BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE
    CheckSideCondition BATTLER_CATEGORY_DEFENDER, CHECK_SIDE_COND_VAL_ZERO, SIDE_COND_REFLECT_TURNS, _clearLightScreen
    CheckSideCondition BATTLER_CATEGORY_DEFENDER, CHECK_SIDE_COND_CLEAR, SIDE_COND_REFLECT_TURNS, _clearLightScreen
    UpdateVar OPCODE_SET, BSCRIPT_VAR_MSG_MOVE_TEMP, MOVE_REFLECT
    Call BATTLE_SUBSCRIPT_DEFOG_MESSAGE

_clearLightScreen:
    CheckSideCondition BATTLER_CATEGORY_DEFENDER, CHECK_SIDE_COND_VAL_ZERO, SIDE_COND_LIGHT_SCREEN_TURNS, _clearMist
    CheckSideCondition BATTLER_CATEGORY_DEFENDER, CHECK_SIDE_COND_CLEAR, SIDE_COND_LIGHT_SCREEN_TURNS, _clearMist
    UpdateVar OPCODE_SET, BSCRIPT_VAR_MSG_MOVE_TEMP, MOVE_LIGHT_SCREEN
    Call BATTLE_SUBSCRIPT_DEFOG_MESSAGE

_clearMist:
    CheckSideCondition BATTLER_CATEGORY_DEFENDER, CHECK_SIDE_COND_VAL_ZERO, SIDE_COND_MIST_TURNS, _clearSafeguard
    CheckSideCondition BATTLER_CATEGORY_DEFENDER, CHECK_SIDE_COND_CLEAR, SIDE_COND_MIST_TURNS, _clearSafeguard
    UpdateVar OPCODE_SET, BSCRIPT_VAR_MSG_MOVE_TEMP, MOVE_MIST
    Call BATTLE_SUBSCRIPT_DEFOG_MESSAGE

_clearSafeguard:
    CheckSideCondition BATTLER_CATEGORY_DEFENDER, CHECK_SIDE_COND_VAL_ZERO, SIDE_COND_SAFEGUARD_TURNS, _clearSpikes
    CheckSideCondition BATTLER_CATEGORY_DEFENDER, CHECK_SIDE_COND_CLEAR, SIDE_COND_SAFEGUARD_TURNS, _clearSpikes
    UpdateVar OPCODE_SET, BSCRIPT_VAR_MSG_MOVE_TEMP, MOVE_SAFEGUARD
    Call BATTLE_SUBSCRIPT_DEFOG_MESSAGE

_clearSpikes:
    CheckSideCondition BATTLER_CATEGORY_DEFENDER, CHECK_SIDE_COND_VAL_ZERO, SIDE_COND_SPIKES_LAYERS, _clearPlayerSpikes
    CheckSideCondition BATTLER_CATEGORY_DEFENDER, CHECK_SIDE_COND_CLEAR, SIDE_COND_SPIKES_LAYERS, _clearPlayerSpikes
    UpdateVar OPCODE_FLAG_OFF, BSCRIPT_VAR_SIDE_CONDITION_TARGET, SIDE_CONDITION_SPIKES
    UpdateVar OPCODE_SET, BSCRIPT_VAR_MSG_MOVE_TEMP, MOVE_SPIKES
    Call BATTLE_SUBSCRIPT_DEFOG_MESSAGE

_clearPlayerSpikes:
    CheckSideCondition BATTLER_CATEGORY_ATTACKER, CHECK_SIDE_COND_VAL_ZERO, SIDE_COND_SPIKES_LAYERS, _clearToxicSpikes
    CheckSideCondition BATTLER_CATEGORY_ATTACKER, CHECK_SIDE_COND_CLEAR, SIDE_COND_SPIKES_LAYERS, _clearToxicSpikes
    UpdateVar OPCODE_FLAG_OFF, BSCRIPT_VAR_SIDE_CONDITION_ATTACKER, SIDE_CONDITION_SPIKES
    // if the message has already been printed, do not print it again
    CompareVarToValue OPCODE_EQU, BSCRIPT_VAR_MSG_MOVE_TEMP, MOVE_SPIKES, _clearToxicSpikes
    UpdateVar OPCODE_SET, BSCRIPT_VAR_MSG_MOVE_TEMP, MOVE_SPIKES
    Call BATTLE_SUBSCRIPT_DEFOG_MESSAGE

_clearToxicSpikes:
    CheckSideCondition BATTLER_CATEGORY_DEFENDER, CHECK_SIDE_COND_VAL_ZERO, SIDE_COND_TOXIC_SPIKES_LAYERS, _clearPlayerToxicSpikes
    CheckSideCondition BATTLER_CATEGORY_DEFENDER, CHECK_SIDE_COND_CLEAR, SIDE_COND_TOXIC_SPIKES_LAYERS, _clearPlayerToxicSpikes
    UpdateVar OPCODE_SET, BSCRIPT_VAR_MSG_MOVE_TEMP, MOVE_TOXIC_SPIKES
    Call BATTLE_SUBSCRIPT_DEFOG_MESSAGE

_clearPlayerToxicSpikes:
    CheckSideCondition BATTLER_CATEGORY_ATTACKER, CHECK_SIDE_COND_VAL_ZERO, SIDE_COND_TOXIC_SPIKES_LAYERS, _clearStealthRock
    CheckSideCondition BATTLER_CATEGORY_ATTACKER, CHECK_SIDE_COND_CLEAR, SIDE_COND_TOXIC_SPIKES_LAYERS, _clearStealthRock
    CompareVarToValue OPCODE_EQU, BSCRIPT_VAR_MSG_MOVE_TEMP, MOVE_TOXIC_SPIKES, _clearStealthRock
    UpdateVar OPCODE_SET, BSCRIPT_VAR_MSG_MOVE_TEMP, MOVE_TOXIC_SPIKES
    Call BATTLE_SUBSCRIPT_DEFOG_MESSAGE

_clearStealthRock:
    CompareVarToValue OPCODE_FLAG_NOT, BSCRIPT_VAR_SIDE_CONDITION_TARGET, SIDE_CONDITION_STEALTH_ROCKS, _clearPlayerStealthRock
    UpdateVar OPCODE_FLAG_OFF, BSCRIPT_VAR_SIDE_CONDITION_TARGET, SIDE_CONDITION_STEALTH_ROCKS
    UpdateVar OPCODE_SET, BSCRIPT_VAR_MSG_MOVE_TEMP, MOVE_STEALTH_ROCK
    Call BATTLE_SUBSCRIPT_DEFOG_MESSAGE

_clearPlayerStealthRock:
    CompareVarToValue OPCODE_FLAG_NOT, BSCRIPT_VAR_SIDE_CONDITION_ATTACKER, SIDE_CONDITION_STEALTH_ROCKS, _clearTerrain
    UpdateVar OPCODE_FLAG_OFF, BSCRIPT_VAR_SIDE_CONDITION_ATTACKER, SIDE_CONDITION_STEALTH_ROCKS
    CompareVarToValue OPCODE_EQU, BSCRIPT_VAR_MSG_MOVE_TEMP, MOVE_STEALTH_ROCK, _clearTerrain
    UpdateVar OPCODE_SET, BSCRIPT_VAR_MSG_MOVE_TEMP, MOVE_STEALTH_ROCK
    Call BATTLE_SUBSCRIPT_DEFOG_MESSAGE

_clearTerrain:
    GotoIfTerrainOverlayIsType GRASSY_TERRAIN, _clearGrassyTerrain
    GotoIfTerrainOverlayIsType MISTY_TERRAIN, _clearMistyTerrain
    GotoIfTerrainOverlayIsType ELECTRIC_TERRAIN, _clearElectricTerrain
    GotoIfTerrainOverlayIsType PSYCHIC_TERRAIN, _clearPsychicTerrain
    GoTo _clearFog

_clearGrassyTerrain:
    UpdateTerrainOverlay TRUE, _clearFog
    ChangePermanentBackground BATTLE_BG_CURRENT, TERRAIN_CURRENT
    UpdateVar OPCODE_SET, BSCRIPT_VAR_MSG_MOVE_TEMP, MOVE_GRASSY_TERRAIN
    Call BATTLE_SUBSCRIPT_DEFOG_MESSAGE
    GoTo _clearFog

_clearMistyTerrain:
    UpdateTerrainOverlay TRUE, _clearFog
    ChangePermanentBackground BATTLE_BG_CURRENT, TERRAIN_CURRENT
    UpdateVar OPCODE_SET, BSCRIPT_VAR_MSG_MOVE_TEMP, MOVE_MISTY_TERRAIN
    Call BATTLE_SUBSCRIPT_DEFOG_MESSAGE
    GoTo _clearFog

_clearElectricTerrain:
    UpdateTerrainOverlay TRUE, _clearFog
    ChangePermanentBackground BATTLE_BG_CURRENT, TERRAIN_CURRENT
    UpdateVar OPCODE_SET, BSCRIPT_VAR_MSG_MOVE_TEMP, MOVE_ELECTRIC_TERRAIN
    Call BATTLE_SUBSCRIPT_DEFOG_MESSAGE
    GoTo _clearFog

_clearPsychicTerrain:
    UpdateTerrainOverlay TRUE, _clearFog
    ChangePermanentBackground BATTLE_BG_CURRENT, TERRAIN_CURRENT
    UpdateVar OPCODE_SET, BSCRIPT_VAR_MSG_MOVE_TEMP, MOVE_PSYCHIC_TERRAIN
    Call BATTLE_SUBSCRIPT_DEFOG_MESSAGE

_clearFog:
    CompareVarToValue OPCODE_FLAG_NOT, BSCRIPT_VAR_FIELD_CONDITION, FIELD_CONDITION_FOG, _end
    UpdateVar OPCODE_FLAG_OFF, BSCRIPT_VAR_FIELD_CONDITION, FIELD_CONDITION_FOG
    // {0} blew away the deep fog with {1}!
    PrintMessage 1045, TAG_NICKNAME_MOVE, BATTLER_CATEGORY_ATTACKER, BATTLER_CATEGORY_ATTACKER
    Wait 
    WaitButtonABTime 30

_end:
    End 