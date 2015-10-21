require 'helpers'

local matio = require 'matio'
matio.use_lua_strings = true

local speaker = 'FCJF0'

trainset = {}
ts = {}
ts['all'] = {}
ts['hs']  = {{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{}}
stats = {}

all_data = matio.load('timit/TRAIN/PHN_SPK/phn_spk.mat' % speaker)
min_length = math.max(poolsize + get_comp_lost(filt_sizes, 1), get_comp_lost(filt_sizes, 2))
max_length = 60
local count = 1
for name, data in pairs(all_data) do
    tdata = data:transpose(1,2)
    -- if tdata:size()[1] == 20 then
    if tdata:size()[1] > min_length and tdata:size()[1] < max_length then
        d, speaker, phn, idx = unpack(string.split(name, "_"))
        idx = tonumber(idx) + 1

        len = get_out_length(tdata, filt_sizes, poolsize)
        ts.all[#ts.all+1] = {tdata, phn, speaker, len}
        ts.hs[len][#ts.hs[len]+1] = count
        stats = addKey(stats, tdata:size()[1], 0)
        stats[tdata:size()[1]] = stats[tdata:size()[1]] + 1

        count = count + 1
    end
end
print ("Total Examples: ", count)
-- print ("Stats", stats)
