require File.expand_path('../../spec_helper', __FILE__)

describe ReadmeScore::Document::Filter do
  describe "#filtered_html!" do

    describe "removing license" do
      it "works" do
        html = %Q{
          <h2>LICENSE</h2>
          <p>Some info about the license here</p>
          <p>More info</p>}
        filter = ReadmeScore::Document::Filter.new(html)
        filter.filtered_html!.strip.empty?.should == true
      end

      it "works and preserves other elements" do
        html = %Q{
          <h2>Other thing</h2>
          <p>Something</p>
          <h2>LICENSE</h2>
          <p>Some info about the license here</p>
          <p>More info</p>
          <h2>Something else</h2>
          <p>Hello</p>}
        filter = ReadmeScore::Document::Filter.new(html)
        string = filter.filtered_html!
        string.should == %Q{
          <h2>Other thing</h2>
          <p>Something</p>
          <h2>Something else</h2>
          <p>Hello</p>}
      end

      it "works with lesser headings afterwards" do
        html = %Q{
          <h2>LICENSE</h2>
          <p>Some info about the license here</p>
          <p>More info</p>
          <h4>Something else</h4>
          <p>Hello</p>}
        filter = ReadmeScore::Document::Filter.new(html)
        string = filter.filtered_html!
        string.should == %Q{
          <h4>Something else</h4>
          <p>Hello</p>}
      end
    end

    describe "removing contact" do
      it "works" do
        html = %Q{
          <h2>Contact</h2>
          <p>Some info about the contact here</p>
          <p>More info</p>}
        filter = ReadmeScore::Document::Filter.new(html)
        filter.filtered_html!.strip.empty?.should == true
      end

      it "works and preserves other elements" do
        html = %Q{
          <h2>Other thing</h2>
          <p>Something</p>
          <h2>Contact</h2>
          <p>Some info about the contact here</p>
          <p>More info</p>
          <h2>Something else</h2>
          <p>Hello</p>}
        filter = ReadmeScore::Document::Filter.new(html)
        string = filter.filtered_html!
        string.should == %Q{
          <h2>Other thing</h2>
          <p>Something</p>
          <h2>Something else</h2>
          <p>Hello</p>}
      end

      it "works with lesser headings afterwards" do
        html = %Q{
          <h2>Contact</h2>
          <p>Some info about the contact here</p>
          <p>More info</p>
          <h4>Something else</h4>
          <p>Hello</p>}
        filter = ReadmeScore::Document::Filter.new(html)
        string = filter.filtered_html!
        string.should == %Q{
          <h4>Something else</h4>
          <p>Hello</p>}
      end
    end

    describe "removing services with images" do
      it "works" do
        html = %Q{
          <h2>Repo</h2><a href="http://travis-ci.org/thing"><img src="travis" /></a><p>Hello</p>
        }.strip
        filter = ReadmeScore::Document::Filter.new(html)
        string = filter.filtered_html!
        string.strip.should == %Q{
          <h2>Repo</h2><p>Hello</p>
          }.strip
      end

      it "keeps non-image links" do
        html = %Q{
          <h2>Repo</h2><a href="http://travis-ci.org/thing">Travis</a><p>Hello</p>
        }.strip
        filter = ReadmeScore::Document::Filter.new(html)
        string = filter.filtered_html!
        string.strip.should == html
      end
    end

  end
end