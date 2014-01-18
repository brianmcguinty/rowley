[
  {:id => 1, :name => 'Single vision', :code => :single_vision},
  {:id => 2, :name => 'Progressive', :code => :progressive}
].each do |r|
  LensType.where(:id => r[:id]).first_or_create(:id => r[:id], :name => r[:name], :code => r[:code])
end
