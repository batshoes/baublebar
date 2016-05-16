require "baublebar/version"
require_relative 'zendesk_call'
require 'pry'
module Baublebar
  class GetZenDeskTickets

    def get_tickets(email)
      @users = GetUserRequest.new.call(email)
      if @users["users"].empty?
        "No User Available..."
      else
        @user_id = @users['id']
        @tickets = GetTicketRequest.new.call(email, @user_id)
        @tickets
      end
    end
  end
end
