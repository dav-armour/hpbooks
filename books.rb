# Returns cost of books given in hash of { book: qty }
def price( books = {} )
  return 0 if books.empty?
  cost = 0.0
  # Sell off 5 books when possible
  while books.values.min > 1 && books.count == 5
    # Sell off 5 books at 25% discount
    cost += 8 * 5 * 0.75
    # Decrease qty of each book
    books.transform_values! { |v| v - 1 }
  end
  while books.values.max > 0
    books.delete_if { |k, v| v.zero? }
    # Check if hash has 2 books with qty of 1 and total unique books is 5
    if books.values.count(1) == 2 && books.count == 5
      # Sell 2 * 4 books at 20% discount
      cost += 2 * 8 * 4 * 0.8
      # Lower qty of books
      books.delete_if{ |k,v| v == 1 }
      books.transform_values! { |v| v - 2 }
    else
      # Sell max qty of books
      max_qty = books.uniq.count
      # increase cost
      cost += 8 * max_qty * discount_multiplier(max_qty)
      books.transform_values! { |v| v - 1 }
    end
  end
  cost
end

def discount_multiplier(qty)
  case qty
  when 1
    1.0
  when 2
    0.95
  when 3
    0.9
  when 4
    0.8
  when 5
    0.75
  end
end

def testBasics
  puts "Basics:"
  print 'Test 1: '
  puts 0 == price({})
  print 'Test 2: '
  puts 8 == price({ book1: 1 })
  print 'Test 3: '
  puts 8 * 2 == price({ book2: 2 })
  print 'Test 4: '
  puts 8 * 3 == price({ book3: 3 })
end

def testSimpleDiscounts
  puts "Simple Discounts:"
  print 'Test 1: '
  puts 8 * 2 * 0.95 == price({book1: 1, book2: 1})
  print 'Test 2: '
  puts 8 * 3 * 0.9 == price({ book1: 1, book3: 1, book5: 1 })
  print 'Test 3: '
  puts 8 * 4 * 0.8 == price({ book1: 1, book2: 1, book3: 1, book5: 1 })
  print 'Test 4: '
  puts 8 * 5 * 0.75 == price({ book1: 1, book2: 1, book3: 1, book4: 1, book5: 1 })
end

def testSeveralDiscounts
  puts "Several Discounts:"
  print 'Test 1: '
  puts 8 + (8 * 2 * 0.95) == price({ book1: 2, book2: 1 })
  print 'Test 2: '
  puts 2 * (8 * 2 * 0.95) == price({ book1: 2, book2: 2 })
  print 'Test 3: '
  puts (8 * 4 * 0.8) + (8 * 2 * 0.95) == price({ book1: 2, book2: 1, book3: 2, book4: 1 })
  print 'Test 4: '
  puts 8 + (8 * 5 * 0.75) == price({ book1: 1, book2: 2, book3: 1, book4: 1, book5: 1 })
end

def testEdgeCases
  puts "Edge Cases:"
  print "Test 1: "
  puts 2 * (8 * 4 * 0.8) == price({ book1: 2, book2: 2, book3: 2, book4: 1, book5: 1 })
  print "Test 2: "
  puts 3 * (8 * 5 * 0.75) + 2 * (8 * 4 * 0.8) == price({ book1: 5, book2: 5, book3: 4, book4: 5, book5: 4 })
end

testBasics
testSimpleDiscounts
testSeveralDiscounts
testEdgeCases