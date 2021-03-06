xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title  System.site_title + " : " + card.name.gsub(/^\*/,'')
    xml.description ""
    xml.link card_url(card)

    cards = if Card::Search === card
      card.item_cards( :limit => 25, :_keyword=>params[:_keyword] )
      card.results
    else
      [card]
    end
    view_changes = (card.name=='*recent changes')

    cards.each do |card|
      xml.item do
        xml.title card.name
        slot = get_slot(card, "main_1", "view", :inclusion_view_overrides => {
          :open => :rss_titled,
          :content => :open_content,
          :closed => :link
        })
        xml.description view_changes ? slot.render_rss_change : slot.render_open_content
        xml.pubDate card.revised_at.to_s(:rfc822)  #updated_at fails on virtual cards, because not all to_s's take args (just actual dates)
        xml.link card_url(card)
        xml.guid card_url(card)
      end
    end
    #xml.atom :link, :href=>card_url(card), :rel=>"self", :type=>"application/rss+xml"
  end
end

