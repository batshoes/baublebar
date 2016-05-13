require 'zendesk_api'
class GetUserRequest
  def call(email)
    client.users.search(:query => "#{email}").first
  end
end

class GetTicketRequest
  def call(email, user_id)
    @user_id = user_id
    @tickets = client.search(:query => "#{email}", :reload => true)
    parse_tickets
  end

  def parse_tickets
    ticket_array = []
    @tickets.each {|ticket| 

      ticket_hash = Hash[ticket]
      
      if ticket_hash['result_type'] == "ticket" &&
           ticket_hash['requester_id'] == @user_id
        
        ticket_hash['zendesk_url'] = ticket_hash['url']
                                      .chomp(".json")
        ticket_array << ticket_hash
      end
    }

    ticket_array = ticket_array.sort_by { |hsh| hsh['id'] } .reverse  
    
    if ticket_array.length == 0
      "No Tickets Available"
    elsif ticket_array.length < 3
      ticket_array
    else
      ticket_array[0..2]
    end
  end
end
 
private



def client
  ZendeskAPI::Client.new do |config|
    # Mandatory:

    config.url = "#{ENV['ZENDESK_URL']}" # e.g. https://mydesk.zendesk.com/api/v2

    # Basic / Token Authentication
    config.username = "#{ENV['ZENDESK_LOGIN_EMAIL']}"

    # Choose one of the following depending on your authentication choice
    config.token = "#{ENV['ZENDESK_API_KEY']}"
    # config.password = "#{ENV['ZENDESK_LOGIN_PASSWORD']}"

    # OAuth Authentication
    # config.access_token = "your OAuth access token"

    # Optional:

    # Retry uses middleware to notify the user
    # when hitting the rate limit, sleep automatically,
    # then retry the request.
    config.retry = true

    # Logger prints to STDERR by default, to e.g. print to stdout:
    require 'logger'
    config.logger = Logger.new(STDOUT)

    # Changes Faraday adapter
    # config.adapter = :patron

    # Merged with the default client options hash
    # config.client_options = { :ssl => false }

    # When getting the error 'hostname does not match the server certificate'
    # use the API at https://yoursubdomain.zendesk.com/api/v2
  end
end
