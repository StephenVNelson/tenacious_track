module CoreExtensions
  module String
    module CssPrep
      def cssize
        thing = self.downcase
        thing = thing.split(' ')
        thing = thing.join('-')
      end
    end
  end
end
String.include CoreExtensions::String::CssPrep
