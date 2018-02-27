class Comic
    include HenkComics

    def self.all
        HenkComics.list_commics
    end
    
end
