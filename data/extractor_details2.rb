require('json')
require('byebug')
require('csv')
require('date')

file = File.open("mobike_details.json")
json = JSON.parse file.read
file.close
file = File.open("values.json")
values = JSON.parse file.read
file.close
hash = {}
json.each do |l|
 hash[l["bikeid"]] = [] if hash[l["bikeid"]].nil?
 hash[l["bikeid"]].push l
end

res = {}
def distance_from_middle(x:,y:)
  Math.sqrt((x-@x)**2 + (y-@y)**2)
end
def to_percent(array)
  mMax = array.max
  mMin = array.min
  array.map do |val|
    ((val.to_f - mMin.to_f) / (mMax.to_f - mMin.to_f))*100
  end
end
def average(array)
  distance = 0.0
  time = 0.0
  x = 0.0
  y = 0.0
  array.each do |l|
    distance += l["distance"].to_f
    time += l["time"].to_f
    x += l["average_move"]["x"].to_f
    y += l["average_move"]["y"].to_f
  end
  {
    distance: distance / array.count.to_f,
    time: time / array.count.to_f,
    x: x / array.count.to_f,
    y: y / array.count.to_f
  }
end
def average2(array)
  distance = 0.0
  time = 0.0
  x = 0.0
  y = 0.0
  array.each do |l|
    distance += l[:distance].to_f
    time += l[:time].to_f
    x += l[:x].to_f
    y += l[:y].to_f
  end
  {
    distance: distance / array.count.to_f,
    time: time / array.count.to_f,
    x: x / array.count.to_f,
    y: y / array.count.to_f
  }
end
hash.keys.each do |key|
  number = hash[key].count
  res[number] = [] if res[number].nil?
  res[number].push(average(hash[key]))
end

out = {}
res.keys.each do |key|
  res[key] = average2(res[key])
end

res = res.sort.to_h
distances = []
times = []
away = []
@x = 0
@y = 0
@count = 0
@key_number = 0
res.keys.each do |key|
  @x += res[key][:x]*values[@key_number]
  @y += res[key][:y]*values[@key_number]
  @count += values[@key_number]
  @key_number += 1
end
@x = @x / @count
@y = @y / @count
res.keys.each do |key|
  distances.push res[key][:distance]
  times.push res[key][:time]
  away.push distance_from_middle(x: res[key][:x],y: res[key][:y])
end


file = File.open("distances.json","wb")
file.write(to_percent(distances).to_json)
file.close
file = File.open("times.json","wb")
file.write(to_percent(times).to_json)
file.close
file = File.open("away.json","wb")
file.write(to_percent(away).to_json)
file.close


file = File.open("numbers.json","wb")
file.write(to_percent(values).to_json)
file.close

#@x = 121.45090452839759
#@y = 31.249448413593324
