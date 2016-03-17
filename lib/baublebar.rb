require "baublebar/version"
require_relative 'zendesk_call'
class TicketsController
  module Baublebar
    class GetZenDeskTickets

      def get_tickets(email)
        @user = GetUserRequest.new.call(email)
        @user_id = @user['id']
        @tickets = GetTicketRequest.new.call(email, @user_id)
        @tickets
      end
    end
  end
end