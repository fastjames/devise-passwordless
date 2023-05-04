require "spec_helper"

RSpec::Matchers.define_negated_matcher :avoid_changing, :change

RSpec.describe Devise::Strategies::MagicLinkAuthenticatable do
  describe "#authenticate!" do
    let(:strategy) { described_class.new(env) }
    let(:env) { env_with_params }
    context "when no token is provided" do
      let(:request_token) { nil }
      it "soft fails" do
        strategy.token = nil

        expect {
          strategy.authenticate!
        }.to change { strategy.result }.to(:failure)
         .and avoid_changing { strategy.halted? }
      end
    end
  end
end

def env_with_params(path = "/", params = {}, env = {})
  method = params.delete(:method) || "GET"
  env = { 'HTTP_VERSION' => '1.1', 'REQUEST_METHOD' => "#{method}" }.merge(env)
  Rack::MockRequest.env_for("#{path}?#{Rack::Utils.build_query(params)}", env)
end
