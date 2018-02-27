class ComicsController < ApplicationController

    def index
        @comics = Comic.all
        render json: @comics
    end

end
