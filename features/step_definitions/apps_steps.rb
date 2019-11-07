def appears_before(element, first, last)
    #  ensure that that e1 occurs before e2.
    #  page.body is the entire content of the page as a string.
    expect(element).to have_content(first)
    expect(element).to have_content(last)
    page.body.index(first).should be < page.body.index(last)
end

Then /^I should see the following apps in "(.*)" in the given order:$/ do |table_id, apps_table|
    table_body = page.find(:xpath, %{//*[@id="#{table_id}"]/tbody})
    header = apps_table.raw[0].each_with_index.map {|h, i| [h.to_sym, i]}.to_h
    data = apps_table.raw[1..-1]
    last_index = data.length - 1
    data.each_with_index do |_, index|
      next if index == last_index
      current_row = data[index]
      next_row = data[index + 1]
      name_index = header[:name]
      appears_before(table_body, current_row[name_index], next_row[name_index])
    end
end
