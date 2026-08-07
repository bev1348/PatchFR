-- core/detect-reused-keys.lua
----------------------------------------------------------------
-- Détecteur de « réutilisation de clé de localisation ».
--
-- Appelé DANS la boucle des mods de data-final-fixes, une fois par mod actif. Pour le mod courant, il
-- repère les prototypes qui affichent leur nom via une RÉFÉRENCE à la clé d'un AUTRE prototype
-- (ex. localised_name = { "item-name.copper-plate" } : une recette qui emprunte le nom d'un item),
-- lorsque ce mod corrige cette clé mais que le prototype emprunteur, lui, n'est pas traduit. Chaque
-- cas est tracé via log() pour le traducteur. Générique : aucun mod n'est traité en dur.
--
-- LECTURE SEULE : ne modifie jamais data.raw. Coût strictement au chargement (data-stage).
----------------------------------------------------------------
local mods_list    = require("prototypes.mods-list")
local item_types   = require("core.types_item")
local entity_types = require("core.types_entity")
local equip_types  = require("core.types_equipment")
----------------------------------------------------------------
local constants = {
    LOG_TAG     = "PATCHFR-TRAD",  -- préfixe filtrable des lignes de log destinées au traducteur
    NAME_SUFFIX = "-name",         -- suffixe des sections de nom Factorio (item-name, recipe-name…)
    DESC_SUFFIX = "-description",  -- suffixe des sections de description (hors périmètre : on ne traite que les noms)
}
-- Sections de nom qui ne suivent pas la convention "<type>-name" (cas particuliers).
local special_name_sections = {
    controls = "controls",
}
----------------------------------------------------------------


-- Traduit une clé de premier niveau d'une table mods/<x>.lua vers sa section locale de NOM.

---Ex. "item" -> "item-name" ; "item-name" -> "item-name". Renvoie nil pour une section de description.
---@param localization_key string  Clé de premier niveau d'une table de traduction ("item", "recipe-name"…)
---@return string?  Section de nom correspondante, ou nil si ce n'est pas une section de nom
local function getNameSection(localization_key)
    -- déjà une section de nom explicite ("…-name") : on la garde telle quelle
    if string.find(localization_key, constants.NAME_SUFFIX .. "$") then
        return localization_key
    end
    -- section de description : hors périmètre (seuls les noms sont concernés)
    if string.find(localization_key, constants.DESC_SUFFIX .. "$") then
        return nil
    end
    -- cas particulier connu (ex. "controls"), sinon convention "<type>" -> "<type>-name"
    return special_name_sections[localization_key] or (localization_key .. constants.NAME_SUFFIX)
end


-- Extrait (section, clé) d'un localised_name lorsqu'il s'agit d'une simple RÉFÉRENCE : { "section.clé" }.

---Renvoie nil pour tout le reste (nil, chaîne en dur, table composite {"", …}, référence paramétrée…).
---@param localised_name any  Champ localised_name lu sur un prototype de data.raw
---@return string?  section  Section locale référencée (ex. "item-name"), ou nil
---@return string?  key      Clé locale référencée (ex. "copper-plate"), ou nil
local function getReferencedKey(localised_name)
    -- une référence de clé est forcément une table
    if type(localised_name) ~= "table" then
        return nil
    end
    -- le 1er élément porte la clé ; s'il vaut "", c'est une table composite (concaténation), pas une référence
    local head = localised_name[1]
    -- on exige une table à un seul élément : chaîne non vide contenant un point (séparateur "section.clé")
    if type(head) == "string" and head ~= "" and string.find(head, "%.") and #localised_name == 1 then
        -- capture "section" avant le 1er point, "clé" après
        local section, key = string.match(head, "^([^.]+)%.(.+)$")
        return section, key
    end
    -- pas une référence exploitable
    return nil
end


-- Construit la liste des couples (sous-type data.raw, section de nom « propre » du prototype).

---Sert à parcourir data.raw et à connaître, pour chaque prototype, la clé qu'il POSSÈDE en propre.
---@return { prototype_subtype: string, name_section: string }[]
local function getScanGroups()
    local scan_groups = {}
    -- tous les sous-types d'items partagent la section [item-name]
    for _, subtype in pairs(item_types) do
        table.insert(scan_groups, { prototype_subtype = subtype, name_section = "item-name" })
    end
    -- tous les sous-types d'entités partagent la section [entity-name]
    for _, subtype in pairs(entity_types) do
        table.insert(scan_groups, { prototype_subtype = subtype, name_section = "entity-name" })
    end
    -- tous les sous-types d'équipements partagent la section [equipment-name]
    for _, subtype in pairs(equip_types) do
        table.insert(scan_groups, { prototype_subtype = subtype, name_section = "equipment-name" })
    end
    -- types restants, chacun à section unique
    table.insert(scan_groups, { prototype_subtype = "recipe",     name_section = "recipe-name" })
    table.insert(scan_groups, { prototype_subtype = "fluid",      name_section = "fluid-name" })
    table.insert(scan_groups, { prototype_subtype = "technology", name_section = "technology-name" })
    table.insert(scan_groups, { prototype_subtype = "tile",       name_section = "tile-name" })
    table.insert(scan_groups, { prototype_subtype = "item-group", name_section = "item-group-name" })
    return scan_groups
end


-- Construit l'index inverse des emprunts.

---Pour chaque clé "section.clé" référencée par un prototype qui n'est PAS la sienne, mémorise le(s)
---prototype(s) emprunteur(s) : borrowed_key_index[section][clé] = { { name_section, prototype_name }, … }.
---@return table<string, table<string, { name_section: string, prototype_name: string }[]>>
local function buildBorrowedKeyIndex()
    local borrowed_key_index = {}
    -- on parcourt chaque groupe (sous-type + section propre)
    for _, scan_group in pairs(getScanGroups()) do
        -- table de tous les prototypes de ce sous-type (peut être absente selon les mods chargés)
        local prototype_bucket = data.raw[scan_group.prototype_subtype]
        if prototype_bucket then
            -- on inspecte chaque prototype de ce sous-type
            for _, prototype in pairs(prototype_bucket) do
                -- protégé : un prototype exotique ne doit pas interrompre la détection
                pcall(function()
                    -- on ne traite que des prototypes nommés
                    if type(prototype) == "table" and prototype.name then
                        -- lit la clé éventuellement référencée par son localised_name
                        local section, key = getReferencedKey(prototype.localised_name)
                        -- vrai si le prototype référence sa PROPRE clé (cas normal, sans intérêt ici)
                        local is_own_key = (section == scan_group.name_section and key == prototype.name)
                        -- on ne retient que les emprunts ÉTRANGERS
                        if section and not is_own_key then
                            -- initialise les niveaux de l'index à la demande
                            borrowed_key_index[section]      = borrowed_key_index[section] or {}
                            borrowed_key_index[section][key] = borrowed_key_index[section][key] or {}
                            -- mémorise l'emprunteur : sa section propre et son nom
                            table.insert(borrowed_key_index[section][key], {
                                name_section   = scan_group.name_section,
                                prototype_name = prototype.name,
                            })
                        end
                    end
                end)
            end
        end
    end
    return borrowed_key_index
end


-- Construit l'ensemble des prototypes DÉJÀ traduits par une table PatchFR active.

---Permet d'exclure les emprunteurs qui sont, eux, correctement couverts.
---Résultat : translated_prototypes[section][prototype_name] = true.
---@return table<string, table<string, boolean>>
local function buildTranslatedPrototypes()
    local translated_prototypes = {}
    -- on balaie la liste des mods, mais seuls les mods actifs comptent
    for _, mod_name in pairs(mods_list) do
        if mods[mod_name] then
            -- charge la table de traduction du mod (protégé : fichier manquant / invalide toléré)
            local require_ok, localization = pcall(require, "mods." .. mod_name)
            if require_ok and type(localization) == "table" then
                -- chaque section de la table (item-name, recipe-name, …)
                for localization_key, entries in pairs(localization) do
                    local section = getNameSection(localization_key)
                    -- on ne retient que les sections de NOM avec un contenu de table valide
                    if section and type(entries) == "table" then
                        translated_prototypes[section] = translated_prototypes[section] or {}
                        -- chaque prototype traduit dans cette section est marqué « couvert »
                        for prototype_name in pairs(entries) do
                            translated_prototypes[section][prototype_name] = true
                        end
                    end
                end
            end
        end
    end
    return translated_prototypes
end


----------------------------------------------------------------
-- Index construits une seule fois, au premier appel, puis réutilisés à chaque itération de mod.
local borrowed_key_index     -- emprunts   : section.clé      -> prototypes emprunteurs
local translated_prototypes  -- couverture : section.protoype -> déjà traduit ?
----------------------------------------------------------------


-- Détection des réutilisations de clé pour le mod courant.

---Pour chaque clé de nom que CE mod corrige, on regarde qui l'emprunte : tout emprunteur non couvert
---est un trou de traduction, tracé pour le traducteur avec la valeur corrigée par ce mod. LECTURE SEULE.
---@param mod_name string     Mod PatchFR courant (fichier mods/<mod_name>.lua)
---@param localization table  Table de traduction du mod (require("mods."..mod_name))
return function(mod_name, localization)
    -- garde : rien à faire sans table de traduction exploitable
    if type(localization) ~= "table" then
        return
    end
    -- construction paresseuse des index : une seule fois pour tout le chargement, puis réutilisée
    borrowed_key_index    = borrowed_key_index    or buildBorrowedKeyIndex()
    translated_prototypes = translated_prototypes or buildTranslatedPrototypes()

    -- on parcourt chaque section de la table de traduction du mod
    for localization_key, entries in pairs(localization) do
        local section = getNameSection(localization_key)
        -- section de nom connue, avec des emprunteurs recensés, et un contenu de table valide
        if section and borrowed_key_index[section] and type(entries) == "table" then
            -- chaque prototype/valeur que ce mod corrige dans cette section
            for corrected_key, corrected_value in pairs(entries) do
                -- liste des prototypes qui empruntent cette clé (peut être nil)
                local borrowers = borrowed_key_index[section][corrected_key]
                if borrowers then
                    -- valeur affichable (une LocalisedString en table n'est pas du texte simple)
                    local shown_value = type(corrected_value) == "string"
                        and corrected_value or "(valeur non textuelle)"
                    -- on trace chaque emprunteur qui n'est pas déjà traduit ailleurs
                    for _, borrower in pairs(borrowers) do
                        -- vrai si l'emprunteur possède déjà sa propre traduction PatchFR
                        local is_covered = translated_prototypes[borrower.name_section]
                            and translated_prototypes[borrower.name_section][borrower.prototype_name]
                        if not is_covered then
                            -- ligne traducteur : proto emprunteur (section - nom), clé empruntée
                            -- (section, clé), et valeur corrigée par ce mod
                            log(string.format(
                                "[%s][%s] Réutilisation de clé : %s - %s (%s, %s)  →  \"%s\"",
                                constants.LOG_TAG, mod_name,
                                borrower.name_section, borrower.prototype_name,
                                section, corrected_key, shown_value))
                        end
                    end
                end
            end
        end
    end
end
