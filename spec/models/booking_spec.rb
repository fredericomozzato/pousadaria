require "rails_helper"

RSpec.describe Booking, type: :model do
  describe "#calculate_bill" do
    it "calcula o valor total das diárias" do
      room = Room.new(price: 100.00)
      booking = Booking.new(
        start_date: 1.day.from_now,
        end_date: 3.days.from_now
      )
      allow(Room).to receive(:find).with(booking.room_id).and_return(room)

      expect(booking.calculate_bill).to eq 200.00
    end
  end
end
