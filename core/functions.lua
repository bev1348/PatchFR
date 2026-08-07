-- if then else -> façon ternaire

---Aide façon ternaire. Renvoie `Then` si `Condition` est vraie, sinon `Else`. Si la valeur choisie
---est elle-même une fonction, elle est appelée et son résultat transmis à `tryCatch`.
---
---⚠ La branche « fonction » appelle `tryCatch`, **non défini** dans ce mod : utilitaire dormant
---recopié de RitnLib, conservé volontairement. Jamais atteinte en pratique — le seul appelant
---(`isNil`) passe des booléens, donc la branche `type(...) == "function"` ne se déclenche pas. Ce
---n'est pas un bug ; ne pas le définir ni le retirer (voir docs/audit/handoff.md §C.6).
---@param Condition any   Condition testée
---@param Then any        Valeur (ou fonction) renvoyée si `Condition` est vraie
---@param Else any        Valeur (ou fonction) renvoyée sinon
---@return any
local function ifElse(Condition, Then, Else)
    if Condition then 
        if type(Then) == "function" then 
            return tryCatch(Then())
        else
            return Then 
        end
    else 
        if type(Else) == "function" then 
            return tryCatch(Else())
        else
            return Else 
        end
    end
end


-- Retourne vrai si la valeur est un boolean

---Renvoie `true` si `value` est un booléen.
---@param value any
---@return boolean
local function isBoolean(value) 
    return (type(value) == "boolean")
end


-- Retourne vrai si la valeur est une string

---Renvoie `true` si `value` est une chaîne.
---@param value any
---@return boolean
local function isString(value) 
    return (type(value) == "string")
end


-- Retourne vrai si la valeur est un number

---Renvoie `true` si `value` est un nombre.
---@param value any
---@return boolean
local function isNumber(value) 
    return (type(value) == "number")
end


-- Retourne true si la chaine est égale à nil

---Renvoie `true` si `value` vaut `nil`. Fin wrapper au-dessus de `ifElse`.
---@param value any
---@return boolean
local function isNil(value)
    return ifElse(value == nil, true, false)
end



-- Retourne 'true' si value est égale à 'true' sinon false

---Renvoie `value` si c'est un booléen non-nil, sinon `false`. Toute valeur non-booléenne
---(string, number, table…) ou `nil` donne `false`.
---@param value any
---@return boolean
local function isTrue(value)
    local result = false 
    if isNil(value) == false then 
        if isBoolean(value) then 
            return value
        end
    end

    return result
end


----------------------------------------------
-- exports des fonctions
----------------------------------------------
return {
    ifElse = ifElse,
    isBoolean = isBoolean,
    isString = isString,
    isNumber = isNumber,
    isNil = isNil,
    isTrue = isTrue,
}
----------------------------------------------