class Survey::LineItemWidget < Apotomo::Widget

include Databasedotcom::Rails::Controller

  def display
    @line_item = options[:li_data]
    puts "options = #{options[:li_data]}"
    render
  end

end
