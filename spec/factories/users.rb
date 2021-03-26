FactoryGirl.define do
  factory :user do
    first_name     'Admin'
    last_name      'Admin'
    email          'admineval@email.com'
    password       '1234567890'
    is_student     'false'
    is_teacher     'false'
    is_admin       'true'
    is_management  'false'

  end
end
