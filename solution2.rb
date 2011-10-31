#######################################################################
# Author : Ian Egan
#
#2. Question: You are given an array of n integers (both positive and
# negative). Find the first continuous sequence of integers with the
# largest sum.  Examples for question 2: Example 1: Input: {-7, 4, -2,
# 5, 3, -6, 8, -8} : Answer: {4, -2, 5, 3, -6, 8} Example 2: Input {5,
# -3, -4, -2, 6, -4, 1, 3} : Answer: {6}
#
# Notes:
#######################################################################


module Kernel
private
  def this_method
    caller[0] =~ /`([^']*)'/ and $1
  end
  def calling_method
    caller[1] =~ /`([^']*)'/ and $1
  end
end


class LargestSum

  def initialize  
  end

  # given a sequence of ints return first continuous sequence of ints
  # with largest sum 
  # need start index, length of sequence and sum value
  def find(seq)

    
    rank = []
    for i in 1..(seq.length)
      ss = subSeq(seq,i)
      id = maxSubSeq(ss)
#      rank.push(Data.new(id, i, ss[id]))
      rank.push(ss[id])
    end
    #do one last test for maxSubSeq of largest seq of all lengths
    id = maxSubSeq(rank)
#    puts "#{rank}\n"
    return rank[id]
    
  end

  # Create a new set of sub sequences of n length
  # input  : array of integers and length of sub sequences to create
  # return : array of arrays 
  def subSeq(seq, step)
     if step < 1 || step > seq.length
       return []
     elsif step == seq.length
       return [seq]
     elsif step < seq.length
       
       @subs = []
       i = 0
       n = seq.length/step
       n += seq.length%step
 #      puts "#{n} \n"

       while i < n
         x = seq[i..(i+(step -1))]
#         puts "#{x} "
         @subs.push(x)
         i += 1
       end

  #     puts "#{@subs}\n"
       return @subs
     end

  end

  # return the sum of the the array of integers
  def sumSeq(sSeq)
    sum = 0
    sSeq.each { |value|  sum += value}
    return sum
  end

  # given a sequence of numbers return index of largest in array
  def maxValue(sq)

    #ini value
    max = sq[0]
    at  = 0

    for i in 1..(sq.length - 1)

      if max < sq[i]
        max = sq[i]
        at = i
      end

    end

    return at
  end

  # Given a set of sub sequences calculate the largest
  # input  : array of arrays of sub sequences
  # return : the index of max sub sequence
  def maxSubSeq(sq)
    if sq.length == 0 || sq.length == 1 
      return 0
    else
      sums = []
      for value in sq
        sums.push(sumSeq(value))
      end 
      
      return maxValue(sums)
    end
  end

end

class TestLargestSum

  def initialize  
    @largestS = LargestSum.new()
    @passCount = 0
    @failCount = 0
  end

  #compare result vs expected pluss test msg
  def assertEquals(results, expected, msg)
    puts "#{calling_method}: #{msg}\n"
    if(results != expected)
      puts "Expected #{expected} not #{results}\n"
      return false
    end
    
    return true
  end

  def runTests
    puts "\n\n**** START TESTS ****\n\n"
    tcnt = 0
    # collect the test methods and run
    self.methods.each do |method| 

      if (method =~ /test(.*)/)
        send method
        tcnt += 1
      end
      
    end
    puts "\nRan #{tcnt} tests with #{@failCount} failures...\n"
    puts "\n\n**** END   TESTS ****\n\n"
  end

  def format(testResult)
    if testResult
      @passCount += 1
      puts "...PASS\n"
    else 
      @failCount += 1
      puts "...FAIL\n"
    end
  end

  def test1
    testData = [[-7, 4, -2]]
    results = @largestS.maxSubSeq(testData)
    expected = 0
    msg = "maxSubSeq(#{testData}) smoke test"
    format(assertEquals(results, expected, msg))  
  end

  def test2a
    testData   = [-7, 4]
    results = @largestS.subSeq(testData,1)
    expected = [[-7], [4]]
    msg = "subSeq(#{testData}, 1) smoke test"
    format(assertEquals(results, expected, msg))  
  end

  def test2b
    testData   = [-7, 4]
    results = @largestS.subSeq(testData,0)
    expected = []
    msg = "subSeq(#{testData}, 0) empty set test"
    format(assertEquals(results, expected, msg))  
  end


  def test3a
    testData   = [-7, 4]
    results = @largestS.subSeq(testData, 2)
    expected = [[-7, 4]]
    msg = "subSeq(#{testData}, 2) upper range of useful info"
    format(assertEquals(results, expected, msg))  
  end

  def test3b
    testData   = [-7, 4, 1]
    results = @largestS.subSeq(testData, 2)
    expected = [[-7, 4], [4,1]]
    msg = "subSeq(#{testData}, 2) upper range of useful info"
    format(assertEquals(results, expected, msg))  
  end

  def test3c
    testData   = [-7, 4, 1,-8,-8]
    results = @largestS.subSeq(testData, 3)
    expected = [[-7, 4, 1], [4,1,-8], [1, -8, -8]]
    msg = "subSeq(#{testData}, 3) upper range of useful info"
    format(assertEquals(results, expected, msg))  
  end

  def test3d
    testData   = [-7, 4, 1,-8,-8]
    results = @largestS.subSeq(testData, 4)
    expected = [[-7, 4, 1, -8], [4,1,-8, -8]]
    msg = "subSeq(#{testData}, 4) upper range of useful info"
    format(assertEquals(results, expected, msg))  
  end


  def test4
    testData   = [-7, 4]
    results = @largestS.subSeq(testData, 3)
    expected = []
    msg = "subSeq(#{testData}, 3) upper out of range test"
    format(assertEquals(results, expected, msg))  
  end

  def test5
    testData = [1,1,1]
    results = @largestS.sumSeq(testData)
    expected = 3
    msg = "sumSeq(#{testData}) baseline"
    format(assertEquals(results, expected, msg))  
  end

  def test6
    testData = [1,1,1,3, -2, 4]
    results = @largestS.maxValue(testData)
    expected = 5
    msg = "maxValue(#{testData}) max at end"
    format(assertEquals(results, expected, msg))  
  end

  def test7
    testData = [4,1, -2, 1]
    results = @largestS.maxValue(testData)
    expected = 0
    msg = "maxValue(#{testData}) max at start"
    format(assertEquals(results, expected, msg))  
  end

  def test8
 
    testData = [-7, 4, -2, 5, 3, -6, 8, -9]
    results = @largestS.find(testData)
    expected = [4, -2, 5, 3, -6, 8]
    msg = "find(#{testData}) example data 1"
    format(assertEquals(results, expected, msg))  

  end

  def test9

    testData = [5,-3, -4, -2, 6, -4, 1, 3]
    results = @largestS.find(testData)
    expected = [6]
    msg = "find(#{testData}) example data 2"
    format(assertEquals(results, expected, msg))  

  end
end


test = TestLargestSum.new()
test.runTests()
