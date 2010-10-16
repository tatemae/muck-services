Factory.define :service_share, :class => 'share' do |f|
  f.uri { Factory.next(:uri) }
  f.title { Factory.next(:title) }
  f.shared_by {|a| a.association(:user)}
  f.entry {|a| a.association(:entry)}
end

Factory.define :personal_recommendation do |r|
  r.personal_recommendable {|a| a.association(:user)}
  r.destination {|a| a.association(:entry)}
end

Factory.define :recommendation do |r|
  r.entry {|a| a.association(:entry)}
  r.dest_entry {|a| a.association(:entry)}
end
