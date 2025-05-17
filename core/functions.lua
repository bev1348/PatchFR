-- if then else -> façon ternaire
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
local function isBoolean(value) 
    return (type(value) == "boolean")
end


-- Retourne vrai si la valeur est une string
local function isString(value) 
    return (type(value) == "string")
end


-- Retourne vrai si la valeur est un number
local function isNumber(value) 
    return (type(value) == "number")
end


-- Retourne true si la chaine est égale à nil
local function isNil(value)
    return ifElse(value == nil, true, false)
end



-- Retourne 'true' si value est égale à 'true' sinon false
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