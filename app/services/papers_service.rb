class PapersService
  def call(profile, from, to)
    conn = Faraday.new(url: 'https://stormy-brushlands-34577.herokuapp.com') do |f|
      f.response(:json)
      f.adapter Faraday.default_adapter
    end

    response = conn.get do |req|
      req.url '/api/papers', profile: profile, from: from, to: to
    end

    response.body
  end
end