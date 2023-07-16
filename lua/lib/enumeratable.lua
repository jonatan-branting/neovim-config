local Enumeratable = {}

function Enumeratable:new(items)
  local instance = {
    items = items,
  }

  setmetatable(instance, self)
  self.__index = self

  return instance
end

function Enumeratable:length()
  return #self.items
end

function Enumeratable:any()
  return self:length() > 0
end

function Enumeratable:to_table()
  return self.items
end

function Enumeratable:each(func)
  for _, item in ipairs(self.items) do
    func(item)
  end
end

function Enumeratable:map(func)
  local mapped = {}

  for _, item in ipairs(self.items) do
    table.insert(mapped, func(item))
  end

  return Enumeratable:new(mapped)
end

function Enumeratable:filter(func)
  local filtered = {}

  for _, item in ipairs(self.items) do
    if func(item) then
      table.insert(filtered, item)
    end
  end

  return Enumeratable:new(filtered)
end

function Enumeratable:select(func)
  return self:filter(func)
end

function Enumeratable:reduce(func, initial)
  local result = initial

  for _, item in ipairs(self.items) do
    result = func(result, item)
  end

  return result
end

function Enumeratable:find(func)
  for _, item in ipairs(self.items) do
    if func(item) then
      return item
    end
  end
end

function Enumeratable:last()
  return self.items[#self.items]
end

function Enumeratable:first()
  return self.items[1]
end

return Enumeratable
