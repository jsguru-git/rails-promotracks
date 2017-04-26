# require 'platform/email_helper'
# include EmailHelper

User.create(email: 'dev@bitcot.com', password: '12345', password_confirmation: '12345', first_name: 'Dev', last_name: 'Bitcot', role: :super_admin)

# Create Brands And Event Types
10.times do |i|
  Brand.create(:name => Faker::Company.name, description: Faker::Lorem.sentence)
  EventType.create(:name => Faker::Company.name)
end

# Create client and associated events ,group ,reps
10.times do |i|
  brand_ids=Brand.all.ids
  client=Client.new(:name => Faker::Company.name, :phone => Faker::PhoneNumber.cell_phone)
  client.brand_ids = brand_ids.sample(3)
  client.admin=User.new(:email => Faker::Internet.safe_email, password: '12345', password_confirmation: '12345', :role => 'client_admin')
  client.save
  client.admin.update(client_id: client.id)
  password=(10000..99999).to_a.sample
  users=client.users
  groups=client.groups
  group_id=groups.sample
  user_ids=users.ids.sample(4)
  event_type_ids=EventType.all.ids
  event_type = event_type_ids.sample
  brand=brand_ids.sample
  6.times do |j|
    promo_rep=client.users.new(:first_name => Faker::Name.first_name, :last_name => Faker::Name.last_name, :email => Faker::Internet.safe_email, password: password, password_confirmation: password, :token => password, :role => 'promo_rep')
    if promo_rep.valid?
      promo_rep.save
    else
      puts promo_rep.errors.full_messages.join(',')
    end
    # email_data={}
    # email_data[:body] = "find below the passcode for the promo rep"
    # email_data[:subject]="New Promo Rep :#{promo_rep.id}"
    # email_data[:user]=promo_ref_info(promo_rep)
    # UserMailer.send_email(promo_rep.email, email_data).deliver
  end

  6.times do |k|
    group=client.groups.new(:name => Faker::Name.name)
    group.user_ids = user_ids
    group.save
  end
  6.times do |l|
    rep_event=client.events.new(:promo_category => 'promo_rep', :name => Faker::Name.name, :event_type_id => event_type, :end_time => Faker::Time.forward(23, :morning), :start_time => Faker::Time.backward(14, :evening), :brand_id => brand)
    rep_event.creator = client.admin
    user_ids.each do |id|
      rep_event.user_events.new(user_id: id, token: SecureRandom.hex[0, 6], status: :accepted)
    end
    rep_event.address=Location.new(:city => 'San Diego')
    rep_event.save
  end


  6.times do |l|
    rep_event=client.events.new(:promo_category => 'promo_group', :name => Faker::Name.name, :event_type_id => event_type, :end_time => Faker::Time.forward(23, :morning), :start_time => Faker::Time.backward(14, :evening), :brand_id => brand, :max_users => 2, :group_id => group_id)
    rep_event.creator = client.admin
    rep_event.address=Location.new(:city => 'San Diego')
    rep_event.save
    # email_data={}
    # email_data[:body] = "Please find below the event details"
    # email_data[:subject]="#{rep_event.name} :#{rep_event.id}"
    # email_data[:event]=get_event(rep_event)
    unless rep_event.group_id.nil?
      rep_event.group.users.each do |user|
        token=SecureRandom.hex[0, 6]
        rep_event.user_events.create(user_id: user.id, token: token, category: :promo_group)
        # EventMailer.accept_event(user.email, email_data, token).deliver
      end
    end
  end
end