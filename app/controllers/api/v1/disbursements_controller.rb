module Api::V1
  class DisbursementsController < BaseController
    before_action :set_resource, only: [:show]

    def index
      render_json({ data: Merchant.new.disbursements(date: set_date) }, 200)
    end

    def show
      date = params[:date]&.to_datetime&.beginning_of_week
      render_json({ data: @resource.disbursements(date: set_date) }, 200)
    end

    private

    def set_date
      params[:date]&.to_datetime&.beginning_of_week
    end

    def set_resource
      @resource = (request.path.split('/').slice 2)&.classify&.constantize.find(params[:id])
    end
  end
end
