ERP.Properties = {};

setmetatable(ERP.Properties,{
  __index=function(tbl,key)
    if not key then return nil end

    if type(key) == "number" then
      return rawget(tbl,key);
    end

    for k,v in ipairs(tbl)do
      if v.name == key then
        return v;
      end
    end

    return nil
  end
})
