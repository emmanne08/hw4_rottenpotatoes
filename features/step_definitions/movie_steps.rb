Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create!(movie)
  end
  #debugger
end

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  movies_table_str = page.find_by_id(:movies).text
  flunk "#{e1} should be seen before #{e2}" unless
  movies_table_str =~ /#{e1}.*#{e2}/m
end

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  if uncheck
    rating_list.split(/, /).each {|rating| step "I uncheck \"ratings_#{rating}\""}
  else
    rating_list.split(/, /).each {|rating| step "I check \"ratings_#{rating}\""}
  end
end

Then /I should see all of the movies/ do
  flunk 'It does not show the correct number of movies' unless page.has_selector?('table#movies tr', :count => 11)
  steps %Q{
    Then I should see "Aladdin"
    And I should see "The Terminator"
    And I should see "When Harry Met Sally"
    And I should see "The Help"
    And I should see "Chocolat"
    And I should see "Amelie"
    And I should see "2001: A Space Odyssey"
    And I should see "The Incredibles"
    And I should see "Raiders of the Lost Ark"
    And I should see "Chicken Run"
  }
end

Then /the director of "(.*)" should be "(.*)"/ do |movie, director|
  Movie.find_by_title(movie).director.should == director
end
