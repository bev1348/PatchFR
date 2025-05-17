-- CommuProtoBase
----------------------------------------------------------------
local class = require("core.class")
local util = require("core.functions")
local entity_types = require("core.types_entity")
local item_types = require("core.types_item")
local equip_types = require("core.types_equipment")
----------------------------------------------------------------
local constants = {
    COMMA = '-',
    TOKEN_EMPTY = "",
}
----------------------------------------------------------------


-- Recupère le type parmis tous les types d'items possible
local function getItemType(prototype_name, prototype_name_with_number)
    local tmp_type_item = nil
    --log("> Recherche du type d'item pour : ---| " .. prototype_name .. " |---")
    for i, type_name in pairs(item_types) do
        
        --log('> [getItemType] = type_name: ' .. tostring(type_name))
        
        local status = pcall(function()
            if data.raw[type_name][prototype_name] then 
                --log("> INFO: [getItemType]: type d'item trouvé pour [" .. tostring(prototype_name) .. "] => " .. type_name)
                tmp_type_item = type_name
            end
        end)


        local status = pcall(function()
            if (tmp_type_item == nil) then
                if data.raw[type_name][prototype_name_with_number] then 
                    --log("> INFO: [getItemType]: type d'item trouvé pour [" .. tostring(prototype_name) .. "] => " .. type_name)
                    tmp_type_item = type_name
                end
            end
        end)

        if (tmp_type_item ~= nil) then 
            break
        end
    end

    if (tmp_type_item == nil) then 
        log("> ERROR: [getItemType]: type d'item non trouvé pour [" .. tostring(prototype_name) .. "]")
    end

    return tmp_type_item
end


-- Recupère le type parmis tous les types d'entité possible
local function getEntityType(prototype_name, prototype_name_with_number)
    local tmp_type_entity = nil
    --log("> Recherche du type d'entity pour : ---| " .. prototype_name .. " |---")
    for i, type_name in pairs(entity_types) do
                
        local status = pcall(function()
            if data.raw[type_name][prototype_name] then 
                --log("> INFO: [getEntityType]: type d'entité trouvé pour [" .. tostring(prototype_name) .. "] => " .. type_name)
                tmp_type_entity = type_name
            end
        end)
        
        
        local status = pcall(function()
            if (tmp_type_entity == nil) then
                if data.raw[type_name][prototype_name_with_number] then 
                    --log("> INFO: [getEntityType]: type d'entité trouvé pour [" .. tostring(prototype_name_with_number) .. "] => " .. type_name)
                    tmp_type_entity = type_name
                end
            end
        end)

        if (tmp_type_entity ~= nil) then 
            break
        end

    end
    if (tmp_type_entity == nil) then
        log("> ERROR: [getEntityType]: type d'entité non trouvé pour [".. tostring(prototype_name) .. "]")
    end
    return tmp_type_entity
end

-- Recupère le type parmis tous les types d'entité possible
local function getEquipmentType(prototype_name, prototype_name_with_number)
    local tmp_type_equipment = nil
    --log("> Recherche du type d'equipment pour : ---| " .. prototype_name .. " |---")
    for i, type_name in pairs(equip_types) do
        
        --log('> [getEquipmentType] = type_name: ' .. type_name)
        
        local status = pcall(function()
            if data.raw[type_name][prototype_name] then 
                tmp_type_equipment = type_name
            end
        end)

        local status = pcall(function()
            if (tmp_type_equipment == nil) then
                if data.raw[type_name][prototype_name_with_number] then 
                    --log("> INFO: [getItemType]: type d'item trouvé pour [" .. tostring(prototype_name) .. "] => " .. type_name)
                    tmp_type_equipment = type_name
                end
            end
        end)

        if (tmp_type_equipment ~= nil) then 
            break
        end
    end

    if (tmp_type_equipment == nil) then
        log("> ERROR: [getEquipmentType]: type d'équipement non trouvé pour [" .. tostring(prototype_name) .. "]")
    end

    return tmp_type_equipment
end

-- récupère le bon type de prototype selon un type générique
local function getType(prototype_type, prototype_name, prototype_name_with_number)
    local rType
    --------------------------------------------------
    if prototype_type == 'item' then 
        rType = getItemType(prototype_name, prototype_name_with_number)
    elseif prototype_type == 'entity' then 
        rType = getEntityType(prototype_name, prototype_name_with_number)
    elseif prototype_type == 'equipment' then 
        rType = getEquipmentType(prototype_name, prototype_name_with_number)
    elseif prototype_type == 'decorative' then 
        rType = "optimized-decorative"
    elseif prototype_type == "controls" then 
        rType = "custom-input"
    else
        rType = prototype_type
    end
    --------------------------------------------------
    return rType
end

-- Ajoute "-1" à la fin du nom de prototype
local function getVariantName(name)
    return name .. constants.COMMA .. tostring(1)
end


----------------------------------------------------------------
local CommuPrototype = class.newclass(function(self, prototype_name, prototype_type)
    --log(">>> LOAD prototype[" .. prototype_type.."][" .. prototype_name.."]")
    -- prototype base
    self.object_name = "CommuPrototype"
    self.prototype_name = prototype_name
    self.name = prototype_name
    self.type_select = prototype_type
    self.type = getType(prototype_type, prototype_name, getVariantName(prototype_name))
    --------------------------------------------------
    if self.type == nil then 
        log('> Erreur localisation: type: '.. prototype_type ..' | name: '.. prototype_name)
        return 
    end
    --------------------------------------------------
    self.variant_level = 1
    self.proto_variant_name = getVariantName(self.name)
    self.prototype_with_level = false
    --------------------------------------------------
    -- prototype load

    -- Vérification si c'est une techno avec plusieurs niveau
    if data.raw[self.type][self.name] == nil then 
        log("> WARN: data.raw["..self.type.."]["..self.name.."] -> retourne nil ! Recherche de variant...")
        -- Vérification si c'est une techno avec plusieurs niveau
        if self.type == "technology" and data.raw[self.type][self.proto_variant_name] == nil then
            log("> ERROR: Variant non trouvé !")
            return
        else
            if util.isNil(data.raw[self.type][self.proto_variant_name]) == false then 
                self.prototype_with_level = true
            end
        end

        -- Vérification si c'est un item avec plusieurs variants
        if self.type_select == "item" and data.raw[self.type][self.proto_variant_name] == nil then
            log("> ERROR: Variant non trouvé !")
            return
        else
            if util.isNil(data.raw[self.type][self.proto_variant_name]) == false then 
                self.prototype_with_level = true
            end
        end

        -- Vérification si c'est une entité avec plusieurs variants
        if self.type_select == "entity" and data.raw[self.type][self.proto_variant_name] == nil then
            log("> ERROR: Variant non trouvé !")
            return
        else
            if util.isNil(data.raw[self.type][self.proto_variant_name]) == false then 
                self.prototype_with_level = true
            end
        end
    end


    self.prototype = table.deepcopy(data.raw[self.type][self.name])
    if self.prototype == nil then 
        self.prototype = table.deepcopy(data.raw[self.type][self.proto_variant_name])
    end
    --------------------------------------------------
    self.start = {
        entity = "__ENTITY__",
        tile = "__TILE__",
        fluid = "__FLUID__",
        item = "__ITEM__",
    }
    self.pattern = {
        entity = "__ENTITY__(.+)__",
        tile = "__TILE__(.+)__",
        fluid = "__FLUID__(.+)__",
        item = "__ITEM__(.+)__",
    }
    --------------------------------------------------
end)



function CommuPrototype:getName()
    if util.isTrue(self.prototype_with_level) then 
        return self.name .. constants.COMMA .. tostring(self.variant_level)
    else
        return self.name
    end
end



function CommuPrototype:getData()
    return data.raw[self.type][self:getName()]
end

function CommuPrototype:setData(pData)
    data.raw[self.type][self:getName()] = pData
end




-- CHANGE VALUE IN PARAMETER OF PROTOTYPE
function CommuPrototype:changePrototype() 
    if self.prototype == nil then return self end

    self:techLevelUp()
    self.prototype = table.deepcopy(self:getData())

    return self
end


function CommuPrototype:techLevelUp()
    self.variant_level = self.variant_level + 1
end


-- SET localised_name
function CommuPrototype:setLocalisedName(value)
    if self.prototype == nil then return self end
    --log("> "..self.type_select..": "..self.name..", localised_name: ".. serpent.block(value))

    if util.isTrue(self.prototype_with_level) then 
        repeat

            -- c'est la dernière tech
            if self:isInfinite() then
                self:localisedName(value)
                return self
            end

            self:localisedName(value .. ' ' .. tostring(self.variant_level))
            -- on charge la tech suivante
            self:changePrototype() 

        until self.prototype == nil
    else
        -- on est hors prototype avec plusieurs variant ou hors tech avec level
        self:localisedName(value)
    end
    
    return self
end


function CommuPrototype:localisedName(value)
    self.prototype.localised_name = value
    self:update() 
end


-- SET localised_description
function CommuPrototype:setLocalisedDescription(value) 
    if self.prototype == nil then return self end
    --log("> "..self.type_select..": "..self.name..", localised_description: '" .. value .. "'")

    if util.isTrue(self.prototype_with_level) then 
        repeat 
            self.prototype.localised_description = value
            self:update()
            self:changePrototype() 

            local max_level = ""

            pcall(function() max_level = self.prototype.max_level end)
            if max_level == "" then 
                break
            end

        until self.prototype == nil
    else
        self.prototype.localised_description = value
        self:update()
    end

    return self
end



function CommuPrototype:isInfinite()
    local max_level = ""
    local result = false

    pcall(function() max_level = self.prototype.max_level end)
    if max_level == "infinite" then
        result = true
    end

    return result
end







function CommuPrototype:localisedBuilderStartWith(value, typeBuilder) 
    return string.sub(value, 1, string.len(self.start[typeBuilder])) == self.start[typeBuilder]
end




function CommuPrototype:localisedBuilderMatched(value, typeBuilder) 
    local matched = false
    local typeName = ""
    local name = ""
    if self:localisedBuilderStartWith(value, typeBuilder) then
        name = string.match(value, self.pattern[typeBuilder])
        typeName = typeBuilder
        matched = true
    end
    return matched, typeName, name
end




function CommuPrototype:matchLocalisedBuilder(value)
    local matched = false
    local typeName = ""
    local name = ""

    local typeBuilder = "item"
    matched, typeName, name = self:localisedBuilderMatched(value, typeBuilder) 
    if matched then return matched, typeName, name end
    
    typeBuilder = "tile"
    matched, typeName, name  = self:localisedBuilderMatched(value, typeBuilder) 
    if matched then return matched, typeName, name end

    typeBuilder = "entity"
    matched, typeName, name  = self:localisedBuilderMatched(value, typeBuilder) 
    if matched then return matched, typeName, name end

    typeBuilder = "fluid"
    matched, typeName, name  = self:localisedBuilderMatched(value, typeBuilder) 
    return matched, typeName, name    
end








-- UPDATE PROTOTYPE
function CommuPrototype:update()
    --log('RitnPrototype:update() -> name : ' .. self.name)
    if self:getData() == nil then return self end
    if self.prototype == nil then return self end

    self:setData(self.prototype)
end


----------------------------------------------------------------
return CommuPrototype