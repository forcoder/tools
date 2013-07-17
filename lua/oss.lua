local host = ngx.var.host
local bucket = ""
bucket = string.gsub(host, "%.", "_") .. "_aliyun_ce_storage"
local default_host = "oss.aliyuncs.com"
local new_host = bucket .. "." .. default_host 
local oss_uri = "/" .. bucket .. ngx.var.request_uri
local script_name = ngx.var.uri
local resource = "/" .. bucket .. script_name
local query_string = ngx.var.query_string
local content_md5 = ""
if ngx.var.content_md5 then
    content_md5 = ngx.var.content_md5
end
local content_type = ""
if ngx.var.content_type then
    content_type = ngx.var.content_type
end
local id = "*****"
local key = "**********"
local date = os.date("!%a, %d %b %Y %H:%M:%S GMT", os.time())
local method = "GET"
local provider = "OSS"
local self_define_header_prefix = "x-oss-"

ngx.log(ngx.DEBUG)

--format headers
function _format_headers(headers)
    local headers_formated = {}
    for key,val in pairs(headers) do
        if string.find(val, self_define_header_prefix) then
            headers_formated[key] = string.lower(val)
        else
            headers_formated[key] = val
        end
    end

    return headers_formated
end

function _get_resource(params)
    if params == nil then
        params = {}
        return ""
    end

    local tmp_header = {}
    local n = 0
    local keyset = {}
    for k,v in pairs(params) do
        tmp_k = string.gsub(string.lower(k), " ", "")
        tmp_header[tmp_k] = v 
        n = n+1
        keyset[n] = k
    end
    
    override_response_list = {'response-content-type', 'response-content-language','response-cache-control', 'logging', 'response-content-encoding', 'acl', 'uploadId', 'uploads', 'partNumber', 'group', 'delete', 'website', 'response-expires', 'response-content-disposition'}
    table.sort(override_response_list)
    local resource = ""
    local uri = ""
    local separator = "?"
    for k,v in pairs(override_response_list) do
        for h_k, h_v in pairs(tmp_header) do
            if h_k == string.lower(v) then
                resource = resource .. separator
                resource = resource .. v
                if (type(h_v) == "string" and (string.len(h_v) ~= 0)) or (type(h_v) == "table" and (#h_v ~= 0)) then
                    resource = resource .. "="
                    resource = resource .. string.lower(h_v)
                end

                separator = "&"
            end
        end
    end

    return resource    
end

--sign the headers and resource data
function _get_assign(method, headers, resource, result)
    local headers = ngx.req.get_headers()
    local canonicalized_oss_headers = ""
    local canonicalized_resource = resource
    headers_formated = _format_headers(headers)
    if #headers_formated > 0 then
        local keyset = {}
        local n = 0
        for k,v in pairs(headers_formated) do
            n = n+1
            keyset[n] = k
        end
        table.sort(keyset)

        for v in pairs(keyset) do
            if string.find(v, self_define_header_prefix) then
                canonicalized_oss_headers = canonicalized_oss_headers .. v .. ":" .. headers_formated[k] .. "\n"
            end
        end 
    end

    content_md5 = string.gsub(content_md5, " ", "")
    local string_to_sign = method .. "\n" .. content_md5 .. "\n" .. content_type .. "\n" .. date .. "\n" .. canonicalized_oss_headers .. canonicalized_resource
    ngx.log(ngx.DEBUG, "MyError:" .. string_to_sign)
    local digest = ngx.hmac_sha1(key, string_to_sign)
    ngx.log(ngx.DEBUG, "MyError:" .. digest)
    ngx.log(ngx.DEBUG, "MyError:" .. ngx.encode_base64(digest))
    return ngx.encode_base64(ngx.hmac_sha1(key, string_to_sign))
end

function split(str, delim, maxNb)   
    -- Eliminate bad cases...   
    if string.find(str, delim) == nil then  
        return { str }  
    end  
    if maxNb == nil or maxNb < 1 then  
        maxNb = 0    -- No limit   
    end  
    local result = {}  
    local pat = "(.-)" .. delim .. "()"   
    local nb = 0  
    local lastPos   
    for part, pos in string.gfind(str, pat) do  
        nb = nb + 1  
        result[nb] = part   
        lastPos = pos   
        if nb == maxNb then break end  
    end  
    -- Handle the last field   
    if nb ~= maxNb then  
        result[nb + 1] = string.sub(str, lastPos)   
    end  
    return result   
end  

ngx.req.set_header("Host", new_host)
ngx.req.set_header("Date", date)
if ((query_string ~= nil) and string.gsub(query_string, " ", "") ~= "") then  
    params_dict = split(query_string, "&")
end
params_resource = _get_resource(params_dict)
resource = resource .. params_resource
ngx.req.set_header("Authorization", provider .. " " .. id .. ":" .. _get_assign(method, ngx.req.get_headers(), resource))
ngx.var.oss_uri = oss_uri
