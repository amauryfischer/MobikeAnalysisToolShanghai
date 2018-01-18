require('json')
require('byebug')
require('csv')

file = File.open('UTSEUS-MOBIKE-shanghai_full.csv')
parsed_file = CSV.parse file.read
file.close

hash = {}
parsed_file.each do |line|
  line[1]
  hash[line[1]] = 0 if hash[line[1]].nil?
  hash[line[1]] = hash[line[1]] + 1
end
output = {}
hash.keys.each do |key|
  output[hash[key]] = 0 if output[hash[key]].nil?
  output[hash[key]] = output[hash[key]] + 1
end
output = output.to_a.sort.to_h

file = File.open('keys.json', 'wb')
file.write output.keys.to_json
file.close

file = File.open('values.json', 'wb')
file.write output.values.to_json
file.close
