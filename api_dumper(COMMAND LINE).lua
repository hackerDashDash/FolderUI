local HttpService = game:GetService("HttpService")
local API_DUMP = HttpService:GetAsync("https://raw.githubusercontent.com/hackerDashDash/FolderUI/main/apidump.json")
API_DUMP = HttpService:JSONDecode(API_DUMP)
local Script = game.ReplicatedStorage.ModuleScript
local classes = {}
for i, v in pairs(API_DUMP.Classes) do
    local propts = {}
    if v.Name then
        for ii, vv in pairs(v.Members) do
            local isService,nc = false, false
            if vv.Tags then
                if table.find(vv,"Service") then
                    isService = true
                end
                if table.find(vv,"NotCreatable") then
                    nc = true
                end
            end
            if isService or nc then break end
            if vv.MemberType == "Property" then
                table.insert(propts, vv.Name)
            end
        end
        classes[v.Name] = propts
    end 
end
function PrintTable(tb, atIndent)
    if tb.Print then
      return tb.Print()
    end
    atIndent = atIndent or 0
    local useNewlines = (#(tb) > 1)
    local baseIndent = string.rep('    ', atIndent+1)
    local out = "{"..(useNewlines and '\n' or '')
    for k, v in pairs(tb) do
      if type(v) ~= 'function' then
        out = out..(useNewlines and baseIndent or '')
        if type(k) == 'number' then
        elseif type(k) == 'string' and k:match("^[A-Za-z_][A-Za-z0-9_]*$") then 
          out = out..k.." = "
        elseif type(k) == 'string' then
          out = out.."[\""..k.."\"] = "
        else
          out = out.."["..tostring(k).."] = "
        end
        if type(v) == 'string' then
          out = out.."\""..v.."\""
        elseif type(v) == 'number' then
          out = out..v
        elseif type(v) == 'table' then
          out = out..PrintTable(v, atIndent+(useNewlines and 1 or 0))
        else
          out = out..tostring(v)
        end
        if next(tb, k) then
          out = out..","
        end
        if useNewlines then
          out = out..'\n'
        end
      end
    end
    out = out..(useNewlines and string.rep('    ', atIndent) or '').."}"
    return out
  end
Script.Source = "getgenv().Classes = "..PrintTable(classes)