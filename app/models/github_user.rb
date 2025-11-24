class GithubUser
  AUTHORIZED_ORG_NAME = 'wustl-oncology'
  AUTHORIZED_ORG_ID = 124_916_110

  def initialize(username)
    @username = username
    @in_authorized_org = nil
  end

  def belongs_to_authorized_org?
    if in_authorized_org.nil?
      org_response = make_request
      @in_authorized_org = check_orgs(org_response)
    else
      in_authorized_org
    end
  end

  private

  attr_reader :username, :in_authorized_org

  def make_request
    uri = URI("https://api.github.com/users/#{username}/orgs")
    req = Net::HTTP::Get.new(uri)
    req['Accept'] = 'application/vnd.github+json'
    req['X-GitHub-Api-Version'] = '2022-11-28'

    Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
      resp = http.request(req)
      case resp
      when Net::HTTPSuccess
        JSON.parse(resp.body)
      else
        []
      end
    end
  end

  def check_orgs(orgs)
    orgs.any? { |org| org['login'] == AUTHORIZED_ORG_NAME && org['id'] == AUTHORIZED_ORG_ID }
  end
end
