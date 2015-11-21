module Api
  class ApiController < ApplicationController

    def respond(object = {}, status = :ok)
      render json: object, status: status
    end

  end
end
