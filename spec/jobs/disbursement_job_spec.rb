
RSpec.describe DisbursementJob, :type => :job do
  describe "#perform_later" do
    let(:order) { create(:order) }

    it "performs correct job" do
      expect {
        DisbursementJob.perform_later(order_id: order.id)
      }.to have_enqueued_job.with(order_id: order.id).on_queue('default')
    end

    describe 'redis cache creation' do
      before do
        @merchant = create(:merchant)
        create_list(:order, 4, merchant: @merchant, amount: rand(1..400))
      end

      it "creates redis cache store keys" do
        expect {
          DisbursementJob.perform_now(order_id: create(:order, merchant: @merchant).id)
        }.to change(Redis.current, :keys)
         .from([])
         .to(["disbursements:merchants:#{@merchant.id}"])
      end

      it "creates correct cache store values for disbursement" do
        DisbursementJob.perform_now(order_id: create(:order, merchant: @merchant).id)
        expect(JSON.parse(Redis.current.get("disbursements:merchants:#{@merchant.id}"))).to eql(
          Order.completed.where(merchant: @merchant).group_by_week(:completed_at, week_start: :monday).sum(:disbursement)
        )
      end
    end
  end
end
