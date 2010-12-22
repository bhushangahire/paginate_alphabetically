module PaginateAlphabetically
  module ActiveRecord
    def paginate_alphabetically(params)
      @attribute = params[:by]
      self.extend ClassMethods
    end

    module ClassMethods
      def pagination_letters
        all.sort_by{|obj| obj.send(@attribute).upcase}.group_by {|group| group.send(@attribute)[0].chr.upcase}.keys
      end

      def first_letter
        first_instance = find(:first, :order => @attribute, :conditions => ["#{@attribute.to_s} >= ?", 'a'])
        return 'A' if first_instance.nil?
        first_instance.send(@attribute)[0].chr.upcase
      end

      def alphabetical_group(letter = nil)
        letter ||= first_letter
        find(:all, :conditions => ["LOWER(#{@attribute.to_s}) LIKE ?", "#{letter.downcase}%"], :order => @attribute)
      end
    end
  end
end
