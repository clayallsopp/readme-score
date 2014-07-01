require File.expand_path('../../spec_helper', __FILE__)

describe ReadmeScore::Document::Loader do
  describe ".is_github_repo_slug?" do
    it "works" do
      ReadmeScore::Document::Loader.is_github_repo_slug?("afnetworking/afnetworking").should == true
      ReadmeScore::Document::Loader.is_github_repo_slug?("afnetworking/").should == false
      ReadmeScore::Document::Loader.is_github_repo_slug?("afnetworking").should == false
      ReadmeScore::Document::Loader.is_github_repo_slug?("http://github.com/afnetworking/afnetworking").should == false
      ReadmeScore::Document::Loader.is_github_repo_slug?("afnetworking/afnetworking/").should == false
      ReadmeScore::Document::Loader.is_github_repo_slug?("afnetworking/afnetworking/z").should == false
    end
  end

  describe ".is_url?" do
    it "works" do
      ReadmeScore::Document::Loader.is_url?("http://github.com/afnetworking/afnetworking").should == true
      ReadmeScore::Document::Loader.is_url?("https://github.com/afnetworking/afnetworking").should == true
      ReadmeScore::Document::Loader.is_url?("https://something.com/").should == true
      ReadmeScore::Document::Loader.is_url?("afnetworking/afnetworking").should == false
      ReadmeScore::Document::Loader.is_url?("afnetworking/").should == false
      ReadmeScore::Document::Loader.is_url?("afnetworking").should == false
      ReadmeScore::Document::Loader.is_url?("afnetworking/afnetworking/").should == false
      ReadmeScore::Document::Loader.is_url?("afnetworking/afnetworking/z").should == false
    end
  end

  describe "#markdown?" do
    ReadmeScore::Document::Loader::MARKDOWN_EXTENSIONS.each {|extension|
      describe "with .#{extension} link" do
        it "is true" do
          url = "http://www.test.com/readme.#{extension}"
          stub_request(:get, url)

          loader = ReadmeScore::Document::Loader.new(url)
          loader.load!
          loader.markdown?.should == true
        end
      end
    }

    describe "without .md link" do
      it "is false" do
        url = "http://www.test.com/readme.html"
        stub_request(:get, url)

        loader = ReadmeScore::Document::Loader.new(url)
        loader.markdown?.should == false
      end
    end
  end

  describe "#html" do
    describe "without markdown" do
      it "works" do
        loader = ReadmeScore::Document::Loader.new("http://something.com/thing.html")
        loader.markdown = false
        loader.response = double('HTTP response', body: "<h1>Hello</h1>")
        loader.html.should == "<h1>Hello</h1>"
      end
    end

    describe "with markdown" do
      it "works" do
        loader = ReadmeScore::Document::Loader.new("http://something.com/thing.md")
        loader.markdown = true
        loader.response = double('Markdown response', body: "# Hello")
        expect(loader).to receive(:parse_markdown).with("# Hello")
        loader.html
      end
    end
  end


  describe "#load!" do
    describe "when github api is turned off" do
      before do
        ReadmeScore.use_github_api = false
      end

      after do
        ReadmeScore.use_github_api = true
      end

      it "loads via approximation" do
        loader = ReadmeScore::Document::Loader.new("http://github.com/repo/user")
        expect(loader).to receive(:load_via_github_approximation!)
        loader.load!
      end
    end

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