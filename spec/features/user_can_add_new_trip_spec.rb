require 'rails_helper'

RSpec.describe 'As a user' do
  describe 'when searching for lots' do
    it 'fills out a form for a new trip' do
      allow_any_instance_of(GoogleCoordinateService).to receive(:get_coordinates).and_return({"lat": 39.7507834, "lng": -104.9964355})
      user = create(:user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
      visit new_trip_path
      destination = '1331 17th St Denver, CO 80202'
      fill_in :destination, with: destination
      fill_in :radius, with: 5

      check "lot"
      click_on 'Search'

      expect(current_path).to eq(results_path)
    end

    it 'filteres results by lot only' do
      allow_any_instance_of(GoogleCoordinateService).to receive(:get_coordinates).and_return({"lat": 39.7507834, "lng": -104.9964355})
      user = create(:user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
      visit new_trip_path
      destination = '1331 17th St Denver, CO 80202'
      fill_in :destination, with: destination
      fill_in :radius, with: 5

      check "lot"
      click_on 'Search'

      expect(page).to_not have_css(".meter-select")
    end

    it 'fails gracefully' do
      allow_any_instance_of(GoogleCoordinateService).to receive(:get_coordinates).and_return({"lat": 39.7507834, "lng": -104.9964355})
      user = create(:user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
      visit new_trip_path
      destination = '1331 17th St Denver, CO 80202'
      fill_in :destination, with: destination
      fill_in :radius, with: 0

      check "lot"
      click_on 'Search'

      expect(current_path).to eq(results_path)
      expect(page).to_not have_css(".results")

      expect(page).to have_link("New Trip")
      within(".no-results") do
        click_on "New Trip"
      end
      expect(current_path).to eq(new_trip_path)
    end
  end

  describe 'when searching for meters' do
    it 'filters results by meter only' do
      allow_any_instance_of(GoogleCoordinateService).to receive(:get_coordinates).and_return({"lat": 39.7507834, "lng": -104.9964355})
      user = create(:user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
      visit new_trip_path
      destination = '1331 17th St Denver, CO 80202'
      fill_in :destination, with: destination
      fill_in :radius, with: 5

      check "meter"
      click_on 'Search'
      expect(page).to_not have_css(".lot-result")

      click_on "Choose Meter"

      expect(current_path).to eq(trips_path)
    end
  end
end
