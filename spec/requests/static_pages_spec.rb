require "rails_helper"

RSpec.describe "StaticPages", type: :request do
  describe "GET /" do
    it "returns http success" do
      # トップページ（ / ）にアクセスしてテストする
      get root_path
      expect(response).to have_http_status(:success)
    end
  end
end
