local utils = require("utils")

-- TODO: This is not the producer.
-- The Producer is whatever that produces the arguments from the prompt.
-- This is just _part_ of the Producer.

local tokenize_string = function(str)
  local tokens = {}
  for token in str:gmatch("%S+") do
    table.insert(tokens, token)
  end

  return tokens
end

local run_extractors = function(tokens, ...)
  local extractors = {...}
  local result = utils.default_table(function() return {} end)

  for _, token in ipairs(tokens) do
    for _, extractor in ipairs(extractors) do
      local extracted = extractor(token)

      if extracted ~= nil then
        table.insert(result[extractor], extracted)

        break
      end
    end
  end

  return result
end

local function extract_excluded_term(token)
  if token:match("^!") then
    return "^(?!.*" .. token:gsub("^!", "") .. ")"
  end
end

local function extract_included_path(token)
  if token:match("^in:") then
    return token:gsub("^in:", "")
  end
end

local function extract_excluded_path(token)
  if token:match("^!in:") then
    return token:gsub("^!in:", "")
  end
end

local function extract_search_term(token)
  return token
end

local function build_args(directory, terms)
  local args = {}

  local terms_str = ""
  for _, word in ipairs(terms.excluded) do
    terms_str = terms_str .. word .. ".*"
  end

  for _, word in ipairs(terms.included) do
    terms_str = terms_str .. word .. ".*"
  end

  table.insert(args, terms_str)

  for _, dir in ipairs(directory.excluded) do
    table.insert(args, "--iglob")
    table.insert(args, "**!" .. dir .. "**")
  end

  for _, dir in ipairs(directory.included) do
    table.insert(args, "--iglob")
    table.insert(args, "**" .. dir .. "**")
  end

  return args
end

return function(prompt)
  local tokens = tokenize_string(prompt)

  local results = run_extractors(
    tokens,
    extract_excluded_path,
    extract_excluded_term,
    extract_included_path,
    extract_search_term
  )

  local directory = {
    included = results[extract_included_path],
    excluded = results[extract_excluded_path],
  }

  local terms = {
    excluded = results[extract_excluded_term],
    included = results[extract_search_term],
  }

  return build_args(directory, terms)
end
