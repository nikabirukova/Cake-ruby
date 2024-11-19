def extract_cake(cake)
  cake.strip.split("\n").map(&:chars)
end

def locate_raisins(cake)
  raisins = []
  cake.each_with_index do |row, r|
    row.each_with_index do |cell, c|
      raisins << [r, c] if cell == 'o'
    end
  end
  raisins
end

def is_valid_cut?(cake, slices)
  total_area = cake.size * cake[0].size
  slice_areas = slices.map { |slice| slice.size * slice[0].size }
  return false unless slice_areas.sum == total_area

  raisin_groups = slices.map { |slice| locate_raisins(slice) }
  raisin_groups.all? { |raisins| raisins.size == 1 }
end

def divide_horizontally(cake, raisins)
  pieces = []
  last_row = 0

  raisins.each do |r, _|
    pieces << cake[last_row..r]
    last_row = r + 1
  end

  pieces
end

def divide_vertically(cake, raisins)
  transposed_cake = cake.transpose
  transposed_raisins = raisins.map(&:reverse)
  transposed_pieces = divide_horizontally(transposed_cake, transposed_raisins)
  transposed_pieces.map(&:transpose)
end

def slice_cake(input)
  cake = extract_cake(input)
  raisins = locate_raisins(cake)

  puts "Цілий пиріг:"
  cake.each { |row| puts row.join }
  puts

  horizontal_slices = divide_horizontally(cake, raisins)
  if is_valid_cut?(cake, horizontal_slices)
    return horizontal_slices
  end

  vertical_slices = divide_vertically(cake, raisins)
  if is_valid_cut?(cake, vertical_slices)
    return vertical_slices
  end

  nil
end

cake = <<~CAKE
  .o......
  ......o.
  ....o...
  ..o.....
CAKE

result = slice_cake(cake)
if result
  result.each_with_index do |piece, index|
    puts "Шматок #{index + 1}:"
    piece.each { |row| puts row.join }
    puts
  end
else
  puts "Не знайдено валідних розрізів"
end

