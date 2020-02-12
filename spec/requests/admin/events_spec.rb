require 'rails_helper'

RSpec.describe "Admin::Events", type: :request do
  let(:admin) { create(:admin) }
  let(:event){ create :event }
  before do
    sign_in admin
  end
  describe "GET #index" do

    it "has success to request" do
      get admin_events_url
      expect(response).to be_success
      expect(response).to have_http_status 200
    end

    it "display event name" do
      event = create(:event)
      get admin_events_url
      expect(response.body).to include "new event"
    end
  end

  describe "Get #new" do
    it "has success to request" do
      get new_admin_event_url
      expect(response).to be_success
      expect(response).to have_http_status 200
    end
  end

  describe "GET #edit" do
    let(:event){ create :event }

    it "has success to request" do
      get edit_admin_event_url event
      expect(response).to be_success
      expect(response).to have_http_status 200
    end

    it "display event title" do
      get edit_admin_event_url event
      expect(response.body).to include "new event"
    end
  end

  describe "Post #create" do
    context "when paramater is valid" do
      it "has success to request" do
        post admin_events_url, params: { event: attributes_for(:event) }
        expect(response).to have_http_status 302
      end

      it "has success to register event" do
        expect {
          post admin_events_url, params: { event: attributes_for(:event) }
        }.to change(Event, :count).by(1)
      end

      it "redirect to event index page" do
          post admin_events_url, params: { event: attributes_for(:event) }
          expect(response).to redirect_to admin_events_url
      end
    end

    context "when paramater is invalid" do
      it "has success to request" do
        post admin_events_url, params: { event: attributes_for(:event, :invalid) }
        expect(response).to have_http_status 200
      end

      it "failed to register event" do
        expect do
          post admin_events_url, params: { event: attributes_for(:event, :invalid) }
        end.to_not change(Event, :count)
      end

      it 'display error message' do
        post admin_events_url, params: { event: attributes_for(:event, :invalid) }
        expect(response.body).to include '入力値が正しくありません'
      end
    end
  end

  describe "PUT #update" do
    context "when paramater is valid" do
      it "has success to request" do
        put admin_event_url event, params: { event: attributes_for(:event_A) }
        expect(response).to have_http_status 302
      end

      it "has success to update event name" do
        expect do
          put admin_event_url event, params: { event: attributes_for(:event_A) }
        end.to change { Event.find(event.id).name }.from('new event').to("event_a")
      end

      it "redirect to index page" do
        put admin_event_url event, params: { event: attributes_for(:event_A) }
        expect(response).to redirect_to(admin_events_url)
      end
    end

    context "when paramater is invalid" do
      it "has success to request" do
        put admin_event_url event, params: { event: attributes_for(:event, :invalid) }
        expect(response).to be_success
        expect(response).to have_http_status 200
      end

      it "name does not be changed" do
        expect {
          put admin_event_url event, params: { event: attributes_for(:event, :invalid) }
        }.to_not change{ Event.find(event.id) }, :name
      end

      it "display error message" do
        put admin_event_url event, params: { event: attributes_for(:event, :invalid) }
        expect(response.body).to include '入力値が正しくありません'
      end
    end
  end

  describe "DELETE #destroy" do
    it "has success to request" do
      delete admin_event_url event, format: :js
      expect(response).to have_http_status 200
    end

    it "does not display deleted event" do
      delete admin_event_url event, format: :js
      expect(response).to have_http_status 200
    end

    it "delete event" do
      event =  create(:event)
      expect {
        delete admin_event_url event, format: :js
      }.to change(Event, :count).by(-1)
    end
  end
end