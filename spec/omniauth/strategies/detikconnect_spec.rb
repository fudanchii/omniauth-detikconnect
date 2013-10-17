require 'spec_helper'

describe OmniAuth::Strategies::DetikConnect do
  let(:access_token) { double('AccessToken', :options => {}) }
  let(:parsed_response) { double('ParsedResponse') }
  let(:response) { double('Response', :parsed => parsed_response) }

  let(:enterprise_site)          { 'https://some.other.site.com/api/v3' }
  let(:enterprise_authorize_url) { 'https://some.other.site.com/login/oauth/authorize' }
  let(:enterprise_token_url)     { 'https://some.other.site.com/login/oauth/access_token' }
  let(:enterprise) do
    OmniAuth::Strategies::DetikConnect.new('GITHUB_KEY', 'GITHUB_SECRET',
        {
            :client_options => {
                :site => enterprise_site,
                :authorize_url => enterprise_authorize_url,
                :token_url => enterprise_token_url
            }
        }
    )
  end

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

    describe "should be overrideable" do
      it "for site" do
        enterprise.options.client_options.site.should eq(enterprise_site)
      end

      it "for authorize url" do
        enterprise.options.client_options.authorize_url.should eq(enterprise_authorize_url)
      end

      it "for token url" do
        enterprise.options.client_options.token_url.should eq(enterprise_token_url)
      end
    end
  end

  context "#raw_info" do
    it "should use relative paths" do
      access_token.should_receive(:get).with('rest/user').and_return(response)
      subject.raw_info.should eq(parsed_response)
    end
  end

end
