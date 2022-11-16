OPEN_TOKEN = /.+\)/
CLOSE_TOKEN = /^\s*\;\;\s*$/
CASE_TOKEN = /\s*case.*/

def check_block_formations(rendered_template)

  line_index = 0
  tokens = Array.new #acts like a stack
  
  #we only keep three types of tokens in the stack
  rendered_template.each_line do |line|
    case
    when line.match?(CASE_TOKEN)
      tokens.push(CASE_TOKEN)
    when line.match?(OPEN_TOKEN)
      tokens.push(OPEN_TOKEN)
    when line.match?(CLOSE_TOKEN)
      tokens.push(CLOSE_TOKEN)
    end
  end

  # remove header token and check if it starts a CASE..ESAC block
  # if not, then the rest of the tokens are not within a CASE..ESAC block, which is not allowed
  case_token = tokens.shift
  return false unless case_token == CASE_TOKEN
  
  remaining_tokens_count = tokens.length
  next_token = CLOSE_TOKEN
  # pop in LIFO order and see whether tokens are matched
  # i.e if the current token is OPEN, the next one must be CLOSE. 
  for i in 1..remaining_tokens_count do

    t = tokens.pop
    return false unless t == next_token
    next_token == CLOSE_TOKEN ? next_token = OPEN_TOKEN : next_token = CLOSE_TOKEN
  end
  true
end

def find_statement(rendered_template, statement)
  statement_line = -1
  index = 0
  rendered_template.each_line do |line|
    if line.strip.match? statement
      statement_line = index
    end
    index += 1
  end
  
  statement_line  
end

