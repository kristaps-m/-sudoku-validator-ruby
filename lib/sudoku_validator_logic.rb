require 'set'

class SudokuValidator

  VALID_SUDOKU_NUMBERS = [1,2,3,4,5,6,7,8,9]
  SUDOKU_SIZE = 9

  def check_one_row_or_col_or_block(the_list)
    #List has 1-9 only (or 0 for empty)
    #List does not have 99, or -3
    #List can not have duplicates like [3,3,2,2]
    
    list_with_no_zeros = the_list.select {|num| num != 0 }
    list_have_one_oo_nine_only = Array.new

    for num in list_with_no_zeros
      if VALID_SUDOKU_NUMBERS.include? num
        list_have_one_oo_nine_only.push(1)
      else
        list_have_one_oo_nine_only.push(0)
      end
    end
    
    does_list_have_one_to_nine_only = list_have_one_oo_nine_only.all? { |number| number>0} 
    does_list_is_with_no_duplicates = list_with_no_zeros.length == Set.new(list_with_no_zeros).length

    return does_list_have_one_to_nine_only & does_list_is_with_no_duplicates
  end

  def create_block_of_3x3(one_sudoku_field,start_col, end_col, start_row, end_row)
    result = Array.new

    for col in start_col..end_col-1
      for row in start_row..end_row-1
        result.push(one_sudoku_field[col][row])
      end
    end

    return result
  end

  def create_all_small_blocks(one_sudoku_field)
    all_small_blocks = Array.new

    for col in (0..SUDOKU_SIZE-1).step(3)
      for row in (0..SUDOKU_SIZE-1).step(3)
        start_col, end_col, start_row, end_row = col, col+3, row, row+3
        one_block = create_block_of_3x3(one_sudoku_field, start_col, end_col, start_row, end_row)
        all_small_blocks.push(one_block)
      end
    end

    return all_small_blocks
  end

  def is_one_sudoku_field_valid(one_sudoku_field)
    list_of_row_answers = Array.new
    list_of_col_answers = Array.new
    list_of_small_blocks_answers = Array.new
    is_sudoku_complited = true

    for oneBlock in create_all_small_blocks(one_sudoku_field)
      if check_one_row_or_col_or_block(oneBlock)
        list_of_small_blocks_answers.push(1)
      else
        list_of_small_blocks_answers.push(0)
      end
    end
    
    for col in 0..SUDOKU_SIZE-1
      oneRow = Array.new
      oneCol = Array.new

      for row in 0..SUDOKU_SIZE-1
        oneRow.push(one_sudoku_field[col][row])
        oneCol.push(one_sudoku_field[row][col])
        if one_sudoku_field[col][row] == 0
          is_sudoku_complited = false
        end
          if check_one_row_or_col_or_block(oneRow)
            list_of_row_answers.push(1)
          else
            list_of_row_answers.push(0)
          end
        if check_one_row_or_col_or_block(oneCol)
          list_of_col_answers.push(1)
        else
          list_of_col_answers.push(0)
        end
      end
    end
    
    is_one_row_valid = list_of_row_answers.all? { |num| num>0}
    is_one_column_valid = list_of_col_answers.all? { |num| num>0}
    is_one_block_valid = list_of_small_blocks_answers.all? { |num| num>0}
    is_one_puzzle_valid = [is_one_row_valid, is_one_column_valid, is_one_block_valid].all? { |onebool| onebool == true}

    if is_one_puzzle_valid & is_sudoku_complited
      return "Sudoku is valid."
    elsif is_one_puzzle_valid & !is_sudoku_complited
      return "Sudoku is valid but incomplete."
    else
      return "Sudoku is invalid."
    end
  end
end