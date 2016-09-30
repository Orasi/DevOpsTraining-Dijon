require 'rest-client'
  class MustardClient
    attr_accessor :mustard_url, :user_token

    @user_token

    def initialize
      @mustard_url = 'localhost:8081'
    end

    def set_user_token token
      @user_token = token
    end



    def login username, password

      url = @mustard_url + '/authenticate'

      begin
        r = RestClient.post url, {username: username, password: password}
      rescue RestClient::ExceptionWithResponse => e
        return JSON.parse(e.response)
      end

      return JSON.parse(r)

    end

    def projects ut

      url = @mustard_url + '/projects'

      begin
        r = RestClient.get url, {'User-Token' => ut}
      rescue RestClient::ExceptionWithResponse => e
        return JSON.prase(e.response)
      end

      return JSON.parse(r)
    end

  end
