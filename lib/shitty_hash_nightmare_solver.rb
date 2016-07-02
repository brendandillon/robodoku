class Solver

  def initialize(puzzle_text)
    @grid_locations = {}
    @all_possibilities = {}
    @puzzle_text = puzzle_text
    @top_left =     ["1a", "2a", "3a", "1b", "2b", "3b", "1c", "2c", "3c"]
    @top_center =   ["4a", "5a", "6a", "4b", "5b", "6b", "4c", "5c", "6c"]
    @top_right =    ["7a", "8a", "9a", "7b", "8b", "9b", "7c", "8c", "9c"]
    @middle_left =  ["1d", "2d", "3d", "1e", "2e", "3e", "1f", "2f", "3f"]
    @middle_center =["4d", "5d", "6d", "4e", "5e", "6e", "4f", "5f", "6f"]
    @middle_right = ["7d", "8d", "9d", "7e", "8e", "9e", "7f", "8f", "9f"]
    @bottom_left =  ["1g", "2g", "3g", "1h", "2h", "3h", "1j", "2j", "3j"]
    @bottom_center =["4g", "5g", "6g", "4h", "5h", "6h", "4j", "5j", "6j"]
    @bottom_right = ["7g", "8g", "9g", "7h", "8h", "9h", "7j", "8j", "9j"]

  end

  def parse  # loads each character into the @grid_locations hash
    parse_col = 1
    parse_row = 97  # Encoding for "a"
    @puzzle_text.each_char do |character|
      coordinate = ""
      # increments row and resets column
      if character == "\n"
        # fills in spaces at the end when there is a line break before column 9
        while parse_col <= 9
          coordinate << parse_col
          coordinate << parse_row.chr
          parse_col += 1
          @grid_locations[coordinate] = " "
        end
        parse_row += 1
        parse_col = 1
        next
      end
      coordinate << parse_col.to_s
      coordinate << parse_row.chr
      parse_col += 1
      @grid_locations[coordinate] = character
    end
  end

  def get_row(cell)
    row = cell[0]
  end

  def get_col(cell)
    col = cell[1]
  end

  def get_block(block_row, block_col)
    block = Array.new
    block_row.to_i
    block_col.to_i
    block_col -= 96
    which = []
    top_left = [0,0]
    top_center = [0,1]
    top_right = [0,2]
    middle_left = [1,0]
    middle_center = [1,1]
    middle_right = [1,2]
    bottom_left = [2,0]
    bottom_center = [2,1]
    bottom_right = [2,2]
    p block_row
    p block_col
    # if (block_col == "a") || (block_col == "b") || (block_col == "c")
    #   if (block_row == "1") || (block_row == "2") || (block_col =="3")
    #     block = @top_left.clone
    #   elsif (block_row == "4") || (block_row == "5") || (block_row == "6")
    #     block = @top_center.clone
    #   elsif (block_row == "7") || (block_row == "8") || (block_row == "9")
    #     block = @top_left.clone
    #   end
    # elsif (block_col == "d") || (block_col == "e") || (block_col == "f")
    #   if (block_row == "1") || (block_row == "2") || (block_row == "3")
    #     block = @middle_left.clone
    #   elsif (block_row == "4") || (block_row == "5") || (block_row == "6")
    #     block = @middle_center.clone
    #   elsif (block_row == "7") || (block_row == "8") || (block_row == "9")
    #     block = @middle_right.clone
    #   end
    # elsif (block_col == "g") || (block_col == "h") || (block_col == "i")
    #   if (block_row == "1") || (block_row == "2") || (block_row == "3")
    #   elsif (block_row == "4") || (block_row == "5") || (block_row == "6")
    #     block = @bottom_center.clone
    #   elsif (block_row == "7") || (block_row == "8") || (block_row == "9")
    #     block = @bottom_right.clone
    #   end
    # end
    row_position = block_row % 3
    col_position = block_row % 3
    position = row_position * col_position
    block_row.to_s
    block_col += 96
    block_col.chr
    if position == 0
      block << [block_row, block_col]
      block <<

    p block
    return block
  end

  def compare_with_row(comp_row) # finds rest of values in the row
    this_row = comp_row
    rest_of_row = @grid_locations.select { |key,value| key.include?(comp_row) }.values
    return rest_of_row
  end

  def compare_with_col(comp_col) # finds rest of values in the column
    this_col = comp_col
    rest_of_col = @grid_locations.select { |key,value| key.include?(comp_col) }.values
    return rest_of_col
  end

  def compare_with_block(comp_block) # finds rest of values in the block
    rest_of_block = []

    comp_block.each do |coordinate|
      rest_of_block << @grid_locations[coordinate]
    end

    return rest_of_block
  end


  def get_possiblities(poss_row, poss_col, poss_block) # returns all possible values for a cell
    possible = ("1".."9").to_a
    possible -= compare_with_col(poss_col)
    possible -= compare_with_row(poss_row)
    possible -= compare_with_block(poss_block)
  end

  def compare_possibilities_with_row(comp_poss_row) # finds rest of possibilities in row
    rest_of_row = @all_possibilities.select { |key,value| key.include?(comp_poss_row) }.values.uniq
    return rest_of_row.flatten
  end

  def compare_possibilities_with_col(comp_poss_col) # finds rest of possibilities in column
    rest_of_col = @all_possibilities.select { |key,value| key.include?(comp_poss_col) }.values.uniq
    return rest_of_col.flatten
  end

  def compare_possibilities_with_block(comp_poss_block, comp_poss_cell) # finds rest of possibilities in block
    look_in_this_block = comp_poss_block.clone
    look_in_this_block.delete(comp_poss_cell)
    rest_of_block = []
    comp_poss_block.each do |coordinate|
      rest_of_block << @all_possibilities[coordinate]
    end
    return rest_of_block.flatten
  end

  def get_inevitabilities(inev_row, inev_col, inev_block, inev_cell) # returns values that are nowhere else in the peer
    inevitable = []
    row_possibilities = compare_possibilities_with_row(inev_row)
    col_possibilities = compare_possibilities_with_col(inev_col)
    block_possibilities = compare_possibilities_with_block(inev_block, inev_cell)
    all_values = ("1".."9").to_a
    # p inev_row
    # p inev_col
    # p inev_block
    # p "possible? lets see"
    # p all_values - row_possibilities
    # p all_values - col_possibilities
    # p all_values - block_possibilities
    inevitable << all_values - row_possibilities
    inevitable << all_values - col_possibilities
    inevitable << all_values - block_possibilities
    return inevitable
  end

  def solve()
    parse
    while @grid_locations.has_value?(" ")
      @grid_locations.each do |key, value|
        this_cell = key
        if value != " "
          @all_possibilities[key] = value
          next
        else
          a_row = get_row(key)
          a_col = get_col(key)
          a_block = get_block(a_row, a_col)
          this_possibilities = get_possiblities(a_row, a_col, a_block)
          @all_possibilities[key] = this_possibilities
          if this_possibilities.length == 1
            @grid_locations[key] = this_possibilities[0]
          end
        end
      end
      @all_possibilities.each do |key, value|
        this_cell = key
        if value.length == 1
          next
        else
          b_row = get_row(key)
          b_col = get_col(key)
          b_block = get_block(b_row, b_col)
          @grid_locations[key] = get_inevitabilities(b_row, b_col, b_block, key).join
        end
      end
    end
    output = ""
    values_by_row.each_slice(9) {|line| output << (line.join + "\n") }
    return output
  end
end
