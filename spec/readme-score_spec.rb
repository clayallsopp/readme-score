require File.expand_path('../spec_helper', __FILE__)

describe ReadmeScore do
  describe ".use_github_api?" do
    it "changes after setting" do
      ReadmeScore.use_github_api = false
      ReadmeScore.use_github_api?.should == false
      ReadmeScore.use_github_api = true
      ReadmeScore.use_github_api?.should == true
    end
  end

  describe ".for" do
    %w{http https}.each { |protocol|
      it "should load a #{protocol} URL" do
        url = "#{protocol}://somewhere.com/thing.md"
        expect(ReadmeScore::Document).to receive(:load).with(url) { ReadmeScore::Document.new("") }
        ReadmeScore.for(url)
      end
    }

    it "should load a Github slug" do
        repo = "user/repo"
        expect(ReadmeScore::Document).to receive(:load).with("http://github.com/#{repo}") { ReadmeScore::Document.new("") }
        ReadmeScore.for(repo)
    end

    it "should not load for HTML" do
      html = "<h1>Sup</h1>"
      expect(ReadmeScore::Document).to_not receive(:load)
      ReadmeScore.for(html)
    end
  end
end