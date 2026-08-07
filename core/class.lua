-- class.lua
-- Compatible with Lua 5.1 (not 5.0).

---@class RitnClassFactory
---@field newclass fun(super: table|fun(self: any, ...: any): any, init?: fun(self: any, ...: any): any): table

---Crée une nouvelle classe, avec héritage optionnel d'une classe parente.
---
---Usage :
--- ```lua
--- local A = newclass(function(self, arg) self.value = arg end)
--- local B = newclass(A, function(self, arg) A.init(self, arg); self.extra = 42 end)
--- local instance = B(10)
--- instance:is_a(A) -- true
--- ```
---
---La classe retournée est appelable : `MaClasse(args)` crée une instance et exécute `init`.
---Chaque instance reçoit une méthode `:is_a(klass)` qui remonte la chaîne `_super`.
---⚠ Les champs de la parente sont copiés en surface dans la classe enfant — les tables partagées restent partagées par référence.
---@param super table|fun(self: any, ...: any): any  Classe parente (héritage) ou fonction init (sans parent)
---@param init? fun(self: any, ...: any): any        Fonction init (requise seulement si le 1er argument est une classe parente)
---@return table  La nouvelle classe, avec constructeur `__call` et `:is_a()`
local function newclass(super, init)
  local c = {}    -- a new class instance
  if not init and type(super) == 'function' then
    init = super
    super = nil
  elseif type(super) == 'table' then
    -- our new class is a shallow copy of the super class!
    for i,v in pairs(super) do
      c[i] = v
    end
    c._super = super
  end
  -- the class will be the metatable for all its objects,
  -- and they will look up their methods in it.
  c.__index = c

  -- expose a constructor which can be called by <classname>(<args>)
  local mt = {}
  mt.__call = function(class_tbl, ...)
    local obj = {}
    setmetatable(obj,c)
    if init then
      init(obj,...)
    else
      -- make sure that any stuff from the super class is initialized!
      if super and super.init then
        super.init(obj, ...)
      end
    end
    return obj
  end
  c.init = init
  c.is_a = function(self, klass)
    local m = getmetatable(self)
    while m do
      if m == klass then return true end
      m = m._super
    end
    return false
  end
  setmetatable(c, mt)
  return c
end

-------------------------
---@type RitnClassFactory
local class = {newclass = newclass}
return class