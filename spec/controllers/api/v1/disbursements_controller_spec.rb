RSpec.describe Api::V1::DisbursementsController, type: %i[controller api] do
  describe "disbursements" do
    let(:resource_1) { create(:merchant) }
    let(:resource_2) { create(:merchant) }

    let!(:orders_1) { create_list(:order, 10, amount: rand(0..450), merchant: resource_1, completed_at: DateTime.now) }
    let!(:orders_2) { create_list(:order, 5, amount: rand(0..450), merchant: resource_2, completed_at: DateTime.now.next_day(2)) }

    before do
      Order.find_each {|o| DisbursementJob.perform_now(order_id: o.id) }
    end

    context "GET /disbursements" do
      before { get :index, :format => :json }

      include_examples "controller status response", :ok
      include_examples "controller data format response", "data"
      include_examples "controller object format response", Hash, "data", "resources collection hash with disbursements"

      context 'resources found by date' do
        before { get :index, params: {
                              date: orders_1.first.completed_at
                            }, :format => :json }

        it "should return specific resource disbursements" do
          expect(json_response['data'][resource_1.id.to_s].keys).to match_array(
            [
              orders_1.first.completed_at.beginning_of_week.strftime('%Y-%m-%d'),
            ]
          )
        end
      end

      it "should return all resource disbursements" do
        expect(json_response['data'].keys).to match_array([resource_1.id.to_s, resource_2.id.to_s])
      end
    end

    context "GET /:id/disbursements" do

      context 'resource found' do
        before { get :show, params: {id: resource_1.id}, :format => :json }

        include_examples "controller status response", :ok
        include_examples "controller data format response", "data"
        include_examples "controller object format response", Hash, "data", "single resource hash with disbursements"

        context 'resource found by date' do
          before { get :show, params: {
                                id: resource_1.id,
                                date: orders_1.first.completed_at
                              }, :format => :json }

          it "should return specific resource disbursements" do
            expect(json_response['data'][resource_1.id.to_s].keys).to match_array(
              [orders_1.first.completed_at.beginning_of_week.strftime('%Y-%m-%d')]
            )
          end
        end

        it "should return specific resource disbursements" do
          expect(json_response['data'].keys).to match_array([resource_1.id.to_s])
        end
      end

      context 'resource not found' do
        before { get :show, params: {id: 0}, :format => :json }

        include_examples "controller status response", :not_found
        include_examples "controller data format response", "errors"
        include_examples "controller object format response", String, "errors", "return not found error"
      end
    end
  end
end
