require_relative './sudoku_validator_logic'

class Validator
  def initialize(puzzle_string)
    @puzzle_string = puzzle_string
  end

  def self.validate(puzzle_string)
    new(puzzle_string).validate
  end

  def create_one_dimensional_array_of_numbers(big_sudoku_string)
    big_sudoku_string = big_sudoku_string.gsub("|", "")
    big_sudoku_string = big_sudoku_string.split(" ")
    result = Array.new

    for n in big_sudoku_string      
      if n !~ /\D/
        n = n.to_i
        result.push(n)
      end
    end

    return result
  end
  
  def create_two_dimensional_sudoku_array(one_dimensional_array)
    result = Array.new
    num_to_increment = 0

    for col in 0..8
      temporary_array = Array.new

      for row in 0..8
        temporary_array.push(one_dimensional_array[num_to_increment])
        num_to_increment += 1
      end

      result.push(temporary_array)      
    end

    return result
  end

  def validate 
    array_of_numbers = create_one_dimensional_array_of_numbers(@puzzle_string)
    real_sudoku_array = create_two_dimensional_sudoku_array(array_of_numbers)

    sudoku_validator = SudokuValidator.new()

    return sudoku_validator.is_one_sudoku_field_valid(real_sudoku_array)
  end
end