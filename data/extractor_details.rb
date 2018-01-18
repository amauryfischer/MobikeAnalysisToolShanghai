require('json')
require('byebug')
require('csv')
require('date')
@max_distance = 0
@min_distance = 99999
@max_time = 0
@min_time = 9999
def calcul_distance(x1:,x2:,y1:,y2:)
  res = (Math.sqrt((x2.to_f - x1.to_f) ** 2 + (y2.to_f - y1.to_f) ** 2)).to_s
  @max_distance = res unless res.to_f < @max_distance.to_f
  @min_distance = res unless res.to_f > @min_distance.to_f
  res
end

def calc_time(start:,fin:)
  res = DateTime.parse(fin) - DateTime.parse(start)
  @max_time = res unless res < @max_time
  @min_time = res unless res < @min_time
  res
end

def calc_move(array_coo)
  res = array_coo.map do |cooxy|
    cooxy.split(',')
  end
  sum_x = 0.0
  sum_y = 0.0
  res.each do |r|
    sum_x += r.first.to_f
    sum_y += r.last.to_f
  end
  {
    x: sum_x / res.count,
    y: sum_y / res.count
  }
end

file = File.open('UTSEUS-MOBIKE-shanghai_full.csv')
parsed_file = CSV.parse file.read
file.close

header = parsed_file.shift
out = parsed_file.map do |parsed_line|
  h = header.zip(parsed_line).to_h
  {
    bikeid: h["bikeid"],
    distance: calcul_distance(
      x1: h["start_location_x"],
      y1: h["start_location_y"],
      x2: h["end_location_x"],
      y2: h["end_location_y"]
    ),
    time: calc_time(
      start: h["start_time"],
      fin: h["end_time"]
    ),
    average_move: calc_move(h["track"].split('#'))
  }
end

file = File.open("mobike_details.json","wb")
file.write(out.to_json)
file.close


file = File.open('stats.json','wb')
file.write({
  max_distance: @max_distance,
  min_distance: @min_distance,
  max_time: @max_time,
  min_time: @min_time
}.to_json)
