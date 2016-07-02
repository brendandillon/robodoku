class Solver

  def initialize(puzzle_text)
    @puzzle_text = puzzle_text
  end

  def parse
    lines = @puzzle_text.split("\n")
    puzzle_values = lines.map do |line|
      each_line = line.split("").fill(" ", line.length..8)
      each_line.map { |value| value.to_i }
    end
  end

  def find_position_in_block(index)
    block_vals = []
    position = (index + 3) % 3
    case position
    when 0
      block_vals << index
      block_vals << index + 1
      block_vals << index + 2
    when 1
      block_vals << index - 1
      block_vals << index
      block_vals << index + 1
    when 2
      block_vals << index - 2
      block_vals << index - 1
      block_vals << index
    end
    block_vals
  end

  def find_block(row_index, col_index, collection)
    row_position = find_position_in_block(row_index).clone
    col_position = find_position_in_block(col_index).clone
    block = []
    position_block = row_position.product(col_position)
    to_delete = position_block.index([row_index, col_index])
    block = position_block.map do |val|
      collection[val[0]][val[1]]
    end
    block.delete_at(to_delete)
    block
  end

  def find_peers(collection, index = nil)
    this_collection = collection.clone
    this_collection.delete_at(index) if index != nil
    this_collection.flatten
  end

  def solve
    values_by_row = parse
    possible_values_by_row = []
    possible_values_by_col = []
    first_time = true

    10.times do
      values_by_row.map!.with_index do |row, row_index|
        row.map!.with_index do |val, col_index|

          if val > 0
            possible_values_by_row << val if first_time
            val
          else
            values_by_col = values_by_row.transpose
            this_possible = (1..9).to_a
            this_possible -= find_peers(row, col_index)
            this_possible -= find_peers(values_by_col[col_index], row_index)
            this_possible -= find_peers(find_block(row_index, col_index, values_by_row))

            if this_possible.length == 1
              possible_values_by_row << this_possible[0] if first_time
              this_possible[0]
            else
              possible_values_by_row << this_possible if first_time
              val
            end
          end
        end
      end

      possible_values_by_row = possible_values_by_row.each_slice(9).to_a if first_time
      first_time = false

      possible_values_by_row.map!.with_index do |poss_row, poss_row_index|
        poss_row.map!.with_index do |poss_val, poss_col_index|
          if poss_val.class != Array
            poss_val
          else
            possible_values_by_col = possible_values_by_row.transpose
            this_inevitable = []
            this_inevitable << (1..9).to_a - find_peers(poss_row, poss_col_index)
            this_inevitable << (1..9).to_a - find_peers(possible_values_by_col[poss_col_index], poss_row_index)
            this_inevitable << (1..9).to_a - find_peers(find_block(poss_row_index, poss_col_index, possible_values_by_row))
            if this_inevitable.join != nil
              values_by_row[poss_row_index][poss_col_index] = this_inevitable.join[0].to_i
            else
              poss_val
            end
          end
        end
      end
    end
    output = ""
    output = values_by_row.map do |row|
      row.join + "\n"
    end
    return output
  end
end
