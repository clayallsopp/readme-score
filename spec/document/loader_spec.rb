require File.expand_path('../../spec_helper', __FILE__)

describe ReadmeScore::Document::Loader do
  describe "#markdown?" do
    describe "with .md link" do
      it "is true" do
        url = "http://www.test.com/readme.md"
        stub_request(:get, url)

        loader = ReadmeScore::Document::Loader.new(url)
        loader.markdown?.should == true
      end
    end

    describe "without .md link" do
      it "is false" do
        url = "http://www.test.com/readme.html"
        stub_request(:get, url)

        loader = ReadmeScore::Document::Loader.new(url)
        loader.markdown?.should == false
      end
    end
  end


  describe "#load!" do
    describe "with non-github links" do
      it "works" do
        url = "http://www.test.com/readme.md"
        stub_request(:get, url).
          to_return(body: "<h1>This is a test</h1>")

        loader = ReadmeScore::Document::Loader.new(url)
        loader.load!
        loader.html.strip.should == "<h1>This is a test</h1>"
      end
    end

    describe "with github links" do
      describe "with link to repo" do
        ["", "www."].each {|subdomain|
          %w(http https).each {|protocol|
            it "works with #{protocol}" do
              repo_url = "#{protocol}://#{subdomain}github.com/repo/user"

              stub_github_readme(protocol, 'repo', 'user', 'README.md').
                to_return(body: "<h1>This is a hit</h1>")

              loader = ReadmeScore::Document::Loader.new(repo_url)
              loader.load!
              loader.html.strip.should == "<h1>This is a hit</h1>"
            end
          }
        }

      end

      describe "with link to some other page" do
        it "works" do
          url = "http://github.com/repo/user/block/thing/idk.md"
          stub_request(:get, url).
            to_return(body: "<h1>A markdown</h1>")

          loader = ReadmeScore::Document::Loader.new(url)
          loader.load!
          loader.html.strip.should == "<h1>A markdown</h1>"
        end
      end
    end
  end

end