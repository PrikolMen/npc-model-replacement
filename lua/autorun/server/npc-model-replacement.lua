local replaceList = list.GetForEdit( "NPCModelReplacement" )
local timer_Simple = timer.Simple
local math_random = math.random
local ipairs = ipairs
local Model = Model

local fileName = "npc-model-replacement.json"
if file.Exists( fileName, "DATA" ) then
    local json = file.Read( fileName, "DATA" )
    if isstring( json ) then
        local data = util.JSONToTable( json )
        if istable( data ) then
            table.Merge( replaceList, data )
        end
    end
else
    file.Write( fileName, util.TableToJSON( {
        ["path/to/model"] = "path/to/other/model"
    }, true ) )
end

hook.Add( "OnEntityCreated", "For God's sake, learn how to write code.", function( entity )
    if not entity:IsNPC() then return end

    timer_Simple( 0, function()
        if not entity:IsValid() then return end

        local modelPath = replaceList[ entity:GetModel() ]
        if modelPath then
            entity:SetModel( Model( modelPath ) )
            entity:SetSkin( math_random( 0, entity:SkinCount() ) )
            for _, bodygroup in ipairs( entity:GetBodyGroups() ) do
                entity:SetBodygroup( bodygroup.id, math_random( 0, bodygroup.num - 1 ) )
            end
        end
    end )
end )