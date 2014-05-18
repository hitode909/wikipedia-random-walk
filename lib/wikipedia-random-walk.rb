require 'open-uri'
require 'uri'
require 'nokogiri'

class WikipediaRandomWalker
  attr_accessor :keyword, :interval
  def initialize(keyword, interval =1)
    @keyword = keyword
    @interval = interval
    @history = []
  end

  def each
    loop do
      step
      yield keyword
      sleep interval
    end
  end

  def step
    @keyword = next_keywords.sample
    @history.push @keyword
  rescue => error
    # 例外出たら1個戻る
    @keyword = @history.pop
    unless @keyword
      # 戻れなくなったらランダムに飛ぶ
      @keyword = '特別:おまかせ表示'
    end
    step
  end

  private

  def next_keywords
    # pに入ってるほうがおもしろい
    links = page.search('#mw-content-text p a')

    if links.empty?
      links = page.search('#mw-content-text a')
    end

    links.map { |a|
      matched = a.attr('href').match(%r{wiki/([^#]+)})
      if matched and matched[1].length > 0
        URI.unescape(matched[1]).strip
      end
    }.compact.delete_if{|word|
      # ファイル: とか消す
      # 1977年とかおもしろくないので消す
      # 過去に表示したところには行かない
      word.match(/:/) or word.match(/[年月日]/) or @history.include? word
    }
  end

  def page
    Nokogiri open(uri_for(keyword))
  end

  def uri_for(keyword)
    "http://ja.wikipedia.org/wiki/#{ URI.escape(keyword) }"
  end
end
