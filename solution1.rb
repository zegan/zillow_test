#####################################################
# Program     : Solution1
# Author      : Ian 
# description : 
#
# 1. Question: A solution consists of four balls from a set of four
# different colors. The user tries to guess the solution.  If they
# guess the right color for the right spot, record it as being in the
# correct 'Location'. If it's the right color, but the wrong spot,
# record it as a correct 'Color'. For example: if the solution is
# 'BGRR' and the user guesses 'RGYY' they have 1 'Location' and 1
# 'Color'. A correct solution would be 4 'Location' and 0 'Color'.
# Write a program to, given a solution and a guess, calculate the
# response that we present to the user.
#
# Todo   : Error Checking
#####################################################


class Game
  attr_reader :colors
  attr_accessor :solution, :guess
  def initialize  
    @colors = "rgby".split(//)
    @solution = "rrrr".split(//)
    @guess    = "yyyy".split(//)
  end

  #randomly generate a solution and a guess
  def pick
    @solution.each_index {|i| @solution[i]= @colors[rand(3)] } 
    4.times { |i| @guess[i] = @colors[rand(3)]}
  end

  #todo: guard against bad input values
  def solution=(value)
    value = value.downcase()
    @solution = value.split(//)
  end

  #todo: guard against bad input values
  def guess=(value)
    value = value.downcase()
    @guess= value.split(//)
  end


  # todo : clean this up no need for iteration
  def show(*args)
    if args.size > 1  
      # modify this to raise exception, later  
      puts 'This method takes either 0 or 1 arguments'  
    else 
      if args.size == 0
        print "The solution:\n"
        @solution.each_index {|i| print "  #{@solution[i]} "}
        print "\nA guess:\n"
        @guess.each_index {|i| print "  #{@guess[i]} "}
       elsif args.size == 1
        print "\nFound #{args[0]['l']} locations and #{args[0]['c']} colors\n"        
       end
    end
  end
  
  # caculate the difference between the solution and the guess
  # todo : simplify!
  def diff
    @loc = 0
    @color = 0
    @s = []
    @g = []
    # count number of colors in solution and guess
    # to caculate number of correct colors


    # Check for location 1st - the simplest relation
    # and create new arrays without location
    for i in 0..3
      if(@solution[i] == @guess[i])
        @loc += 1

      elsif 
        @s.push(@solution[i])
        @g.push(@guess[i])

      end
    end
    

    @cnt = (@s.length - 1)
    for i in 0..@cnt
       for j in 0..@cnt
       #print "\n #{i} "
         if(@g[i] == @s[j])
           @s[j] = '*'
           @color += 1
           break
         end
       end
    end
     
    return {'l'=> @loc, "c"=> @color}
    
  end
 
end  


class TestGame
   
  #compare result vs expected pluss test msg
  def assertEquals(results, expected, msg)
    puts "\nTesting: #{msg}, #{results}, #{expected}\n"
    if(results['l'] != expected['l'] || results['c'] != expected['c'])
      puts "Expected #{expected} not #{results}\n"
      return false
    end
    
    return true
  end
end


play = Game.new
test = TestGame.new

play.pick
play.show
play.show(play.diff)


########## Tests ###########
puts "\n\n**** START TESTS ****\n\n"
# Test 1
# Expected 1 location and 2 colors
play.solution = "rgbr"
play.guess    = "grbb"
play.show()
results1 = play.diff()
expected1 = {'l'=>1, 'c'=>2}
play.show(results1)

puts test.assertEquals(results1, expected1, "Test 1") ? "...PASS\n\n" :"...FAIL\n\n"

# Test 2
#'BGRR' and the user guesses 'RGYY'
play.solution = "bgrr"
play.guess    = "rgyy"
results2      = play.diff()
expected2     = {'l'=>1, 'c'=>1}

puts test.assertEquals(results2, expected2, "Test 2") ? "...PASS\n\n" :"...FAIL\n\n"


# Test 3
#Expected 1 location and 2 colors
play.solution = "ggrr"
play.guess    = "rryy"
play.show
results3 = play.diff()
expected3 = {'l'=>0, 'c'=>2}
#play.show(results3)

puts test.assertEquals(results3, expected3, "Test 3") ? "...PASS\n\n" :"...FAIL\n\n"


# Test 4
#'BGRR' and the user guesses 'RGYY'
play.solution = "bgrr"
play.guess    = "rgyy"
results4      = play.diff()
expected4     = {'l'=>1, 'c'=>1}

puts test.assertEquals(results4, expected4, "Test 4") ? "...PASS\n\n" :"...FAIL\n\n"


# Test 4
#'BGRR' and the user guesses 'RGRR'
play.solution = "bgRR"
play.guess    = "bgrr"
results5      = play.diff()
expected5     = {'l'=>4, 'c'=>0}

puts test.assertEquals(results5, expected5, "Test 5") ? "...PASS\n\n" :"...FAIL\n\n"




