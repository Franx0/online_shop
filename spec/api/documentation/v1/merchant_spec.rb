require 'swagger_helper'
require './spec/shared_context/integration'

default_props = {
  attributes: {
    type: :object,
    properties: {
      type: :object,
      '1': {
        type: :object,
        properties: {
          type: :object,
          '2018-01-22': {type: :string, example: '4679.25'}
        }
      }
    }
  }
}

# INDEX
describe 'Merchants API', type: :request, swagger_doc: 'v1/swagger.yaml' do
  path '/api/merchants/disbursements' do
    get 'List disbursements' do
      tags 'Merchants'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :date, in: :query, type: :string, required: false

      response '200', 'Disbursements list' do
        schema type: :object, properties: {
          data: {
            type: :object,
            properties: {
              "1": {
                type: :object,
                properties: {
                  "2018-01-22": {type: :string, example: '4679.25'},
                  "2020-10-01": {type: :string, example: '30.25'},
                  "2021-02-01": {type: :string, example: '3445.02'}
                }
              },
              "2": {
                type: :object,
                properties: {
                  "2015-03-02": {type: :string, example: '45.25'},
                  "2018-10-02": {type: :string, example: '67.25'}
                }
              },
              "3": {
                type: :object,
                properties: {
                  "2021-01-01": {type: :string, example: '0.00'}
                }
              }
            }
          }
        }

        before { create_list(:merchant, 2) }
        include_context 'with integration test'
      end
    end
  end
end

# SHOW
describe 'Merchants API', type: :request, swagger_doc: 'v1/swagger.yaml' do
  path '/api/merchants/{id}/disbursements' do
    get 'Find merchant disbursements' do
      tags 'Merchants'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer, required: true
      parameter name: :date, in: :query, type: :string, required: false

      response '200', 'Disbursements list' do
        response '200', 'Disbursements list' do
        schema type: :object, properties: {
          data: {
            type: :object,
            properties: {
              "1": {
                type: :object,
                properties: {
                  "2018-01-22": {type: :string, example: '4679.25'},
                  "2020-10-01": {type: :string, example: '30.25'},
                  "2021-02-01": {type: :string, example: '3445.02'}
                }
              },
            }
          }
        }

        before { create_list(:merchant, 2) }
        include_context 'with integration test'
      end

        let(:id) { create(:merchant).id }
        include_context 'with integration test'
      end
    end
  end
end
