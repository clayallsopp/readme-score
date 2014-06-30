require File.expand_path('../../spec_helper', __FILE__)

describe ReadmeScore::Document::Metrics do

  describe "#number_of_links" do
    it "works" do
      html = %Q{
        <a href="other_thing.html">Other thing</a>
        <p><a href="/other_thing.html">Other thing</a></p>
        <a href="http://google.com">Something there</a>}
      calc = ReadmeScore::Document::Metrics.new(html)
      calc.number_of_links.should == 3
    end
  end

  describe "#number_of_code_blocks" do
    it "works" do
      html = %Q{
  <p>You can initialize a <code>Formotion::Form</code> using either a hash (as above) or the DSL:</p>
  <div class="highlight highlight-ruby"><pre><span class="n">form</span> <span class="o">=</span> <span class="no">Formotion</span><span class="o">::</span><span class="no">Form</span><span class="o">.</span><span class="n">new</span>

  <span class="n">form</span><span class="o">.</span><span class="n">build_section</span> <span class="k">do</span> <span class="o">|</span><span class="n">section</span><span class="o">|</span>
    <span class="n">section</span><span class="o">.</span><span class="n">title</span> <span class="o">=</span> <span class="s2">"Title"</span>

    <span class="n">section</span><span class="o">.</span><span class="n">build_row</span> <span class="k">do</span> <span class="o">|</span><span class="n">row</span><span class="o">|</span>
      <span class="n">row</span><span class="o">.</span><span class="n">title</span> <span class="o">=</span> <span class="s2">"Label"</span>
      <span class="n">row</span><span class="o">.</span><span class="n">subtitle</span> <span class="o">=</span> <span class="s2">"Placeholder"</span>
      <span class="n">row</span><span class="o">.</span><span class="n">type</span> <span class="o">=</span> <span class="ss">:string</span>
    <span class="k">end</span>
  <span class="k">end</span>
  </pre></div>
  <p>Then attach it to a <code>Formotion::FormController</code> and you're ready to rock and roll:</p>
  <div class="highlight highlight-ruby"><pre><span class="vi">@controller</span> <span class="o">=</span> <span class="no">Formotion</span><span class="o">::</span><span class="no">FormController</span><span class="o">.</span><span class="n">alloc</span><span class="o">.</span><span class="n">initWithForm</span><span class="p">(</span><span class="n">form</span><span class="p">)</span>
  <span class="nb">self</span><span class="o">.</span><span class="n">navigationController</span><span class="o">.</span><span class="n">pushViewController</span><span class="p">(</span><span class="vi">@controller</span><span class="p">,</span> <span class="ss">animated</span><span class="p">:</span> <span class="kp">true</span><span class="p">)</span>
  </pre></div>

  <p>Pretty simple, right?</p>
      }
      calc = ReadmeScore::Document::Calculator.new(html)
      calc.number_of_code_blocks.should == 2
    end
  end

  describe "#code_block_to_paragraph_ratio" do
    it "works" do
      html = %Q{
  <p>You can initialize a <code>Formotion::Form</code> using either a hash (as above) or the DSL:</p>
  <div class="highlight highlight-ruby"><pre><span class="n">form</span> <span class="o">=</span> <span class="no">Formotion</span><span class="o">::</span><span class="no">Form</span><span class="o">.</span><span class="n">new</span>

  <span class="n">form</span><span class="o">.</span><span class="n">build_section</span> <span class="k">do</span> <span class="o">|</span><span class="n">section</span><span class="o">|</span>
    <span class="n">section</span><span class="o">.</span><span class="n">title</span> <span class="o">=</span> <span class="s2">"Title"</span>

    <span class="n">section</span><span class="o">.</span><span class="n">build_row</span> <span class="k">do</span> <span class="o">|</span><span class="n">row</span><span class="o">|</span>
      <span class="n">row</span><span class="o">.</span><span class="n">title</span> <span class="o">=</span> <span class="s2">"Label"</span>
      <span class="n">row</span><span class="o">.</span><span class="n">subtitle</span> <span class="o">=</span> <span class="s2">"Placeholder"</span>
      <span class="n">row</span><span class="o">.</span><span class="n">type</span> <span class="o">=</span> <span class="ss">:string</span>
    <span class="k">end</span>
  <span class="k">end</span>
  </pre></div>
  <p>Then attach it to a <code>Formotion::FormController</code> and you're ready to rock and roll:</p>
  <div class="highlight highlight-ruby"><pre><span class="vi">@controller</span> <span class="o">=</span> <span class="no">Formotion</span><span class="o">::</span><span class="no">FormController</span><span class="o">.</span><span class="n">alloc</span><span class="o">.</span><span class="n">initWithForm</span><span class="p">(</span><span class="n">form</span><span class="p">)</span>
  <span class="nb">self</span><span class="o">.</span><span class="n">navigationController</span><span class="o">.</span><span class="n">pushViewController</span><span class="p">(</span><span class="vi">@controller</span><span class="p">,</span> <span class="ss">animated</span><span class="p">:</span> <span class="kp">true</span><span class="p">)</span>
  </pre></div>

  <p>Pretty simple, right?</p>
      }
      calc = ReadmeScore::Document::Metrics.new(html)
      calc.code_block_to_paragraph_ratio.should == (2.0 / 3.0)
    end
  end

  describe "#number_of_non_code_sections" do
    it "works" do
      html = %Q{
<p>Paragraph</p>
<p>Paragraph2</p>
<div class="highlight highlight-yaml"><pre><span class="l-Scalar-Plain">additional_guides</span><span class="p-Indicator">:</span>
 <span class="p-Indicator">-</span> <span class="l-Scalar-Plain">https://github.com/magicalpanda/MagicalRecord/wiki/Installation</span>
 <span class="p-Indicator">-</span> <span class="l-Scalar-Plain">https://github.com/CocoaPods/CocoaPods/wiki/A-pod-specification</span>
 <span class="p-Indicator">-</span> <span class="l-Scalar-Plain">docs/Getting_started.md</span>
</pre></div>
<ol>
  <li></li>
  <li></li>
</ol>
<ul>
  <li></li>
  <li></li>
</ul>
      }
      calc = ReadmeScore::Document::Metrics.new(html)
      calc.number_of_non_code_sections.should == 4
    end
  end
end