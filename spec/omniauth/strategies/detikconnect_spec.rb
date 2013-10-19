require 'spec_helper'

describe OmniAuth::Strategies::DetikConnect do
  let(:access_token) { double('AccessToken', :options => {}) }
  let(:parsed_response) { double('ParsedResponse') }
  let(:response) { double('Response', :parsed => parsed_response) }

  subject do
    OmniAuth::Strategies::DetikConnect.new({})
  end

  before(:each) do
    subject.stub(:access_token).and_return(access_token)
  end

  context "client options" do
    it 'should have correct site' do
      subject.options.client_options.site.should eq("https://connect.detik.com")
    end

    it 'should have correct authorize url' do
      subject.options.client_options.authorize_url.should eq('https://connect.detik.com/oauth/authorize')
    end

    it 'should have correct token url' do
      subject.options.client_options.token_url.should eq('https://connect.detik.com/oauth/accessToken')
    end
  end

  context "#raw_info" do
    it "should use relative paths" do
      access_token.should_receive(:get).with('rest/user').and_return(response)
      subject.raw_info.should eq(parsed_response)
    end
  end

end
