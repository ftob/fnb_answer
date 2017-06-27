require 'benchmark'
require 'bigdecimal/math'
require 'pry'

# 1. Strict vs Loose mode
lbda = ->(x) { 2 * (x || 0) }
prc = proc { |x| 2 * (x || 0) }

puts 'Lambda one parameter'
begin
  lbda.call
rescue ArgumentError, NameError => error
  puts error
end
puts 'Proc one parameter'
prc.call

lbda = ->(x, y) { x + (y || 0) }
prc = proc { |x, y| x + (y || 0) }

puts 'Lambda two parameters'
begin
  lbda.call(1)
rescue ArgumentError, NameError => error
  puts error
end
puts 'Proc two parameters'
prc.call(1)


# 2. Performance test
#Rehearsal -------------------------------------------
#lambda    0.090000   0.000000   0.090000 (  0.092401)
#---------------------------------- total: 0.090000sec
#
#user     system      total        real
#lambda    0.090000   0.000000   0.090000 (  0.088797)
#Rehearsal -------------------------------------------
#proc      0.080000   0.000000   0.080000 (  0.089577)
#---------------------------------- total: 0.080000sec
#
#user     system      total        real
#proc      0.090000   0.000000   0.090000 (  0.089148)

data = *(1..1000000)

lbda = ->(x) { 2 * (x || 0) }
prc = proc { |x| 2 * (x || 0) }
Benchmark.bmbm(7) do |bm|
  bm.report('lambda') do
    data.each { |x| lbda.call(x) }
  end
end

Benchmark.bmbm(7) do |bm|
  bm.report('proc') do
    data.each { |x| prc.call(x) }
  end
end

puts 'Вывод в работе разницы нет'

# Method return

lbda = ->(x) { return 2 * (x || 0) }
prc = proc { |x| return 2 * (x || 0) }

def test(proc_method)
  d = proc_method.call(64)
  puts 'Все прошло как и задумывалось, результат -  ' + d.to_s
end

puts 'Call lambda'
test(lbda)

puts 'Call proc'
begin
  test(prc)
rescue LocalJumpError, NameError => err
  puts "А тут мы получаем LocalJumpError - " + err.to_s
end
