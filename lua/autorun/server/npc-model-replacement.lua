local util_PrecacheModel = util.PrecacheModel
local util_IsValidModel = util.IsValidModel
local table_Random = table.Random
local timer_Simple = timer.Simple
local string_lower = string.lower
local isstring = isstring
local isnumber = isnumber
local istable = istable
local ipairs = ipairs
local math = math

local replaceTable = list.GetForEdit( "NPCModelReplacement" )

do

    local fileName = "npc-model-replacement.json"
    if file.Exists( fileName, "DATA" ) then
        local json = file.Read( fileName, "DATA" )
        if isstring( json ) then
            local data = util.JSONToTable( json )
            if istable( data ) then
                table.Merge( replaceTable, data )
            end
        end
    else
        file.Write( fileName, util.TableToJSON( {
            ["path/to/model"] = "path/to/other/model"
        }, true ) )
    end

end

hook.Add( "OnEntityCreated", "For God's sake, learn how to write code.", function( entity )
    if not entity:IsNPC() then return end

    timer_Simple( 0, function()
        if not entity:IsValid() then return end

        local modelPath = entity:GetModel()
        if not modelPath or #modelPath == 0 then
            return
        end

        modelPath = replaceTable[ string_lower( modelPath ) ]
        if not modelPath then return end

        local modelSkin, bodyGroups = true, true
        if istable( modelPath ) then
            local value = modelPath.ModelPath
            if isstring( value ) then
                modelPath = value
                modelSkin = modelPath.Skin
                bodyGroups = modelPath.BodyGroups
            else
                modelPath = table_Random( modelPath )
                if istable( modelPath ) then
                    value = modelPath.ModelPath
                    if isstring( value ) then
                        modelPath = value
                        modelSkin = modelPath.Skin
                        bodyGroups = modelPath.BodyGroups
                    end
                end
            end
        end

        if not isstring( modelPath ) then return end
        util_PrecacheModel( modelPath )

        if util_IsValidModel( modelPath ) then
            entity:SetModel( modelPath )

            if modelSkin then
                if istable( modelSkin ) then
                    local min, max = modelSkin[ 1 ], modelSkin[ 2 ]
                    if not isnumber( min ) then min = 0 end
                    if not isnumber( max ) then max = 1 end
                    entity:SetSkin( math.random( math.max( 0, min ), math.min( max, entity:SkinCount() ) ) )
                elseif isnumber( modelSkin ) then
                    entity:SetSkin( math.min( modelSkin, entity:SkinCount() ) )
                else
                    entity:SetSkin( math.random( 0, entity:SkinCount() ) )
                end
            end

            if bodyGroups then
                if istable( bodyGroups ) then
                    for _, bodygroup in ipairs( bodyGroups ) do
                        local value = bodygroup.value
                        if istable( value ) then
                            local min, max = value[ 1 ], value[ 2 ]
                            if not isnumber( min ) then min = 0 end
                            if not isnumber( max ) then max = 1 end
                            entity:SetBodygroup( bodygroup.id, math.random( math.max( 0, min ), math.max( 0, max ) ) )
                        elseif isnumber( value ) then
                            entity:SetBodygroup( bodygroup.id, value )
                        end
                    end
                elseif isstring( bodyGroups ) then
                    entity:SetBodyGroups( bodyGroups )
                else
                    for _, bodygroup in ipairs( entity:GetBodyGroups() ) do
                        entity:SetBodygroup( bodygroup.id, math.random( 0, bodygroup.num - 1 ) )
                    end
                end
            end
        end
    end )
end )