ROOT = File.dirname(__FILE__)

$:.unshift(File.join(ROOT, 'lib'))
require 'readme-score'

require "bundler/gem_tasks"

require 'json'
require 'ostruct'
require 'fileutils'

require 'dotenv'
Dotenv.load

def loaded_seed_data
  JSON.parse(IO.read("data/seed.json")).map {|d|
    OpenStruct.new(d).tap { |o|
      o.repo_name = o.readme.split("/")[-1]
      o.cache_path = File.join(ROOT, "data", "cache", "#{o.repo_name}.md")
    }
  }
end

def seed_data(d)
  buffer = "------\n"
  buffer << d.output_metrics
  buffer << "------\n"
  buffer << d.html
end

require 'statsample'

def analyze(document_tuples)
  document_tuples.each {|seed, d|
    # puts seed_data(d)
  }
  repo_names = document_tuples.map(&:first).map(&:repo_name)
  scores = document_tuples.map(&:first).map(&:score)
  documents = document_tuples.map(&:last)

  Statsample::Analysis.store(Statsample::Regression::Multiple) do |suite|
    metric_hash = {}
    ReadmeScore::Document::Metrics::EQUATION_METRICS.each do |metric|
      puts metric
      metric_hash[metric] = documents.map(&:text_metrics).map(&metric.to_proc).to_scale
    end
    puts metric_hash
    ds = suite.dataset(metric_hash)
    ds['score'] = scores.to_scale
    @regression = suite.lr(ds, 'score')
  end

  Statsample::Analysis.run_batch

  equation = ReadmeScore::Equation.new(@regression.constant, @regression.coeffs)

  differentials = []
  documents.each.with_index {|d, i|
    puts repo_names[i]
    predection = scores[i]
    calculated = equation.value_for(d.text_metrics)
    differentials << (predection - calculated).abs
    puts "Predection: #{predection}; Equation: #{calculated}"
  }
  puts "Average diff: #{differentials.to_scale.mean}"

  ReadmeScore::Equation.save_as_default!(equation)
end

desc "Analyze seed data"
task :seed do
  seed_data = loaded_seed_data
  documents = seed_data.map {|d|
    [d, ReadmeScore::Document.load(d.readme)]
  }
  analyze(documents)
end

task :seed_from_cache do
  seed_data = loaded_seed_data
  #seed_data = [seed_data[0]]
  documents = seed_data.map {|d|
    cached_markdown = IO.read(d.cache_path)
    html = ReadmeScore::Document::Parser.new(cached_markdown).to_html
    [d, ReadmeScore::Document.new(html)]
  }
  analyze(documents)
end

desc "Cache the seed data locally"
task :cache_seed do
  seed_data = loaded_seed_data
  seed_data.each {|d|
    FileUtils.mkdir_p(File.dirname(d.cache_path))
    loader = ReadmeScore::Document::Loader.new(d.readme)
    loader.load!
    File.open(d.cache_path, 'w') {|f| f.write(loader.response.body) }
  }
end

task :example do
  d = ReadmeScore::Document.load("http://github.com/usepropeller/applebot")
  puts d.score.total_score
end

task :compare_seeds do
  seed_data = loaded_seed_data
  documents = seed_data.map {|d|
    [d, ReadmeScore::Document.load(d.readme)]
  }
  differentials = []
  documents.each {|seed, d|
    puts seed.readme
    predection = seed.score
    calculated = d.score.total_score
    differentials << (predection - calculated).abs
    puts "Predection: #{predection}; Equation: #{calculated}"
  }
  puts "Average diff: #{differentials.to_scale.mean}"
end

task :console do
  require 'irb'
  ARGV.clear
  IRB.start
end