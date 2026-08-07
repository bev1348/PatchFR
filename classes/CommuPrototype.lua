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

---Cherche, parmi tous les sous-types d'items (`item_types`), le premier où le prototype existe dans
---`data.raw` — d'abord sous `prototype_name`, sinon sous la variante numérotée
---`prototype_name_with_number`. Sondage `pcall`-protégé (tous les sous-types n'existent pas).
---@param prototype_name string              Nom du prototype recherché
---@param prototype_name_with_number string  Nom de la variante numérotée (`nom-1`)
---@return string?  Sous-type d'item trouvé, ou nil (avec log d'erreur)
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

---Cherche, parmi tous les sous-types d'entités (`entity_types`), le premier où le prototype existe
---dans `data.raw` — d'abord sous `prototype_name`, sinon sous la variante numérotée
---`prototype_name_with_number`. Sondage `pcall`-protégé (tous les sous-types n'existent pas).
---@param prototype_name string              Nom du prototype recherché
---@param prototype_name_with_number string  Nom de la variante numérotée (`nom-1`)
---@return string?  Sous-type d'entité trouvé, ou nil (avec log d'erreur)
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

---Cherche, parmi tous les sous-types d'équipement (`equip_types`), le premier où le prototype existe
---dans `data.raw` — d'abord sous `prototype_name`, sinon sous la variante numérotée
---`prototype_name_with_number`. Sondage `pcall`-protégé (tous les sous-types n'existent pas).
---@param prototype_name string              Nom du prototype recherché
---@param prototype_name_with_number string  Nom de la variante numérotée (`nom-1`)
---@return string?  Sous-type d'équipement trouvé, ou nil (avec log d'erreur)
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

---Mappe un type générique vers le sous-type concret de `data.raw` : `item` / `entity` / `equipment`
---délèguent au scan correspondant ; `decorative` → `optimized-decorative` ; `controls` →
---`custom-input` ; tout autre type est renvoyé tel quel.
---@param prototype_type string              Type générique (`item` / `entity` / `equipment` / `decorative` / `controls` / …)
---@param prototype_name string              Nom du prototype recherché
---@param prototype_name_with_number string  Nom de la variante numérotée (`nom-1`)
---@return string?  Sous-type concret, ou nil si le scan délégué n'a rien résolu
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

---Renvoie le nom suffixé de la 1re variante numérotée : `name .. "-1"` (séparateur `constants.COMMA`).
---@param name string  Nom de base du prototype
---@return string  Nom de la 1re variante (`nom-1`)
local function getVariantName(name)
    return name .. constants.COMMA .. tostring(1)
end


----------------------------------------------------------------

---Wrapper temporaire d'un prototype `data.raw`. Résout le sous-type concret d'un prototype ciblé
---(item / entity / equipment / decorative / controls / …) puis y pose `localised_name` /
---`localised_description`, en gérant les variantes numérotées (`nom-N`) et la recherche infinie.
---
---⚠ Wrapper de chargement (data-stage) : jamais stocké, l'instance est jetée après usage — ses effets
---vivent dans `data.raw`. Si le type ou le prototype ne se résout pas, l'objet reste **inerte**
---(`self.type` / `self.prototype` == nil) et tous les setters font `return self` sans effet.
---@class CommuPrototype
---@field object_name "CommuPrototype"    Sentinelle d'identité
---@field prototype_name string           Nom de prototype ciblé (tel que reçu)
---@field name string                     Nom de prototype ciblé (identique à `prototype_name`)
---@field type_select string              Type générique reçu (`item` / `entity` / `equipment` / `controls` / …)
---@field type string?                    Sous-type concret résolu dans `data.raw` (nil si non résolu → objet inerte)
---@field variant_level uint              Niveau courant (démarre à 1) pour technos / variantes numérotées
---@field proto_variant_name string       `name .. "-1"` (nom de la 1re variante)
---@field prototype_with_level boolean    Vrai si le prototype existe sous forme numérotée `-N`
---@field prototype table?                Copie de travail (`table.deepcopy`) du prototype ciblé (nil → objet inerte)
---@field start table<string, string>     🚧 Inachevé / non câblé — préfixes de tokens (`__ITEM__`, …), utilisés seulement par le cluster `localisedBuilder*`
---@field pattern table<string, string>   🚧 Inachevé / non câblé — motifs de capture des tokens, utilisés seulement par le cluster `localisedBuilder*`
---@operator call(string, string): CommuPrototype
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



---Renvoie le nom du prototype à cibler dans `data.raw` : `name` seul, ou `name-<variant_level>`
---lorsque le prototype est numéroté (`prototype_with_level`).
---@return string
function CommuPrototype:getName()
    if util.isTrue(self.prototype_with_level) then 
        return self.name .. constants.COMMA .. tostring(self.variant_level)
    else
        return self.name
    end
end



---Lit l'entrée courante du prototype dans `data.raw` (au nom résolu par `:getName()`).
---@return table?  Prototype `data.raw[self.type][self:getName()]`, ou nil s'il n'existe pas
function CommuPrototype:getData()
    return data.raw[self.type][self:getName()]
end

---Écrit `pData` dans `data.raw` à l'emplacement du prototype courant (nom résolu par `:getName()`).
---@param pData table  Nouveau contenu du prototype
function CommuPrototype:setData(pData)
    data.raw[self.type][self:getName()] = pData
end




-- CHANGE VALUE IN PARAMETER OF PROTOTYPE

---Passe à la variante / au niveau suivant : incrémente `variant_level` puis recharge la copie de
---travail (`self.prototype`) depuis `data.raw` pour ce nouveau niveau. Sans effet si l'objet est inerte.
---@return CommuPrototype self  Chaînable
function CommuPrototype:changePrototype() 
    if self.prototype == nil then return self end

    self:techLevelUp()
    self.prototype = table.deepcopy(self:getData())

    return self
end


---Incrémente le niveau de variante courant (`variant_level`).
function CommuPrototype:techLevelUp()
    self.variant_level = self.variant_level + 1
end


-- SET localised_name

---Pose le nom localisé du prototype. Pour un prototype à niveaux (`prototype_with_level`), parcourt
---toutes les variantes : pose `"<valeur> <niveau>"` (ex. `"Foreuse 1"`, `"Foreuse 2"`), et pose la
---valeur **sans numéro** sur le dernier palier de recherche infinie (`:isInfinite()`). Sinon, pose la
---valeur telle quelle. Sans effet si l'objet est inerte.
---@param value LocalisedString  Nom à poser (chaîne simple, ou table `{clé, ...}`)
---@return CommuPrototype self   Chaînable
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


---Écrit `value` dans `prototype.localised_name` puis propage via `:update()`. Helper interne de
---`:setLocalisedName`.
---@param value LocalisedString  Nom à poser
function CommuPrototype:localisedName(value)
    self.prototype.localised_name = value
    self:update() 
end


-- SET localised_description

---Pose la description localisée du prototype. Pour un prototype à niveaux (`prototype_with_level`),
---parcourt les variantes en posant **la même description** à chaque niveau, et s'arrête au premier
---niveau sans `max_level`.
---
---⚠ Comportement voulu : la description reste **identique quel que soit le niveau** (contrairement à
---`:setLocalisedName` qui suffixe le numéro). Ce n'est pas un défaut (voir docs/audit/handoff.md §C.6).
---@param value LocalisedString  Description à poser (chaîne simple, ou table `{clé, ...}`)
---@return CommuPrototype self   Chaînable
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



---Indique si le prototype courant est une recherche / variante infinie
---(`prototype.max_level == "infinite"`). Sondage `pcall`-protégé (le champ peut être absent).
---@return boolean
function CommuPrototype:isInfinite()
    local max_level = ""
    local result = false

    pcall(function() max_level = self.prototype.max_level end)
    if max_level == "infinite" then
        result = true
    end

    return result
end







---🚧 **Inachevé / non câblé.** Teste si `value` commence par le préfixe de token de `typeBuilder`
---(`self.start[typeBuilder]`, ex. `__ITEM__`). Fait partie d'une tentative de parseur d'icônes
---(`__ITEM__…__`) **jamais reliée au flux** et conservée volontairement (voir docs/audit/handoff.md §C.6).
---@param value string        Chaîne à tester
---@param typeBuilder string  Clé de token : `"item"` / `"tile"` / `"fluid"` / `"entity"`
---@return boolean
function CommuPrototype:localisedBuilderStartWith(value, typeBuilder) 
    return string.sub(value, 1, string.len(self.start[typeBuilder])) == self.start[typeBuilder]
end




---🚧 **Inachevé / non câblé.** Si `value` commence par le token de `typeBuilder`, en extrait le nom
---capturé via `self.pattern[typeBuilder]`. Partie du cluster `localisedBuilder*`, gardé exprès mais
---non relié au flux (voir docs/audit/handoff.md §C.6).
---@param value string        Chaîne à analyser
---@param typeBuilder string  Clé de token : `"item"` / `"tile"` / `"fluid"` / `"entity"`
---@return boolean matched    Vrai si le token correspond
---@return string typeName    Type reconnu (`typeBuilder`) ou `""`
---@return string name        Nom capturé dans le token, ou `""`
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




---🚧 **Inachevé / non câblé.** Essaie successivement les tokens `item`, `tile`, `entity`, `fluid` sur
---`value` et renvoie la première correspondance. Point d'entrée du cluster `localisedBuilder*`, gardé
---exprès mais jamais appelé par le flux (voir docs/audit/handoff.md §C.6).
---@param value string       Chaîne à analyser
---@return boolean matched   Vrai si un token correspond
---@return string typeName   Type reconnu, ou `""`
---@return string name       Nom capturé, ou `""`
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

---Écrit la copie de travail `self.prototype` dans `data.raw` (via `:setData`) si l'entrée cible et la
---copie existent ; sort tôt sans écrire sinon.
---@return CommuPrototype? self  `self` sur sortie anticipée ; **rien** (nil) sur le chemin d'écriture normal
function CommuPrototype:update()
    --log('RitnPrototype:update() -> name : ' .. self.name)
    if self:getData() == nil then return self end
    if self.prototype == nil then return self end

    self:setData(self.prototype)
end


----------------------------------------------------------------
return CommuPrototype --[[@as CommuPrototype]]