class FonixAuth < ApplicationRecord
	belongs_to :user

    #Verify mobile_number is valid via PhoneLib gem
	#validates :mobile_number, phone: true, types: [:mobile]
	validates :mobile_number, phone: { possible: true, countries: [Phonelib.default_country, :GB], types: [:mobile], message: "Only Uk mobile numbers" }
	#validates :random_code, presence: true
end
