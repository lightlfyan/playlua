-- author:yz
-- why use oop?

_allclass = {}

meta = {
    __index = function ( t, k , ...)
        print("__index with: ", t, k, ...)


        local f = rawget(t, k) or function ( ... )
            local base = rawget(t, "base")
            
            if k ~= "new" and base then
                print("call base==============: ", base)
                return base[k]
            else
                print("not found function: ", k, ...)
                return nil
            end
        end

        if type(f) == "function" then
            return f(...)
        else
            return f
        end
    end,

    __call = function ( self, ... )
        print("call what: ", self, ...)
        local obj = getmetatable(self).__index(self, "new", ...)
        local base = rawget(self, "base")
        
        if obj then
            if base then
                rawset(obj, "base", base(...))
            end

            setmetatable(obj, {__index =_allclass[self]})
            return obj
        end

        if not obj and base then
            obj = base(...)            
            rawset(obj, "base", obj)
            setmetatable(obj, {__index = _allclass[self]})
            return obj
        end

        return nil
    end

}

-- use 

function makeobj( base )
    local obj = {}
    _allclass[obj] = obj
    obj.base = base or nil

    setmetatable(obj, meta)
    return obj
end

--- class1
classperson = makeobj()

function classperson.new( ... )
    local a,b,c = ...
    local data = {name=a, age=b, sex=c}
    return data
end

function classperson.out( self )
    print(string.format("name:%s age:%s sex:%s", self.name, self.age, self.sex))
end

local instance = classperson(1,2,3)
instance:out()


-- class 2
classperson2 = makeobj(classperson)
-- overload
function classperson2.out( ... )
    print("nothing")
end

local instance2 = classperson2(5,6,7)
instance2:out()
